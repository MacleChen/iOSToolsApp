//
//  CropImageViewController.m
//  crop
//
//  Created by peter on 16/3/1.
//  Copyright © 2016年 techinone. All rights reserved.
//

#import "CropImageViewController.h"

typedef NS_ENUM(NSUInteger, ActionViewTag) {
    OriginViewTag = 111,
    CropViewTag
};

static CGPoint PreviousTapPoint = (CGPoint){0,0};
static CGAffineTransform PreviousAffineTransform = (CGAffineTransform){1,0,0,1,0,0};
static const CGFloat kGenerateButtonHeight = 40;
static const UIEdgeInsets kCropButtonEdgeInsets = {20,20,30,20};
static const UIEdgeInsets kOriginImageBackgroundViewEdgeInsets = {30,20,20,20};
static const CGSize kCropViewDefaultSize = (CGSize){100,100};
@interface CropImageViewController () <UIGestureRecognizerDelegate>
@property (copy, nonatomic) CropedImageCallBack callBack;
@property (strong, nonatomic) UIImage *originImage;
@property (strong, nonatomic, readonly) UIImage *generateCropImage;
@property (strong, nonatomic) UIView *originImageBoardView;
@property (strong, nonatomic) UIImageView *originImageView;
@property (strong, nonatomic) UIView *cropView;
@property (strong, nonatomic) UIButton *cropButton;
@end

@implementation CropImageViewController

- (instancetype)initWithOriginImage:(UIImage *)originImage callBack:(CropedImageCallBack)callBack {
    assert(originImage && callBack);
    if(self = [super init]) {
        self.callBack = callBack;
        self.originImage = originImage;
    }
    else {
        return nil;
    }
    return self;
}

- (instancetype)init {
    NSAssert(0, @"use initWithOriginImage:callBack: instead");
    return nil;
}

#pragma mark bind gesture recognizer

- (void)bindGestureAction {
    UIPinchGestureRecognizer *pinchOriginGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    UIPanGestureRecognizer *panOriginGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panOriginGestureRecognizer.maximumNumberOfTouches = 1;
    UIRotationGestureRecognizer *rotationOriginGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureAction:)];
    pinchOriginGestureRecognizer.delegate = panOriginGestureRecognizer.delegate = rotationOriginGestureRecognizer.delegate = self;
    [self.originImageBoardView addGestureRecognizer:pinchOriginGestureRecognizer];
    [self.originImageBoardView addGestureRecognizer:panOriginGestureRecognizer];
    [self.originImageBoardView addGestureRecognizer:rotationOriginGestureRecognizer];
    UIPinchGestureRecognizer *pinchCropGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    UIPanGestureRecognizer *panCropGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panOriginGestureRecognizer.maximumNumberOfTouches = 1;
    [self.cropView addGestureRecognizer:panCropGestureRecognizer];
    if(self.isFixCropSize) {
        return;
    }
    [self.cropView addGestureRecognizer:pinchCropGestureRecognizer];
    
}

#pragma mark relayout subviews

- (void)generateSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
//    generate origin imageview background view;
    
    self.originImageBoardView = [[UIView alloc] initWithFrame:CGRectMake(kOriginImageBackgroundViewEdgeInsets.left, kOriginImageBackgroundViewEdgeInsets.top, CGRectGetWidth(windowFrame) - (kCropButtonEdgeInsets.left + kCropButtonEdgeInsets.right), CGRectGetHeight(windowFrame) - (kOriginImageBackgroundViewEdgeInsets.top + kOriginImageBackgroundViewEdgeInsets.bottom) - (kGenerateButtonHeight + kCropButtonEdgeInsets.top + kCropButtonEdgeInsets.bottom))];
    self.originImageBoardView.tag = OriginViewTag;
    self.originImageBoardView.clipsToBounds = YES;
    [self.view addSubview:self.originImageBoardView];
    
//    generate origin imageview
    
    self.originImageView = [[UIImageView alloc] initWithFrame:self.originImageBoardView.bounds];
    self.originImageView.image = self.originImage;
    self.originImageView.contentMode = UIViewContentModeCenter;
    [self.originImageBoardView addSubview:self.originImageView];
    
