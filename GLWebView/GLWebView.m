//
//  GLWebView.m
//  GLWebViewDemo
//
//  Created by guanglong on 16/7/25.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "GLWebView.h"
#import <objc/runtime.h>

@interface GLWebView()<UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIWebView* mUIWebView;
@property (nonatomic, strong) WKWebView* mWKWebView;
@property (nonatomic, strong, readonly) GLWebViewConfiguration* webViewConfiguration;

@end

@implementation GLWebView
@synthesize webViewConfiguration = _webViewConfiguration;

- (instancetype)initWithFrame:(CGRect)frame configuration:(GLWebViewConfiguration *)configuration
{
    if (self = [super initWithFrame:frame]) {
        _webViewConfiguration = configuration;
        [self commonInitial];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInitial];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInitial];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitial];
    }
    return self;
}

- (void)commonInitial
{
    id onceToken = objc_getAssociatedObject(self, __func__);
    if (onceToken) {
        return;
    }
    else {
        objc_setAssociatedObject(self, __func__, @"onceToken", OBJC_ASSOCIATION_COPY);
    }
    
    if (GLWebViewSysVersion7) {
        [self createUIWebView];
    }
    else {
        [self createWKWebView];
    }
}

- (void)addConstraintsToWebView
{
    UIView* targetView = self.mUIWebView ? self.mUIWebView : self.mWKWebView;
    targetView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:targetView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:targetView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:targetView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:targetView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSArray* constraints = @[top, left, bottom, right];
    
    if (GLWebViewSysVersion7) {
        [self addConstraints:constraints];
    }
    else {
        [NSLayoutConstraint activateConstraints:constraints];
    }
}

- (GLWebViewConfiguration *)webViewConfiguration
{
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[GLWebViewConfiguration alloc] init];
    }
    return _webViewConfiguration;
}

- (void)createUIWebView
{
    self.mUIWebView = [[UIWebView alloc] init];
    self.mUIWebView.delegate = self;
    self/*.mUIWebView*/.suppressesIncrementalRendering = self.webViewConfiguration.suppressesIncrementalRendering;
    self/*.mUIWebView*/.allowsInlineMediaPlayback = self.webViewConfiguration.allowsInlineMediaPlayback;
    self/*.mUIWebView*/.mediaPlaybackAllowsAirPlay = self.webViewConfiguration.mediaPlaybackAllowsAirPlay;
    self/*.mUIWebView*/.mediaPlaybackRequiresUserAction = self.webViewConfiguration.mediaPlaybackRequiresUserAction;
    self/*.mUIWebView*/.allowsPictureInPictureMediaPlayback = self.webViewConfiguration.allowsPictureInPictureMediaPlayback;
    
    [self addSubview:self.mUIWebView];
    [self addConstraintsToWebView];
}

- (void)createWKWebView
{
    self.mWKWebView = [[WKWebView alloc] initWithFrame:self.frame configuration:self.webViewConfiguration.webViewConfiguration];
    self.mWKWebView.navigationDelegate = self;
    [self addSubview:self.mWKWebView];
    [self addConstraintsToWebView];
}

