//
//  LSLRepositoriesViewModel.h
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/19.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSLRepositories;

extern NSInteger const Per_page;

@interface LSLRepositoriesViewModel : NSObject

- (void)requestRepositoriesWithKeywords:(NSString *)keywords page:(NSInteger)page completion:(void(^)(LSLRepositories *repositories))completion;

@end
