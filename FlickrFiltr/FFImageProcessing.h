//
//  FFImageProcessing.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FFImageProcessing : NSObject

+(UIImage *) applyFilterToImage: (UIImage *)origin;
+(UIImage *) cropImage: (UIImage *)origin toSize: (CGSize)itemSize;

@end
