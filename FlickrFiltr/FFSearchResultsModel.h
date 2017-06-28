//
//  FFSearchResultsModel.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFItem.h"
#import "FFTableViewController.h"

@class ImageDownloadOperation;
@class FFNetworkManager;

@interface FFSearchResultsModel : NSObject

@property (nonatomic, copy) NSArray<FFItem *> *items;
@property (nonatomic, strong) NSString *searchRequest;
@property (nonatomic, strong) NSCache *imageCache;

-(void) getItemsForRequest: (NSString *)request withCompletionHandler: (void (^)(void))completionHandler;
-(void) loadImageForIndexPath: (NSIndexPath *)indexPath  withCompletionHandler: (void(^)(void))completionHandler;
-(void) cancelOperations;
-(void) filterItemAtIndexPath: (NSIndexPath *)indexPath  filter: (BOOL)filter withCompletionBlock: (void(^)(UIImage *image))completion;
-(void) clearModel;

@end
