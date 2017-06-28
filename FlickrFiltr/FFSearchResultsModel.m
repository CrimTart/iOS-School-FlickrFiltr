//
//  FFSearchResultsModel.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "FFSearchResultsModel.h"
#import "ImageDownloadOperation.h"
#import "FFImageProcessing.h"
#import "FFNetworkManager.h"

@interface FFSearchResultsModel() <NSURLSessionDownloadDelegate>

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, ImageDownloadOperation *> *imageOperations;
@property (nonatomic, strong) NSOperationQueue *imagesQueue;
@property (nonatomic, strong) FFNetworkManager *networkManager;
@property (nonatomic, strong) NSURLSession *session;

@end

static const char key[] = "6a719063cc95dcbcbfb5ee19f627e05e";

@implementation FFSearchResultsModel

-(instancetype) init {
    self = [super init];
    if (self) {
        _imageOperations = [NSMutableDictionary new];
        _imagesQueue = [NSOperationQueue new];
        _imagesQueue.name = @"imagesQueue";
        _imagesQueue.qualityOfService = QOS_CLASS_DEFAULT;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _imageCache = [NSCache new];
        _page = 1;
        _items = [NSArray new];
    }
    return self;
}

-(void) getItemsForRequest: (NSString*)request withCompletionHandler: (void (^)(void))completionHandler {
    NSString *normalizedRequest = [request stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *escapedString = [normalizedRequest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *apiKey = [NSString stringWithFormat:@"&api_key=%@", [NSString stringWithUTF8String:key]];
    NSString *urls = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=10&tags=%@%@&page=%lu", escapedString, apiKey, self.page];
    NSURL *url = [NSURL URLWithString:urls];
    [FFNetworkManager getModelWithSession:self.session fromURL:url withCompletionHandler:^(NSDictionary *json) {
        NSArray *newItems = [self parseData:json];
        self.items = [self.items arrayByAddingObjectsFromArray:newItems];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });
    }];
    self.page++;
}

-(NSArray *) parseData: (NSDictionary *)json {
    if (json) {
        NSMutableArray *parsingResults = [NSMutableArray new];
        for (NSDictionary * dict in json[@"photos"][@"photo"]) {
            [parsingResults addObject:[FFItem itemWithDictionary:dict]];
        }
        return [parsingResults copy];
    } else {
        return nil;
    }
}

-(void) loadImageForIndexPath: (NSIndexPath *)indexPath withCompletionHandler: (void(^)(void))completionHandler {
    FFItem *currentItem = self.items[indexPath.row];
    if (![self.imageCache objectForKey:currentItem.photoURL]) {
        if (!self.imageOperations[indexPath]) {
            ImageDownloadOperation *imageDownloadOperation = [ImageDownloadOperation new];
            imageDownloadOperation.indexPath = indexPath;
            imageDownloadOperation.item = currentItem;
            imageDownloadOperation.session = self.session;
            imageDownloadOperation.imageCache = self.imageCache;
            imageDownloadOperation.name = [NSString stringWithFormat:@"imageDownloadOperation for index %lu",indexPath.row];
            imageDownloadOperation.completionBlock = ^{
                completionHandler();
            };
            [self.imageOperations setObject:imageDownloadOperation forKey:indexPath];
            [self.imagesQueue addOperation:imageDownloadOperation];
        } else {
            if (self.imageOperations[indexPath].status == FFImageStatusCancelled || self.imageOperations[indexPath].status == FFImageStatusNone) {
                [self.imageOperations[indexPath] resume];
            }
        }
    } else {
        completionHandler();
    }
}

-(void) filterItemAtIndexPath: (NSIndexPath *)indexPath filter: (BOOL)filter withCompletionBlock: (void(^)(UIImage *image)) completion {
    if (filter == YES) {
        FFItem *currentItem = self.items[indexPath.row];
        currentItem.applyFilterSwitcherValue = YES;
        NSOperation *filterOperation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *filteredImage = [FFImageProcessing applyFilterToImage:[self.imageCache objectForKey:indexPath]];
            completion(filteredImage);
        }];
        [filterOperation addDependency:[self.imageOperations objectForKey:indexPath]];
        [self.imagesQueue addOperation:filterOperation];
        NSLog(@"state changed for index path %lu",indexPath.row);
    } else {
        self.items[indexPath.row].applyFilterSwitcherValue = NO;
        UIImage *originalImage = [self.imageCache objectForKey:indexPath];
        completion(originalImage);
        NSLog(@"state changed for index path %lu",indexPath.row);
    }
}

-(void) cancelOperations {
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id object, BOOL *stop) {
        ImageDownloadOperation *operation = (ImageDownloadOperation *)object;
        if (operation.isExecuting) {
            [operation pause];
        }
    }];
}

-(void) clearModel {
    self.items = [NSArray new];
    [self.imageCache removeAllObjects];
    self.page = 0;
    [self.imageOperations removeAllObjects];
}

-(void) URLSession: (NSURLSession *)session downloadTask: (NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL: (NSURL *)location {
}

@end
