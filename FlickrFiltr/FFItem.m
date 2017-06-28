//
//  FFItem.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "FFItem.h"

@implementation FFItem

+(FFItem *) itemWithDictionary: (NSDictionary *)dictionary {
    FFItem *item = [FFItem new];
    item.title = dictionary[@"title"];
    NSString *secret = dictionary[@"secret"];
    NSString *server = dictionary[@"server"];
    NSString *farm = dictionary[@"farm"];
    NSString *idd = dictionary[@"id"];
    
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_h.jpg", farm, server, idd, secret];
    
    item.photoURL = [NSURL URLWithString:url];
    
    item.applyFilterSwitcherValue = NO;
    
    return item;
}


@end
