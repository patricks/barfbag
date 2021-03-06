//
//  AppDelegate.h
//  barfbag
//
//  Created by Lincoln Six Echo on 02.12.12.
//  Copyright (c) 2012 appdoctors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BarfBagParser.h"
#import "ATMHudDelegate.h"
#import "BBJSONConnectOperation.h"
#import "BBJSONConnector.h"
#import "MasterConfig.h"

@class ATMHud;
@class GenericTabBarController;
@class Conference;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,BarfBagParserDelegate,ATMHudDelegate,BBJSONConnectOperationDelegate,MasterConfigDelegate> {

    UIWindow *window;
    GenericTabBarController *tabBarController;
    UIColor *themeColor;
    NSArray *scheduledConferences;
	ATMHud *hud;
    NSArray *semanticWikiAssemblies;
    NSArray *semanticWikiWorkshops;
    NSString *videoStreamsHtml;
    NSDictionary *masterConfiguration;
    UIView *flashyView;
}

@property( strong, nonatomic ) UIWindow *window;
@property( strong, nonatomic ) GenericTabBarController *tabBarController;
@property( strong, nonatomic ) UIColor *themeColor;
@property( retain, nonatomic ) NSArray *scheduledConferences;
@property( retain, nonatomic ) NSArray *semanticWikiAssemblies;
@property( retain, nonatomic ) NSArray *semanticWikiWorkshops;
@property( retain, nonatomic ) NSString *videoStreamsHtml;
@property( retain, nonatomic ) NSDictionary *masterConfiguration;
@property( retain, nonatomic ) UIView *flashyView;

@property( nonatomic, retain ) ATMHud *hud;

- (BOOL) isConfigOnForKey:(NSString*)key defaultValue:(BOOL)isOn;
- (UIFont*) fontWithType:(CustomFontType)fontType andPointSize:(CGFloat)pointSize;

- (void) signalCloudSyncToUser;
- (void) activateCloudSupport;

- (void) configLoadCached;
- (void) emptyAllFilesFromFolder:(NSString*)folderPath;

- (void) allDataRefresh;
- (void) allDataLoadCached;

- (void) barfBagImagesRefresh;
- (void) barfBagRefresh;
- (void) barfBagLoadCached;
- (void) semanticWikiRefresh;
- (void) semanticWikiLoadCached;

- (NSString*) barfBagCurrentDataVersion;

- (void) showHudWithCaption:(NSString*)caption hasActivity:(BOOL)hasActivity;
- (void) hideHud;

- (UIColor*) backgroundColor;
- (UIColor*) brightColor;
- (UIColor*) brighterColor;
- (UIColor*) darkColor;
- (UIColor*) darkerColor;
- (UIColor*) backBrightColor;

- (Conference*) conference;

@end
