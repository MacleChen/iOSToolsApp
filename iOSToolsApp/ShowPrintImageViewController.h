//
//  ShowPrintImageViewController.h
//  iOSToolsApp
//
//  Created by jointsky on 16/9/19.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPrintImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)selectImageClick:(UIButton *)sender;

- (IBAction)lookImageClick:(UIButton *)sender;


@end
