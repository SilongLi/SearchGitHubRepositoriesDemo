//
//  LSLTableViewCell.h
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/18.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *repositoryNameLabel;

@end
