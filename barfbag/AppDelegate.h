//
//  AppDelegate.h
//  barfbag
//
//  Created by Lincoln Six Echo on 02.12.12.
//  Copyright (c) 2012 appdoctors. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {

    UIWindow *window;
    UITabBarController *tabBarController;
    UIColor *themeColor;
}

@property( strong, nonatomic ) UIWindow *window;
@property( strong, nonatomic ) UITabBarController *tabBarController;
@property( strong, nonatomic ) UIColor *themeColor;

@end