#pragma mark - - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest* request = navigationAction.request;
    UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
    
    if ([self.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        
        [self.delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
            
            BOOL shouldStart = (policy == WKNavigationActionPolicyAllow);
            if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
                shouldStart = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
            }
            WKNavigationActionPolicy myPolicy = shouldStart ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
            decisionHandler(myPolicy);
        }];
    }
    else {
        
        BOOL shouldStart = YES;
        if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
            shouldStart = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
        }
        WKNavigationActionPolicy navigationActionPolicy = shouldStart ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
        decisionHandler(navigationActionPolicy);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if ([self.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [self.delegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }
    else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.delegate webView:webView didStartProvisionalNavigation:navigation];
    }
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [self.delegate webView:webView didCommitNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.delegate webView:webView didFinishNavigation:navigation];
    }
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [self.delegate webView:webView didFailNavigation:navigation withError:error];
    }
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.delegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [self.delegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if ([self.delegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [self.delegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }
    else {
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
}

#pragma mark - - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    else {
        return YES;
    }
}

#pragma mark - - 1
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL
{
    if (self.mUIWebView) {
        [self.mUIWebView loadData:data MIMEType:MIMEType textEncodingName:encodingName baseURL:baseURL];
    }
    else if (GLWebViewSysVersion >= 9.0) {
        [self.mWKWebView loadData:data MIMEType:MIMEType characterEncodingName:encodingName baseURL:baseURL];
    }
    else {
        // do nothing
    }
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    [self.mUIWebView loadHTMLString:string baseURL:baseURL];
    [self.mWKWebView loadHTMLString:string baseURL:baseURL];
}

- (WKNavigation *)loadRequest:(NSURLRequest *)request
{
    if (self.mUIWebView) {
        [self.mUIWebView loadRequest:request];
        return nil;
    }
    else {
        return [self.mWKWebView loadRequest:request];
    }
}

- (UIWebView *)uiWebView
{
    return self.mUIWebView;
}

- (NSURLRequest *)request
{
    return self.mUIWebView ? self.mUIWebView.request : [NSURLRequest requestWithURL:self.mWKWebView.URL];
}

- (NSURL *)URL
{
    return self.mUIWebView ? self.mUIWebView.request.URL : self.mWKWebView.URL;
}

- (BOOL)isLoading
{
    return self.mUIWebView ? self.mUIWebView.isLoading : self.mWKWebView.isLoading;
}

- (void)stopLoading
{
    [self.mUIWebView stopLoading];
    [self.mWKWebView stopLoading];
}

- (void)reload
{
    [self.mUIWebView reload];
    [self.mWKWebView reload];
}

#pragma mark - - 2
- (BOOL)canGoBack
{
    return self.mUIWebView ? self.mUIWebView.canGoBack : self.mWKWebView.canGoBack;
}

- (BOOL)canGoForward
{
    return self.mUIWebView ? self.mUIWebView.canGoForward : self.mWKWebView.canGoForward;
}

- (void)goBack
{
    [self.mUIWebView goBack];
    [self.mWKWebView goBack];
}

- (void)goForward
{
    [self.mUIWebView goForward];
    [self.mWKWebView goForward];
}

#pragma mark - - 3
- (void)setAllowsLinkPreview:(BOOL)allowsLinkPreview
{
    if (GLWebViewSysVersion < 9.0) {
        return;
    }
    self.mUIWebView.allowsLinkPreview = allowsLinkPreview;
    self.mWKWebView.allowsLinkPreview = allowsLinkPreview;
}

- (BOOL)allowsLinkPreview
{
    if (GLWebViewSysVersion < 9.0) {
        return NO;
    }
    return self.mUIWebView ? self.mUIWebView.allowsLinkPreview : self.mWKWebView.allowsLinkPreview;
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    self.mUIWebView.scalesPageToFit = scalesPageToFit;
}

- (BOOL)scalesPageToFit
{
    return self.mUIWebView ? self.mUIWebView.scalesPageToFit : NO;
}

- (UIScrollView *)scrollView
{
    return self.mUIWebView ? self.mUIWebView.scrollView : self.mWKWebView.scrollView;
}

- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    self.mUIWebView.suppressesIncrementalRendering = suppressesIncrementalRendering;
    self.mWKWebView.configuration.suppressesIncrementalRendering = suppressesIncrementalRendering;
}

- (BOOL)suppressesIncrementalRendering
{
    return self.mUIWebView ? self.mUIWebView.suppressesIncrementalRendering : self.mWKWebView.configuration.suppressesIncrementalRendering;
}

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction
{
    self.mUIWebView.keyboardDisplayRequiresUserAction = keyboardDisplayRequiresUserAction;
}

- (BOOL)keyboardDisplayRequiresUserAction
{
    return self.mUIWebView ? self.mUIWebView.keyboardDisplayRequiresUserAction : NO;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    self.mUIWebView.dataDetectorTypes = dataDetectorTypes;
}

- (UIDataDetectorTypes)dataDetectorTypes
{
    return self.mUIWebView ? self.mUIWebView.dataDetectorTypes : UIDataDetectorTypeNone;
}

#pragma mark - - 4
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    if (self.mUIWebView) {
        NSString* resultStr = [self.mUIWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler) {
            completionHandler(resultStr, nil);
        }
    }
    else {
        [self.mWKWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}

#pragma mark - - 5
- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    self.mUIWebView.allowsInlineMediaPlayback = allowsInlineMediaPlayback;
    self.mWKWebView.configuration.allowsInlineMediaPlayback = allowsInlineMediaPlayback;
}

