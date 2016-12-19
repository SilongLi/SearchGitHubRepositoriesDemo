//
//  LSLRepository.h
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/18.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLRepository : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *htmlURL;

@end
