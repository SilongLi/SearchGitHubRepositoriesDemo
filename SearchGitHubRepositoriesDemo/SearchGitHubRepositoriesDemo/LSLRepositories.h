//
//  LSLRepositories.h
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/18.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLRepositories : NSObject

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSMutableArray *items;

@end
