//
//  AppDelegate.m
//  FlickrFiltr
//
//  Created by Admin on 23.06.17.
//  Copyright © 2017 ilya. All rights reserved.
//

#import "AppDelegate.h"
#import "FFTableViewController.h"
#import "FFSearchResultsModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL) application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    FFSearchResultsModel *model = [FFSearchResultsModel new];
    FFTableViewController *tableVC = [[FFTableViewController alloc] initWithModel:model];
    self.window.rootViewController = tableVC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
