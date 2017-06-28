//
//  FFTableViewCell.h
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)didClickSwitch:(UISwitch *)switcher atIndexPath:(NSIndexPath *)indexPath;

@end

@interface FFTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign, readonly) CGSize imageViewSize;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UISwitch *applyFilterSwitch;
@property (nonatomic, strong) UILabel *applyFilterLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<CellDelegate> delegate;

@end
