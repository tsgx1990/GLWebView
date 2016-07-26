//
//  GLWebViewConfiguration.h
//  GLWebViewDemo
//
//  Created by guanglong on 16/7/26.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#define GLWebViewSysVersion   [UIDevice currentDevice].systemVersion.floatValue
#define GLWebViewSysVersion7  (GLWebViewSysVersion < 8.0)

@interface GLWebViewConfiguration : NSObject

@property(nonatomic, copy) NSString *applicationNameForUserAgent NS_AVAILABLE(10_11, 9_0);
@property(nonatomic, strong) WKPreferences *preferences;
@property(nonatomic, strong) WKProcessPool *processPool;
@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic, strong) WKWebsiteDataStore *websiteDataStore NS_CLASS_AVAILABLE(10_11, 9_0);

@property(nonatomic) BOOL suppressesIncrementalRendering;
@property(nonatomic) BOOL allowsInlineMediaPlayback;
@property(nonatomic) BOOL allowsAirPlayForMediaPlayback NS_AVAILABLE(10_11, 9_0);
@property(nonatomic) BOOL mediaPlaybackAllowsAirPlay;
@property(nonatomic) BOOL requiresUserActionForMediaPlayback NS_AVAILABLE(NA, 9_0);
@property(nonatomic) BOOL mediaPlaybackRequiresUserAction;
@property(nonatomic) BOOL allowsPictureInPictureMediaPlayback NS_AVAILABLE(NA, 9_0);
@property(nonatomic) WKSelectionGranularity selectionGranularity;

// 
@property (nonatomic, readonly) WKWebViewConfiguration* webViewConfiguration;

@end
