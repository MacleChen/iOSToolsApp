//
//  ViewController.m
//  iOSToolsApp
//
//  Created by jointsky on 16/9/19.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import "HomeViewController.h"

#define TITLE @"title"
#define SUBTITLE @"subTitle"
#define IDENTIFIER @"identifier"

@interface HomeViewController () {
    NSArray *_dataSource;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 初始化
    _dataSource = @[@{TITLE : @"计算两个经纬度间的距离", SUBTITLE : @"CalculateDistance", IDENTIFIER : @"CalculateView"},
                    @{TITLE : @"设置图片的水印和阴影", SUBTITLE : @"", IDENTIFIER : @""},];
}


#pragma mark tableView Delegate 方法的实现
#pragma mark section count
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark row count in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

#pragma mark cell content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // 解析数据
    NSDictionary *dataDict = _dataSource[indexPath.row];
    
    cell.textLabel.text = [dataDict objectForKey:TITLE];
    cell.detailTextLabel.text = [dataDict objectForKey:SUBTITLE];
    
    return cell;
}

#pragma mark cell click
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 解析数据
    NSDictionary *dataDict = _dataSource[indexPath.row];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:[dataDict objectForKey:IDENTIFIER]];
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
