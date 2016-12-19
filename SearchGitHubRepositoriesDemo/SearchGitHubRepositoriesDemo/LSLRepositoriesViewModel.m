//
//  LSLRepositoriesViewModel.m
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/19.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import "LSLRepositoriesViewModel.h"

#import "AFHTTPSessionManager.h"
#import "MJExtension.h"

#import "LSLRepositories.h"
#import "LSLRepository.h"

NSInteger const Per_page = 20;

@implementation LSLRepositoriesViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self setupExtensionConfig];
    }
    return self;
}

#pragma mark - 

- (void)requestRepositoriesWithKeywords:(NSString *)keywords page:(NSInteger)page completion:(void(^)(LSLRepositories *repositories))completion {
    if (keywords.length <= 0 || page <= 0) {
        if (completion) completion(nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"q"        : keywords,
                                 @"page"     : @(page),
                                 @"per_page" : @(Per_page),
                                 @"sort"     : @"stars",
                                 @"order"    : @"desc",};
    [manager GET:@"https://api.github.com/search/repositories" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            if (completion) completion(nil);
            return;
        }
        
        LSLRepositories *repositories = [LSLRepositories mj_objectWithKeyValues:responseObject];
        if (completion) completion(repositories);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request error! Error : %@", error);
        if (completion) completion(nil);
    }];
}

#pragma mark - config

- (void)setupExtensionConfig {
    [LSLRepositories mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"items" : @"LSLRepository"
                 };
    }];
    
    [LSLRepositories mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"totalCount" : @"total_count"
                 };
    }];
    
    [LSLRepository mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"htmlURL" : @"html_url",
                 @"ownerName" : @"owner.login"
                 };
    }];
}


@end
