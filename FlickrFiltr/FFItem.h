//
//  FFItem.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FFItem : NSObject

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL applyFilterSwitcherValue;
@property (nonatomic, assign) float downloadProgress;

+(FFItem *) itemWithDictionary: (NSDictionary *)dictionary;

@end
