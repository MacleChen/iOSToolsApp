//
//  CutImageViewController.m
//  iOSToolsApp
//
//  Created by jointsky on 16/9/19.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import "CutImageViewController.h"
#import "CropImageViewController.h"
#import "XHToast.h"

@interface CutImageViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *originImageView;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;


- (IBAction)selectImageClick:(UIButton *)sender;

@end

@implementation CutImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化
    [self resetAction:nil];
    
    // 设置导航栏
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightBarBtnItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}


#pragma mark Save image to ablum
- (void)rightBarBtnItemClick:(UIBarButtonItem *)sender {
    if (self.originImageView.image) {
        [self saveImageToPhotos:self.originImageView.image];
    }
}


- (IBAction)cropAction:(id)sender {
    CropImageViewController *cropImageViewController = [[CropImageViewController alloc] initWithOriginImage:self.originImageView.image callBack:^(UIImage *cropImage, CropImageViewController *viewController) {
        self.originImageView.image = cropImage;
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    cropImageViewController.fixCropSize = YES;
    [self presentViewController:cropImageViewController animated:YES completion:^{
        
    }];
}

- (IBAction)resetAction:(id)sender {
    self.originImageView.image = [UIImage imageNamed:@"bundle_2.jpg"];
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

- (IBAction)selectImageClick:(UIButton *)sender {
    
    NSLog(@"selectImage CLick");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"select Photo" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"select Album", nil];
    [actionSheet showInView:self.view];
}

#pragma mark actionSheet delegate implementation
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    if (buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 提示信息
        [XHToast showBottomWithText:@"not support"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self showViewController:picker sender:nil];//进入照相界面
}


#pragma mark uiImagePickerView Delegate implementation
#pragma mark get sources
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image != nil) {
        self.originImageView.image = image;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  保存图片到系统相册
 *
 *  @param savedImage 图片
 */
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [XHToast showBottomWithText:msg];
}

@end
