//
//  GenericTableViewController.h
//  barfbag
//
//  Created by Lincoln Six Echo on 04.12.12.
//  Copyright (c) 2012 appdoctors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHudDelegate.h"
#import "ATMHud.h"

@class AppDelegate;

@interface GenericTableViewController : UITableViewController <ATMHudDelegate> {

    ATMHud *hud;

}

@property( nonatomic, retain ) ATMHud *hud;

- (void) showHudWithCaption:(NSString*)caption hasActivity:(BOOL)hasActivity;
- (void) hideHud;

- (AppDelegate*) appDelegate;
- (UIColor*) themeColor;
- (UIColor*) brightColor;
- (UIColor*) brighterColor;
- (UIColor*) darkColor;
- (UIImage*) imageGradientWithSize:(CGSize)imageSize color1:(UIColor*)color1 color2:(UIColor*)color2;

@end
