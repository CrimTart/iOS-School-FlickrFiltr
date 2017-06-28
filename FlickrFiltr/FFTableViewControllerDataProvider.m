//
//  FFTableViewControllerDataProvider.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "FFTableViewControllerDataProvider.h"
#import "FFSearchResultsModel.h"
#import "FFTableViewCell.h"

static NSString *const reuseID = @"FFTableViewCell";

@interface FFTableViewControllerDataProvider () <CellDelegate>

@property (nonatomic, weak) FFSearchResultsModel *model;

@end

@implementation FFTableViewControllerDataProvider

-(instancetype) initWithModel: (FFSearchResultsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

#pragma mark - TableViewDataSource

-(NSInteger) numberOfSectionsInTableView: (UITableView *)tableView {
    return self.model.items.count == 0 ? 0 : 1;
}

-(NSInteger) tableView: (UITableView *)tableView  numberOfRowsInSection: (NSInteger)section {
    return self.model.items.count;
}

-(UITableViewCell *) tableView: (UITableView *)tableView  cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    FFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseID forIndexPath:indexPath];
    cell.delegate = self;
    FFItem *currentItem = self.model.items[indexPath.row];
    cell.indexPath = indexPath;
    [cell.applyFilterSwitch setOn:currentItem.applyFilterSwitcherValue];
    if (![self.model.imageCache objectForKey:indexPath]) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            [self.model loadImageForIndexPath:indexPath withCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    FFTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.photoImageView.image = [self.model.imageCache objectForKey: indexPath];
                    [cell.activityIndicator stopAnimating];
                    cell.progressView.hidden = YES;
                });
            }];
        }
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        cell.progressView.hidden = NO;
        cell.progressView.progress = currentItem.downloadProgress;
    } else {
        cell.photoImageView.image = [self.model.imageCache objectForKey:indexPath];
        if (currentItem.applyFilterSwitcherValue == YES) {
            [self.model filterItemAtIndexPath:indexPath filter:YES withCompletionBlock:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    FFTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    cell.photoImageView.image = image;
                });
            }];
        }
    }
    return cell;
}

#pragma mark - CellDelegate

-(void) didClickSwitch: (UISwitch *)switcher atIndexPath: (NSIndexPath *)indexPath {
    [self.model filterItemAtIndexPath:indexPath filter:switcher.on withCompletionBlock:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FFTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.photoImageView.image = image;
        });
    }];
}

@end
