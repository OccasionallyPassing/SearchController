//
//  ViewController.m
//  SearchController
//
//  Created by apple on 17/6/22.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "SearchResultViewController.h"


@interface ViewController ()<UISearchResultsUpdating,UISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) SearchResultViewController *resultController;
@property (nonatomic, strong) NSMutableArray * carNumberArray; //汽车牌号
@property (nonatomic, strong) NSMutableArray * filteredArray;
@property (nonatomic, strong) NSArray * titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //产生100个“数字+三个随机字母”
    for (NSInteger i=0; i<100; i++) {
        [self.carNumberArray addObject:[NSString stringWithFormat:@"%ld%@",(long)i,[self shuffledAlphabet]]];
    }
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    //设置definesPresentationContext为true，可以保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上。
    self.definesPresentationContext = YES;
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UISearchController *)searchController{
    if (!_searchController) {

        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
//        _searchController.active = YES;
        //在searchbar和tableview之间是否添加一层遮罩
        _searchController.dimsBackgroundDuringPresentation = NO;
//        _searchController.obscuresBackgroundDuringPresentation = NO;
        //是否隐藏导航栏
//        _searchController.hidesNavigationBarDuringPresentation = NO;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

- (SearchResultViewController *)resultController{
    if (!_resultController) {
        _resultController = [[SearchResultViewController alloc]init];
    }
    return _resultController;
}

- (NSMutableArray *)carNumberArray{
    if (!_carNumberArray) {
        _carNumberArray = [@[] mutableCopy];
    }
    return _carNumberArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[];
    }
    return _titleArray;
}

- (NSMutableArray *)filteredArray{
    if (!_filteredArray) {
        _filteredArray = [@[] mutableCopy];
    }
    return _filteredArray;
}

#pragma mark - privateMethod
//产生3个随机字母
- (NSString *)shuffledAlphabet {
    NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    
    NSString *strTest = [[NSString alloc]init];
    for (int i=0; i<3; i++) {
        int x = arc4random() % 25;
        strTest = [NSString stringWithFormat:@"%@%@",strTest,shuffledAlphabet[x]];
    }
    return strTest;
    
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    
}
- (void)presentSearchController:(UISearchController *)searchController{
    
}

#pragma mark - UISearchResultsUpdating
//当用户输入完成后点击确定会执行该代理方法，用户删除操作会执行该操作
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    UIButton *cancelButton = [searchController.searchBar valueForKey:@"cancelButton"];
//    if (cancelButton) {
//        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    }
    
    
    NSString * searchString = searchController.searchBar.text;
    NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"SELF CONTAINS %@",searchString];
    self.filteredArray = [[self.carNumberArray filteredArrayUsingPredicate:predicate] mutableCopy];
    if (self.filteredArray != nil) {
        [self.filteredArray removeAllObjects];
    }
    //过滤数据
    self.filteredArray= [NSMutableArray arrayWithArray:[self.carNumberArray filteredArrayUsingPredicate:predicate]];

    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
//引入UISearchController之后, UITableView的内容也要做相应地变动: 即cell中要呈现的内容是allCities, 还是filteredCities.这一点, 可以通过UISearchController的active属性来判断, 即判断输入框是否处于active状态.UITableView相关的很多方法都要根据active来做判断:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchController.active) {
        return [self.filteredArray count];
    }else{
        return [self.carNumberArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (self.searchController.active) {
        [cell.text setText:self.filteredArray[indexPath.row]];
    }else{
        [cell.text setText:self.carNumberArray[indexPath.row]];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%ld",section];
}

@end
