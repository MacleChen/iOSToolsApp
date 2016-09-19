//
//  ViewController.m
//  CalculateDistance
//
//  Created by jointsky on 16/9/18.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import "CalculateDistanceViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CalculateDistanceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *latTextField;
@property (weak, nonatomic) IBOutlet UITextField *longTextField;
@property (weak, nonatomic) IBOutlet UITextField *lat2TextField;
@property (weak, nonatomic) IBOutlet UITextField *long2TextField;


@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *result2Label;

- (IBAction)calculateBtnClick:(UIButton *)sender;

@end

@implementation CalculateDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([self.latTextField.text isEqual:@""] || [self.longTextField.text isEqual:@""] || [self.lat2TextField.text isEqual:@""] || [self.long2TextField.text isEqual:@""]) {
        return;
    }
    
    CLLocationCoordinate2D coorTemp;
    coorTemp.latitude = [self.latTextField.text doubleValue];
    coorTemp.longitude = [self.longTextField.text doubleValue];
    
    CLLocation *sendLocation = [[CLLocation alloc] initWithLatitude:coorTemp.latitude longitude:coorTemp.longitude];
    CLLocation *receiveLocation = [[CLLocation alloc] initWithLatitude:[self.lat2TextField.text doubleValue] longitude:[self.long2TextField.text doubleValue]];
    CLLocationDistance  distanceTemp = [sendLocation distanceFromLocation:receiveLocation];
    
    
    self.resultLabel.text = [NSString stringWithFormat:@"物理距离：%fm", distanceTemp];
    
    // 计算方法2
    [self calculate2Distance];
    
}


- (void)calculate2Distance {
    /** 地球半径 */
    double EARTH_RADIUS = 6378137;
    
    
    double radLat1 = [self rad:[self.latTextField.text doubleValue]];
    double radLat2 = [self rad:[self.lat2TextField.text doubleValue]];
    double a = radLat1 - radLat2;
    double b = [self rad:[self.longTextField.text doubleValue]] - [self rad:[self.long2TextField.text doubleValue]];
    
    double s = 2* asin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    
    self.result2Label.text = [NSString stringWithFormat:@"物理距离：%fm", s];
}


/** 度数转弧度 */
-(double)rad:(double)d {
    return d * M_PI / 180.0;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
