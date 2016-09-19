//
//  imageDetailViewController.m
//  iOSToolsApp
//
//  Created by jointsky on 16/9/19.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import "imageDetailViewController.h"
#import "VIPhotoView.h"

@interface imageDetailViewController ()

@end

@implementation imageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:self.image];
    photoView.autoresizingMask = (1 << 6) -1;
    
    [self.view addSubview:photoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
