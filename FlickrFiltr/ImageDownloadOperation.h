//
//  ImageDownloadOperation.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class FFItem;
@class FFNetworkManager;

typedef NS_ENUM(NSInteger, FFImageStatus) {
    FFImageStatusDownloading,
    FFImageStatusDownloaded,
    FFImageStatusFiltered,
    FFImageStatusCropped,
    FFImageStatusCancelled,
    FFImageStatusNone
};

@interface ImageDownloadOperation : NSOperation

@property (nonatomic, weak) FFItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) FFImageStatus status;
@property (nonatomic, assign) CGSize imageViewSize;
@property (nonatomic, weak) NSCache *imageCache;
@property (nonatomic, weak) NSURLSession *session;

-(void) pause;
-(void) resume;


@end
