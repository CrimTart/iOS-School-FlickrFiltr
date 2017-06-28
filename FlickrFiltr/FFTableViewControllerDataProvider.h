//
//  FFTableViewControllerDataProvider.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFTableViewController.h"
@import UIKit;

@class FFSearchResultsModel;

@interface FFTableViewControllerDataProvider : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

-(instancetype) initWithModel: (FFSearchResultsModel *)model;

@end
