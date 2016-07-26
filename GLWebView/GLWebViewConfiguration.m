//
//  GLWebViewConfiguration.m
//  GLWebViewDemo
//
//  Created by guanglong on 16/7/26.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "GLWebViewConfiguration.h"

@implementation GLWebViewConfiguration
@synthesize webViewConfiguration = _webViewConfiguration;

- (instancetype)init
{
    if (self = [super init]) {
        if (!GLWebViewSysVersion7) {
            _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        }
    }
    return self;
}

- (void)setApplicationNameForUserAgent:(NSString *)applicationNameForUserAgent
{
    _applicationNameForUserAgent = applicationNameForUserAgent;
    if (GLWebViewSysVersion >= 9.0) {
        self.webViewConfiguration.applicationNameForUserAgent = _applicationNameForUserAgent;
    }
}

- (void)setPreferences:(WKPreferences *)preferences
{
    _preferences = preferences;
    self.webViewConfiguration.preferences = _preferences;
}

- (void)setProcessPool:(WKProcessPool *)processPool
{
    _processPool = processPool;
    self.webViewConfiguration.processPool = _processPool;
}

- (void)setUserContentController:(WKUserContentController *)userContentController
{
    _userContentController = userContentController;
    self.webViewConfiguration.userContentController = _userContentController;
}

- (void)setWebsiteDataStore:(WKWebsiteDataStore *)websiteDataStore
{
    _websiteDataStore = websiteDataStore;
    if (GLWebViewSysVersion >= 9.0) {
        self.webViewConfiguration.websiteDataStore = _websiteDataStore;
    }
}

#pragma mark - - 1111
- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    _suppressesIncrementalRendering = suppressesIncrementalRendering;
    self.webViewConfiguration.suppressesIncrementalRendering = _suppressesIncrementalRendering;
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    _allowsInlineMediaPlayback = allowsInlineMediaPlayback;
    self.webViewConfiguration.allowsInlineMediaPlayback = _allowsInlineMediaPlayback;
}

- (void)setAllowsAirPlayForMediaPlayback:(BOOL)allowsAirPlayForMediaPlayback
{
    _allowsAirPlayForMediaPlayback = allowsAirPlayForMediaPlayback;
    if (GLWebViewSysVersion >= 9.0) {
        self.webViewConfiguration.allowsAirPlayForMediaPlayback = _allowsAirPlayForMediaPlayback;
    }
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    _mediaPlaybackAllowsAirPlay = mediaPlaybackAllowsAirPlay;
    self.webViewConfiguration.mediaPlaybackAllowsAirPlay = _mediaPlaybackAllowsAirPlay;
}

- (void)setRequiresUserActionForMediaPlayback:(BOOL)requiresUserActionForMediaPlayback
{
    _requiresUserActionForMediaPlayback = requiresUserActionForMediaPlayback;
    if (GLWebViewSysVersion >= 9.0) {
        self.webViewConfiguration.requiresUserActionForMediaPlayback = _requiresUserActionForMediaPlayback;
    }
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction
{
    _mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
    self.webViewConfiguration.mediaPlaybackRequiresUserAction = _mediaPlaybackRequiresUserAction;
}

- (void)setAllowsPictureInPictureMediaPlayback:(BOOL)allowsPictureInPictureMediaPlayback
{
    _allowsPictureInPictureMediaPlayback = allowsPictureInPictureMediaPlayback;
    if (GLWebViewSysVersion >= 9.0) {
        self.webViewConfiguration.allowsPictureInPictureMediaPlayback = _allowsPictureInPictureMediaPlayback;
    }
}

- (void)setSelectionGranularity:(WKSelectionGranularity)selectionGranularity
{
    _selectionGranularity = selectionGranularity;
    self.webViewConfiguration.selectionGranularity = _selectionGranularity;
}

@end
