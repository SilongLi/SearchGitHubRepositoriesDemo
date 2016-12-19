//
//  ViewController.m
//  SearchGitHubRepositoriesDemo
//
//  Created by lisilong on 16/12/18.
//  Copyright © 2016年 XMindBruceLi. All rights reserved.
//

#import "ViewController.h" 

#import "LSLRepositories.h"
#import "LSLRepository.h"

#import "LSLTableViewCell.h"
#import "LSLRepositoryDetailViewController.h"
#import "LSLRepositoriesViewModel.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *prePageButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) LSLRepositories *repositories;

@property (nonatomic, assign) NSInteger pageCounts;;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *originKeywords;

@property (nonatomic, strong) LSLRepositoriesViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _searchBar.delegate   = self;
    
    _prePageButton.enabled  = NO;
    _nextPageButton.enabled = NO;
    
    _results = [NSMutableArray array];
    
    _pageLabel.text = @"0/0";
    _currentPage = 1;
    
    _viewModel = [[LSLRepositoriesViewModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma maek - <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self refreshRepositoriesWithKeywords:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self refreshRepositoriesWithKeywords:searchBar.text];
}

- (void)refreshRepositoriesWithKeywords:(NSString *)keywords {
    if (keywords.length > 0 && ![keywords isEqualToString:self.keywords]) {
        _results = [NSMutableArray array];
        self.currentPage = 1;
        
        self.keywords = keywords;
        [self requestRepositoriesWithKeywords:keywords andPage:1];
    }
}

#pragma mark - request

- (void)requestRepositoriesWithKeywords:(NSString *)keywords andPage:(NSInteger)page {
    if (keywords.length <= 0 || page <= 0) return;
    
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestRepositoriesWithKeywords:keywords page:page completion:^(LSLRepositories *repositories) {
        if (!repositories) return;
        
        _repositories = repositories;
        
        if (![weakSelf.originKeywords isEqualToString:weakSelf.keywords] &&
            weakSelf.results.count > 0) {
            weakSelf.results        = [NSMutableArray array];
            weakSelf.originKeywords = weakSelf.keywords;
        }
        [weakSelf.results addObject:_repositories];
        
        NSInteger totalCount = repositories.totalCount / Per_page;
        if (repositories.totalCount % Per_page != 0) {
            totalCount += 1;
        }
        weakSelf.pageCounts = totalCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.searchBar resignFirstResponder];
            [weakSelf.tableView reloadData];
        });
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repositories.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LSLTableViewCell *cell = (LSLTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"reposistoryCell" forIndexPath:indexPath];
    
    LSLRepository *repository     = self.repositories.items[indexPath.row];
    cell.ownerNameLabel.text      = [NSString stringWithFormat:@"ower : %@",repository.ownerName];
    cell.repositoryNameLabel.text = repository.name;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSLRepositoryDetailViewController *RDVC = [[LSLRepositoryDetailViewController alloc] init];
    RDVC.htmlURL = [self.repositories.items[indexPath.row] htmlURL];
    [self.navigationController pushViewController:RDVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - button click

- (IBAction)preButtonClick:(id)sender {
    self.currentPage -= 1;
    if (self.currentPage > 1) {
    }
    self.repositories = self.results[self.currentPage - 1];
    
    [self.tableView reloadData];
}

- (IBAction)nextPageButtonClick:(id)sender {
    self.currentPage += 1;
    
    if (self.currentPage <= self.results.count) {
        self.repositories = self.results[self.currentPage - 1];
    } else {
        [self requestRepositoriesWithKeywords:self.keywords andPage:self.currentPage];
    }
    
    [self.tableView reloadData];
}

#pragma mark - setter and getter

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.pageCounts];
    self.prePageButton.enabled = _currentPage > 1 ? YES : NO;
}

- (void)setPageCounts:(NSInteger)pageCounts {
    if (pageCounts != _pageCounts) {
        if (pageCounts == 0) {
            self.pageLabel.text = @"0/0";
        } else {
            self.pageLabel.text = [NSString stringWithFormat:@"1/%ld", pageCounts];
        }
    }
    
    _pageCounts = pageCounts;

    self.nextPageButton.enabled = self.currentPage < _pageCounts ? YES : NO;
}


@end
