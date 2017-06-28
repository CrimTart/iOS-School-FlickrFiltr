//
//  FFNetworkManager.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFNetworkManager : NSObject

+(void) getModelWithSession: (NSURLSession *)session fromURL: (NSURL *)url withCompletionHandler: (void (^)(NSDictionary * json))completionHandler;
+(NSURLSessionTask *) downloadImageWithSession: (NSURLSession *)session fromURL: (NSURL *)url withCompletionHandler: (void (^)(NSData *data))completionHandler;

@end
