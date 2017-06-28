//
//  FFTableViewController.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFSearchResultsModel;

@interface FFTableViewController : UITableViewController

-(instancetype) initWithModel: (FFSearchResultsModel *)model;

@end
