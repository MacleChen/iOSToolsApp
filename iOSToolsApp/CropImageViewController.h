//
//  CropImageViewController.h
//  crop
//
//  Created by peter on 16/3/1.
//  Copyright © 2016年 techinone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CropImageViewController;

typedef void(^CropedImageCallBack)(UIImage *cropImage,CropImageViewController *viewController);

@interface CropImageViewController : UIViewController
@property (assign, nonatomic) CGSize cropSize;
@property (assign, nonatomic, getter=isFixCropSize) BOOL fixCropSize;
- (instancetype)initWithOriginImage:(UIImage *)originImage callBack:(CropedImageCallBack)callBack;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com