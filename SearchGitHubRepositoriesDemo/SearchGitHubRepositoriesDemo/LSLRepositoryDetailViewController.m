//
//  LSLRepositoryDetailViewController.m
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/18.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import "LSLRepositoryDetailViewController.h"

@interface LSLRepositoryDetailViewController ()<UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LSLRepositoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.opaque   = NO;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_htmlURL]];
    [_webView loadRequest:request];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _webView.frame = self.view.bounds;
}

@end