//    generate crop view
    self.cropView = [[UIView alloc] init];
    self.cropView.center = CGPointMake(CGRectGetWidth(self.originImageBoardView.frame) / 2 + kOriginImageBackgroundViewEdgeInsets.left, CGRectGetHeight(self.originImageBoardView.frame) / 2 + kOriginImageBackgroundViewEdgeInsets.top);
    if(CGSizeEqualToSize(self.cropSize, CGSizeZero)) {
        self.cropView.bounds = CGRectMake(0, 0, kCropViewDefaultSize.width, kCropViewDefaultSize.height);
    }
    else {
        self.cropView.bounds = CGRectMake(0, 0, self.cropSize.width, self.cropSize.height);
    }
    self.cropView.tag = CropViewTag;
    self.cropView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
    [self.view addSubview:self.cropView];
    
//    generate crop button;
    self.cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cropButton.frame = CGRectMake(kCropButtonEdgeInsets.left,CGRectGetMaxY(self.originImageBoardView.frame) + kCropButtonEdgeInsets.top,CGRectGetWidth(windowFrame) - (kCropButtonEdgeInsets.left + kCropButtonEdgeInsets.right),kGenerateButtonHeight);
    [self.cropButton setTitle:@"截取" forState:UIControlStateNormal];
    [self.cropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cropButton.backgroundColor = [UIColor orangeColor];
    [self.cropButton addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cropButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateSubViews];
    [self bindGestureAction];
}

#pragma mark gesture recognizer action

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    UIView *gestureView = gestureRecognizer.view;
    if(gestureView.tag == OriginViewTag) {
        gestureView = self.originImageView;
    }
    CGAffineTransform affineTransform = CGAffineTransformScale(gestureView.transform,gestureRecognizer.scale, gestureRecognizer.scale);
    
    gestureView.transform = affineTransform;
    gestureRecognizer.scale = 1;
    if(gestureRecognizer.view.tag == OriginViewTag) {
        return;
    }
    if(!CGRectContainsRect(self.originImageBoardView.frame, gestureView.frame)) {
        gestureView.transform = PreviousAffineTransform;
        return;
    }
    PreviousAffineTransform = gestureView.transform;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *gestureView = gestureRecognizer.view,
    *gestureViewSuperView = gestureView.superview;
    BOOL needPaddingDistance = NO;
    if(gestureView.tag == OriginViewTag) {
        gestureView = self.originImageView;
        needPaddingDistance = NO;
    }
    else if (gestureView.tag == CropViewTag) {
        needPaddingDistance = YES;
        gestureViewSuperView = self.originImageBoardView;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureView.superview];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint centerPoint = CGPointMake(gestureView.center.x + touchPoint.x - PreviousTapPoint.x, gestureView.center.y + touchPoint.y - PreviousTapPoint.y);
        if(needPaddingDistance) {
            CGFloat w = CGRectGetWidth(gestureView.frame),
            h = CGRectGetHeight(gestureView.frame);
            CGRect tempFrame = CGRectMake(centerPoint.x - w / 2, centerPoint.y - h / 2, w, h);
            if(!CGRectContainsRect(gestureViewSuperView.frame, tempFrame)) {
                return;
            }
        }
        gestureView.center = centerPoint;
    }
    PreviousTapPoint = touchPoint;
    [gestureRecognizer setTranslation:CGPointZero inView:gestureView.superview];
}

- (void)rotationGestureAction:(UIRotationGestureRecognizer *)gestureRecognizer {
    UIView *gestureView = gestureRecognizer.view;
    if(gestureView.tag == OriginViewTag) {
        gestureView = self.originImageView;
    }
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        PreviousTapPoint = gestureView.center;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        gestureView.transform = CGAffineTransformRotate(gestureView.transform, gestureRecognizer.rotation);
        gestureView.center = PreviousTapPoint;
        [gestureRecognizer setRotation:0];
    }
}

- (UIImage *)generateCropImage {
    UIGraphicsBeginImageContext(self.originImageBoardView.bounds.size); //currentView 当前的view
    [self.originImageBoardView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *originFullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGImageRef imageRef = originFullImage.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, self.cropView.frame);
    UIImage *cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}

- (void)cropAction {
    if(self.callBack) {
        self.callBack(self.generateCropImage,self);
    }
}

#pragma mark UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com