- (BOOL)allowsInlineMediaPlayback
{
    return self.mUIWebView ? self.mUIWebView.allowsInlineMediaPlayback : self.mWKWebView.configuration.allowsInlineMediaPlayback;
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction
{
    if (self.mUIWebView) {
        self.mUIWebView.mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
    }
    else {
        if (GLWebViewSysVersion < 9.0) {
            self.mWKWebView.configuration.mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
        }
        else {
            self.mWKWebView.configuration.requiresUserActionForMediaPlayback = mediaPlaybackRequiresUserAction;
        }
    }
}

- (BOOL)mediaPlaybackRequiresUserAction
{
    if (self.mUIWebView) {
        return self.mUIWebView.mediaPlaybackRequiresUserAction;
    }
    else {
        if (GLWebViewSysVersion < 9.0) {
            return self.mWKWebView.configuration.mediaPlaybackRequiresUserAction;
        }
        else {
            return self.mWKWebView.configuration.requiresUserActionForMediaPlayback;
        }
    }
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    if (self.mUIWebView) {
        self.mUIWebView.mediaPlaybackAllowsAirPlay = mediaPlaybackAllowsAirPlay;
    }
    else {
        if (GLWebViewSysVersion < 9.0) {
            self.mWKWebView.configuration.mediaPlaybackAllowsAirPlay = mediaPlaybackAllowsAirPlay;
        }
        else {
            self.mWKWebView.configuration.allowsAirPlayForMediaPlayback = mediaPlaybackAllowsAirPlay;
        }
    }
}

- (BOOL)mediaPlaybackAllowsAirPlay
{
    if (self.mUIWebView) {
        return self.mUIWebView.mediaPlaybackAllowsAirPlay;
    }
    else {
        if (GLWebViewSysVersion < 9.0) {
            return self.mWKWebView.configuration.mediaPlaybackAllowsAirPlay;
        }
        else {
            return self.mWKWebView.configuration.allowsAirPlayForMediaPlayback;
        }
    }
}

- (void)setAllowsPictureInPictureMediaPlayback:(BOOL)allowsPictureInPictureMediaPlayback
{
    if (GLWebViewSysVersion < 9.0) {
        return;
    }
    self.mUIWebView.allowsPictureInPictureMediaPlayback = allowsPictureInPictureMediaPlayback;
    self.mWKWebView.configuration.allowsPictureInPictureMediaPlayback = allowsPictureInPictureMediaPlayback;
}

- (BOOL)allowsPictureInPictureMediaPlayback
{
    if (GLWebViewSysVersion < 9.0) {
        return NO;
    }
    return self.mUIWebView ? self.mUIWebView.allowsPictureInPictureMediaPlayback : self.mWKWebView.configuration.allowsPictureInPictureMediaPlayback;
}

#pragma mark - - 66
- (void)setGapBetweenPages:(CGFloat)gapBetweenPages
{
    self.mUIWebView.gapBetweenPages = gapBetweenPages;
}

- (CGFloat)gapBetweenPages
{
    return self.mUIWebView ? self.mUIWebView.gapBetweenPages : 0;
}

- (NSUInteger)pageCount
{
    return self.mUIWebView ? self.mUIWebView.pageCount : 0;
}

- (void)setPageLength:(CGFloat)pageLength
{
    self.mUIWebView.pageLength = pageLength;
}

- (CGFloat)pageLength
{
    return self.mUIWebView ? self.mUIWebView.pageLength : 0.0;
}

- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode
{
    self.mUIWebView.paginationBreakingMode = paginationBreakingMode;
}

- (UIWebPaginationBreakingMode)paginationBreakingMode
{
    return self.mUIWebView ? self.mUIWebView.paginationBreakingMode : UIWebPaginationBreakingModePage;
}

- (void)setPaginationMode:(UIWebPaginationMode)paginationMode
{
    self.mUIWebView.paginationMode = paginationMode;
}

- (UIWebPaginationMode)paginationMode
{
    return self.mUIWebView ? self.mUIWebView.paginationMode : UIWebPaginationModeUnpaginated;
}

#pragma mark - - only for WKWebView
- (void)setUIDelegate:(id<WKUIDelegate>)UIDelegate
{
    self.mWKWebView.UIDelegate = UIDelegate;
}

- (id<WKUIDelegate>)UIDelegate
{
    return self.mWKWebView.UIDelegate;
}

- (WKWebView *)wkWebView
{
    return self.mWKWebView;
}

- (WKWebViewConfiguration *)configuration
{
    return self.mWKWebView.configuration;
}

- (NSString *)title
{
    return self.mWKWebView.title;
}

- (void)setCustomUserAgent:(NSString *)customUserAgent
{
    self.mWKWebView.customUserAgent = customUserAgent;
}

- (NSString *)customUserAgent
{
    return self.mWKWebView.customUserAgent;
}

- (NSArray *)certificateChain
{
    return self.mWKWebView.certificateChain;
}

- (double)estimatedProgress
{
    return self.mWKWebView.estimatedProgress;
}

- (BOOL)hasOnlySecureContent
{
    return self.mWKWebView.hasOnlySecureContent;
}

- (WKNavigation *)reloadFromOrigin
{
    return self.mWKWebView.reloadFromOrigin;
}

- (WKNavigation *)loadData:(NSData *)data
                  MIMEType:(NSString *)MIMEType
     characterEncodingName:(NSString *)characterEncodingName
                   baseURL:(NSURL *)baseURL
{
    if (GLWebViewSysVersion < 9.0) {
        return nil;
    }
    return [self.mWKWebView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
}

- (WKNavigation *)loadFileURL:(NSURL *)URL
      allowingReadAccessToURL:(NSURL *)readAccessURL
{
    if (GLWebViewSysVersion < 9.0) {
        return nil;
    }
    return [self.mWKWebView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
}

- (BOOL)allowsBackForwardNavigationGestures
{
    if (self.mUIWebView) {
        return NO;
    }
    return self.mWKWebView.allowsBackForwardNavigationGestures;
}

- (WKBackForwardList *)backForwardList
{
    return self.mWKWebView.backForwardList;
}

- (WKNavigation *)goToBackForwardListItem:(WKBackForwardListItem *)item
{
    return [self.mWKWebView goToBackForwardListItem:item];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    self.mWKWebView.UIDelegate = nil;
    self.mWKWebView.navigationDelegate = nil;
    self.mUIWebView.delegate = nil;
    self.delegate = nil;
    self.scrollView.delegate = nil; // important！！！
}

@end
