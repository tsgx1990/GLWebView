//
//  ViewController.m
//  GLWebViewDemo
//
//  Created by guanglong on 16/7/25.
//  Copyright © 2016年 bjhl. All rights reserved.
//

#import "ViewController.h"
#import "GLWebView.h"

@interface ViewController ()<WKNavigationDelegate, GLWebViewDelegate>

@property (weak, nonatomic) IBOutlet GLWebView *glWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.glWebView.backgroundColor = [UIColor orangeColor];
    self.glWebView.delegate  = self;
    self.glWebView.scalesPageToFit = NO;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.glWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationAction:%@", navigationAction.request);
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - - GLWebViewDelegate
- (BOOL)webView:(GLWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest:%@", request);
    return YES;
}

- (void)webViewDidStartLoad:(GLWebView *)webView
{
    NSLog(@"webViewDidStartLoad:");
}

- (void)webViewDidFinishLoad:(GLWebView *)webView
{
    NSLog(@"webViewDidFinishLoad:");
}

- (void)webView:(GLWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}

@end
