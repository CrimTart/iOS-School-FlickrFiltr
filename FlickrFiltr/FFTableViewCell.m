//
//  FFTableViewCell.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "FFTableViewCell.h"
#import "Masonry.h"

@interface FFTableViewCell()

@property (nonatomic, assign, readwrite) CGSize imageViewSize;

@end

@implementation FFTableViewCell

+(BOOL) requiresConstraintBasedLayout {
    return YES;
}

-(instancetype) initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        _photoImageView = [UIImageView new];
        _photoImageView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.hidden = YES;
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.center = self.contentView.center;
        
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        _applyFilterLabel = [UILabel new];
        _applyFilterLabel.text = @"Apply filter";
        _applyFilterSwitch = [UISwitch new];
        [_applyFilterSwitch addTarget:self action:@selector(filterSwitcherValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:_photoImageView];
        [self.contentView addSubview:_activityIndicator];
        [self.contentView addSubview:_progressView];
        [self.contentView addSubview:_applyFilterLabel];
        [self.contentView addSubview:_applyFilterSwitch];
    }
    return self;
}

-(void) updateConstraints {
    CGRect frame = self.contentView.frame;
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(-12);
        if (CGRectGetWidth(frame) > CGRectGetHeight(frame)) {
            make.size.mas_equalTo(@312);
        } else {
            make.size.mas_equalTo(self.contentView.mas_width).sizeOffset(CGSizeMake(-8, -8));
        }
        self.photoImageView.layer.cornerRadius = 20;
        self.photoImageView.layer.masksToBounds = YES;
    }];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.photoImageView.mas_centerX);
        make.centerY.equalTo(self.photoImageView.mas_centerY);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
    }];
    [self.applyFilterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoImageView.mas_bottom).with.offset(8);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.width.equalTo(@110);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
    }];
    [self.applyFilterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoImageView.mas_bottom).with.offset(4);
        make.left.equalTo(self.applyFilterLabel.mas_right).with.offset(8);
    }];
    
    [super updateConstraints];
}

-(void) prepareForReuse {
    self.photoImageView.image = nil;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    [super prepareForReuse];
}

-(IBAction) filterSwitcherValueChanged: (id)sender {
    [self.delegate didClickSwitch:sender atIndexPath:self.indexPath];
}

@end
