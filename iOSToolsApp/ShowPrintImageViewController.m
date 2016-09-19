//
//  ShowPrintImageViewController.m
//  iOSToolsApp
//
//  Created by jointsky on 16/9/19.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import "ShowPrintImageViewController.h"
#import "XHToast.h"
#import "SJAvatarBrowser.h"
#import "SmallImageShowViewController.h"
#import "imageDetailViewController.h"

@interface ShowPrintImageViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ShowPrintImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    // 初始化
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [self.imageView addGestureRecognizer:tapGesture];
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

- (IBAction)lookImageClick:(UIButton *)sender {
    if (self.imageView.image == nil) {
        return;
    }
    
    SmallImageShowViewController *viewController = [[SmallImageShowViewController alloc] init];
    viewController.showImage = self.imageView.image;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 图片点击响应的方法
- (void)imageViewClick:(UIGestureRecognizer *)gesture {
    NSLog(@"image CLick");
    if (self.imageView.image == nil) {
        return;
    }
    
    // 显示1
    //[SJAvatarBrowser showImage:self.imageView];
    
    // 显示2
    imageDetailViewController *imageVc = [[imageDetailViewController alloc] init];
    
    imageVc.image = self.imageView.image;
    [self.navigationController pushViewController:imageVc animated:YES];
}


#pragma mark actionSheet delegate implementation
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
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
        
        NSString *printMessage = [NSString stringWithFormat:@"2016-09-19 14:23:45 拍摄\nPM2.5：35 ug/m³\n中国 陕西省 西安市 雁塔区 丈八一路 汇鑫IBC A座"];
        self.imageView.image = [self addTextToImage:image text:printMessage];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  添加文字到图片中
 *
 *  @param img   图片
 *  @param text1 文字
 *
 *  @return 有水印的图片
 */
-(UIImage *)addTextToImage:(UIImage *)img text:(NSString *)text1
{
    
    CGSize size = CGSizeMake(img.size.width, img.size.height); //设置上下文（画布）大小
    UIGraphicsBeginImageContext(size); //创建一个基于位图的上下文(context)，并将其设置为当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
    CGContextTranslateCTM(contextRef, 0, img.size.height); //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0); //画布翻转
    CGContextDrawImage(contextRef, CGRectMake(0, 0, img.size.width, img.size.height), [img CGImage]); //在上下文种画当前图片
    [[UIColor whiteColor] set]; //上下文种的文字属性
    CGContextTranslateCTM(contextRef, 0, img.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    UIFont *font = [UIFont boldSystemFontOfSize:18];
    //[text1 drawInRect:CGRectMake(0, 0, 200, 80) withFont:font]; //此处设置文字显示的位置
    //[text1 drawInRect:CGRectMake(120, img.size.height-40, img.size.width-80, 40) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [text1 drawInRect:CGRectMake(20, img.size.height-80, img.size.width-20, 80) withFont:font];
    
    [[UIColor redColor] set]; //上下文种的文字属性
    [text1 drawInRect:CGRectMake(19.5, img.size.height-80, img.size.width-20, 80) withFont:font];
    UIImage *targetimg =UIGraphicsGetImageFromCurrentImageContext(); //从当前上下文种获取图片
    UIGraphicsEndImageContext(); //移除栈顶的基于当前位图的图形上下文。
    return targetimg;
}


@end
