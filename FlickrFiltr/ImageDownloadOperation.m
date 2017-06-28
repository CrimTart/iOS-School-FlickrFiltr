//
//  ImageDownloadOperation.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "ImageDownloadOperation.h"
#import "FFItem.h"
#import "FFSearchResultsModel.h"
#import "FFNetworkManager.h"
#import "FFImageProcessing.h"

@interface ImageDownloadOperation()

@property (nonatomic, strong) NSOperationQueue *innerQueue;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) NSOperation *downloadOperation;
@property (nonatomic, strong) NSOperation *cropOperation;
@property (nonatomic, strong) NSOperation *applyFilterOperation;
@property (nonatomic, strong) __block UIImage *downloadedImage;

@end

@implementation ImageDownloadOperation

-(instancetype) init {
    self = [super init];
    if (self) {
        _status = FFImageStatusNone;
        _innerQueue = [NSOperationQueue new];
        _innerQueue.name = [NSString stringWithFormat:@"innerQueue for index %lu", self.indexPath.row];
        _imageViewSize = CGSizeMake(312, 312);
    }
    return self;
}

-(void) main {
    NSLog(@"operation %ld began", (long)self.indexPath.row);
    dispatch_semaphore_t imageDownloadedSemaphore = dispatch_semaphore_create(0);
    
    self.downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        __weak typeof(self) weakself = self;
        weakself.task = [FFNetworkManager downloadImageWithSession:self.session fromURL:self.item.photoURL withCompletionHandler:^(NSData *data) {
            weakself.downloadedImage = [UIImage imageWithData:data];
            weakself.status = FFImageStatusDownloaded;
            dispatch_semaphore_signal(imageDownloadedSemaphore);
        }];
    }];
    
    self.cropOperation = [NSBlockOperation blockOperationWithBlock:^{
        self.downloadedImage = [FFImageProcessing cropImage:self.downloadedImage toSize:self.imageViewSize];
    }];
    [self.cropOperation addDependency:self.downloadOperation];
    
    self.applyFilterOperation = [NSBlockOperation blockOperationWithBlock:^{
        self.downloadedImage = [FFImageProcessing applyFilterToImage:self.downloadedImage];
    }];
    [self.applyFilterOperation addDependency:self.cropOperation];
    
    self.status = FFImageStatusDownloading;
    NSLog(@"operation %ld downloading", (long)self.indexPath.row);
    [self.innerQueue addOperation:self.downloadOperation];
    
    __weak typeof(self) weakself = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, nil);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        float received = weakself.task.countOfBytesReceived;
        float expected = weakself.task.countOfBytesExpectedToReceive;
        if (expected!=0) {
            weakself.item.downloadProgress = received/expected;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProgressNotification" object:self.indexPath];
            });
        }
    });
    dispatch_resume(timer);
    
    dispatch_semaphore_wait(imageDownloadedSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_cancel(timer);
    NSLog(@"operation %ld downloaded", (long)self.indexPath.row);
    
    [self.innerQueue addOperations:@[self.cropOperation] waitUntilFinished:YES];
    self.status = FFImageStatusCropped;
    NSLog(@"operation %ld cropped", (long)self.indexPath.row);
    
    if (self.downloadedImage) {
        [self.imageCache setObject:self.downloadedImage forKey:self.indexPath];
    } else {
        self.status = FFImageStatusNone;
    }
    NSLog(@"operation %ld finished", (long)self.indexPath.row);
}

-(void) resume {
    self.innerQueue.suspended = NO;
    [self.task resume];
    NSLog(@"operation %ld resumed", (long)self.indexPath.row);
}

-(void) pause {
    self.innerQueue.suspended = YES;
    self.status = FFImageStatusCancelled;
    [self.task suspend];
    [self cancel];
    NSLog(@"operation %ld paused", (long)self.indexPath.row);
}

@end
