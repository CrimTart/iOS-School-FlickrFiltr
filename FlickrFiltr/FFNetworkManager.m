//
//  FFNetworkManager.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "FFNetworkManager.h"

@implementation FFNetworkManager

+(void) getModelWithSession: (NSURLSession *)session
                    fromURL: (NSURL *)url
      withCompletionHandler: (void (^)(NSDictionary *json))completionHandler {
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!jsonError) {
                completionHandler(json);
            } else {
                NSLog(@"ERROR PARSING JSON %@", error.userInfo);
            }
        } else if (error) {
            NSLog(@"error while downloading data %@", error.userInfo);
        }
    }];
    task.priority = NSURLSessionTaskPriorityHigh;
    [task resume];
}

+(NSURLSessionTask *) downloadImageWithSession: (NSURLSession *)session
                                       fromURL: (NSURL *)url
                         withCompletionHandler: (void (^)(NSData *data))completionHandler {
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSError *fileError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:location error:&fileError];
        completionHandler(data);
    }];
    [task resume];
    return task;
}


@end
