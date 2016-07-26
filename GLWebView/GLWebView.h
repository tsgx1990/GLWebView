//
//  GLWebView.h
//  GLWebViewDemo
//
//  Created by guanglong on 16/7/25.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLWebViewConfiguration.h"

@class GLWebView;

@protocol GLWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(GLWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewDidStartLoad:(GLWebView *)webView;

- (void)webViewDidFinishLoad:(GLWebView *)webView;

- (void)webView:(GLWebView *)webView didFailLoadWithError:(NSError *)error;


@end

@interface GLWebView : UIView

@property (nonatomic, weak) id<GLWebViewDelegate, WKNavigationDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame
                configuration:(GLWebViewConfiguration *)configuration;

- (void)loadData:(NSData *)data
        MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)encodingName
         baseURL:(NSURL *)baseURL; // ios7,ios9 only

- (void)loadHTMLString:(NSString *)string
               baseURL:(NSURL *)baseURL;

- (WKNavigation *)loadRequest:(NSURLRequest *)request;

@property (nonatomic, readonly) UIWebView* uiWebView;

@property(nonatomic, readonly, strong) NSURLRequest *request;
@property(nonatomic, readonly, copy) NSURL *URL;
@property(nonatomic, readonly, getter=isLoading) BOOL loading;
- (void)stopLoading;
- (void)reload;

@property(nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property(nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
- (void)goBack;
- (void)goForward;

@property(nonatomic) BOOL allowsLinkPreview NS_AVAILABLE_IOS(9_0);
@property(nonatomic) BOOL scalesPageToFit; // ios7 only
@property(nonatomic, readonly, strong) UIScrollView *scrollView;
@property(nonatomic) BOOL suppressesIncrementalRendering;
@property(nonatomic) BOOL keyboardDisplayRequiresUserAction; // ios7 only
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes; // ios7 only

//- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id result, NSError *error))completionHandler;

@property(nonatomic) BOOL allowsInlineMediaPlayback;
@property(nonatomic) BOOL mediaPlaybackRequiresUserAction;
@property(nonatomic) BOOL mediaPlaybackAllowsAirPlay;
@property(nonatomic) BOOL allowsPictureInPictureMediaPlayback NS_AVAILABLE_IOS(9_0);

@property(nonatomic) CGFloat gapBetweenPages; // ios7 only
@property(nonatomic, readonly) NSUInteger pageCount; // ios7 only
@property(nonatomic) CGFloat pageLength;  // ios7 only
@property(nonatomic) UIWebPaginationBreakingMode paginationBreakingMode; // ios7 only
@property(nonatomic) UIWebPaginationMode paginationMode; // ios7 only


#pragma mark - - 以下方法只适用于 WKWebView
@property(nonatomic, weak) id< WKUIDelegate > UIDelegate;
@property (nonatomic, readonly) WKWebView* wkWebView;

@property(nonatomic, readonly, copy) WKWebViewConfiguration *configuration;
@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, copy) NSString *customUserAgent NS_AVAILABLE(10_11, 9_0);
@property(nonatomic, readonly, copy) NSArray *certificateChain NS_AVAILABLE(10_11, 9_0);

@property(nonatomic, readonly) double estimatedProgress;
@property(nonatomic, readonly) BOOL hasOnlySecureContent;
- (WKNavigation *)reloadFromOrigin;

- (WKNavigation *)loadData:(NSData *)data
                  MIMEType:(NSString *)MIMEType
     characterEncodingName:(NSString *)characterEncodingName
                   baseURL:(NSURL *)baseURL NS_AVAILABLE(10_11, 9_0);

- (WKNavigation *)loadFileURL:(NSURL *)URL
      allowingReadAccessToURL:(NSURL *)readAccessURL NS_AVAILABLE(10_11, 9_0);

@property(nonatomic) BOOL allowsBackForwardNavigationGestures;
@property(nonatomic, readonly, strong) WKBackForwardList *backForwardList;
- (WKNavigation *)goToBackForwardListItem:(WKBackForwardListItem *)item;

@end

