//
//  MyInfoViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyInfoViewController.h"
#import "CustomIOS7AlertView.h"
#import "HZAreaPickerView.h"
#import "HttpService.h"
#import "Util.h"
#import "ShowImageView.h"


@interface MyInfoViewController ()<HZAreaPickerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    IBOutlet UILabel *lbPhone;
    IBOutlet UITextField *tfName;
    IBOutlet UILabel *lbSex;
    IBOutlet UILabel *lbAddress1;
    IBOutlet UITextField *lbAddress2;
    IBOutlet UIImageView *ivPortrait;
    
    HZAreaPickerView *locatePicker;
    NSArray *arrBtnSex;
    NSString *strPortrait;
    NSString *strPortraitName;
    
    int sexTag;
}

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)choose:(UIButton*)sender {
    sexTag=(int)sender.tag;
    for (int i=0; i<2; i++) {
        [((UIButton*)[arrBtnSex objectAtIndex:i]) setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    [((UIButton*)[arrBtnSex objectAtIndex:sexTag]) setImage:[UIImage imageNamed:@"选定"] forState:UIControlStateNormal];
}

- (void)pop {
    //地址待定
    if([((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Name isEqualToString:tfName.text]&&[((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Sex isEqualToString:[NSString stringWithFormat:@"%d",sexTag]]&&[((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Address isEqualToString:[NSString stringWithFormat:@"%@-%@",lbAddress1.text,lbAddress2.text]]){
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"是否保存修改？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }
    
}

#pragma mark - Private Methods

- (void)initUI
{
    self.navigationController.navigationBarHidden=NO;
    self.title=@"我的资料";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    lbPhone.text=((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Phone;
    if (![((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Name isEqualToString:@""]) {
        tfName.text=((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Name;
    }
    sexTag=[((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Sex intValue];
    if (sexTag==0) {
        lbSex.text=@"女";
    }else if (sexTag==1) {
        lbSex.text=@"男";
    }
    if (![((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Address isEqualToString:@""]) {
        NSArray *arrAddress = [((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Address componentsSeparatedByString:@"-"];
        if(arrAddress.count==1){
            lbAddress1.text=[arrAddress objectAtIndex:0];
        }else if(arrAddress.count==2){
            lbAddress1.text=[arrAddress objectAtIndex:0];
            lbAddress2.text=[arrAddress objectAtIndex:1];
        }
    }
    [ivPortrait setImageWithURL:[NSURL URLWithString:((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Img]placeholderImage:[UIImage imageNamed:@"我的资料-个人头像"]];
    ivPortrait.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    ivPortrait.layer.borderWidth=0.1f;
    ivPortrait.layer.cornerRadius=30.0f;
    ivPortrait.layer.masksToBounds = YES;
    [ShowImageView showImage:ivPortrait];
}

#pragma mark - IBOutlet Methods

- (IBAction)commit:(id)sender {
    [SVProgressHUD showWithStatus:@"提交修改中..." maskType:SVProgressHUDMaskTypeBlack];
    [[HttpService sharedInstance]post:@{@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Edit_Personal_Info,@"userName":lbPhone.text,@"name":tfName.text,@"sex":[NSString stringWithFormat:@"%d",sexTag],@"address":[NSString stringWithFormat:@"%@-%@",lbAddress1.text,lbAddress2.text]} completionBlock:^(id object) {
        if(strPortrait){
            [[HttpService sharedInstance]post:@{@"userName":lbPhone.text,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Portrait,@"img":[NSString stringWithFormat:@"%@.png",((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId],@"bytes":strPortrait} completionBlock:^(id object) {
                [[HttpService sharedInstance]post:@{@"userName":lbPhone.text,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Personal_Info} completionBlock:^(id object) {
                    [Util setDataToRom:object];
                    [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                    [self.navigationController popViewControllerAnimated:NO];
                } failureBlock:^(NSError *error, NSString *responseString) {
                    if(!responseString){
                        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                    }else{
                        [SVProgressHUD showErrorWithStatus:responseString];
                    }
                }];
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
            
        }else{
            [[HttpService sharedInstance]post:@{@"userName":lbPhone.text,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Personal_Info} completionBlock:^(id object) {
                [Util setDataToRom:object];
                [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                [self.navigationController popViewControllerAnimated:NO];
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

#pragma mark - Gesture Methods

- (IBAction)choosePhoto:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照上传",@"本地相册",nil];
    [actionSheet showInView:self.view];

}

- (IBAction)chooseSex:(id)sender {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    UIView *v=[((NSArray*)([[NSBundle mainBundle] loadNibNamed:@"Sex" owner:nil options:nil])) objectAtIndex:0];
    
    arrBtnSex=[v subviews];
    for (UIButton *btn in ((NSArray*)[v subviews])) {
        [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        
        if (sexTag==btn.tag){
            [btn setImage:[UIImage imageNamed:@"选定"] forState:UIControlStateNormal];
        }
    }
    
    // Modify the parameters
    [alertView setContainerView:v];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        switch (sexTag) {
            case 0:
                [lbSex setText:@"女"];
                break;
            case 1:
                [lbSex setText:@"男"];
                break;
                
            default:
                break;
        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];

}

- (IBAction)chooseAdderss:(id)sender {
    locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    [locatePicker showInView:[[[UIApplication sharedApplication] windows] firstObject]];
}

#pragma mark - AlertView Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:NO];
    }else if(buttonIndex==1){
        [SVProgressHUD showWithStatus:@"提交修改中..." maskType:SVProgressHUDMaskTypeBlack];
        [[HttpService sharedInstance]post:@{@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Edit_Personal_Info,@"userName":lbPhone.text,@"name":tfName.text,@"sex":[NSString stringWithFormat:@"%d",sexTag],@"address":[NSString stringWithFormat:@"%@-%@",lbAddress1.text,lbAddress2.text]} completionBlock:^(id object) {
            if(strPortrait){
                [[HttpService sharedInstance]post:@{@"userName":lbPhone.text,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Portrait,@"img":[NSString stringWithFormat:@"%@.png",((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId],@"bytes":strPortrait} completionBlock:^(id object) {
                    [[HttpService sharedInstance]post:@{@"userName":lbPhone.text,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Personal_Info} completionBlock:^(id object) {
                        [Util setDataToRom:object];
                        [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                        [self.navigationController popViewControllerAnimated:NO];
                    } failureBlock:^(NSError *error, NSString *responseString) {
                        if(!responseString){
                            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                        }else{
                            [SVProgressHUD showErrorWithStatus:responseString];
                        }
                    }];
                } failureBlock:^(NSError *error, NSString *responseString) {
                    if(!responseString){
                        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                    }else{
                        [SVProgressHUD showErrorWithStatus:responseString];
                    }
                }];

            }else{
                [[HttpService sharedInstance]post:@{@"userName":lbPhone.text,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Personal_Info} completionBlock:^(id object) {
                    [Util setDataToRom:object];
                    [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                    [self.navigationController popViewControllerAnimated:NO];
                } failureBlock:^(NSError *error, NSString *responseString) {
                    if(!responseString){
                        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                    }else{
                        [SVProgressHUD showErrorWithStatus:responseString];
                    }
                }];
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    ivPortrait.image=image;
    image=[self scaleFromImage:image toSize:CGSizeMake(150.0f, 150.0f)];
    NSData* imageData;
    if (UIImagePNGRepresentation(image)) {
        imageData = UIImagePNGRepresentation(image);
    }else {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    strPortrait = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [self dismissViewControllerAnimated:YES completion:Nil];
}


#pragma mark - HZAreaPicker delegate

-(void)pickerDidCommitStatus:(NSString *)locate
{
    if([locate hasPrefix:@"广东省 广州市"]){
        lbAddress1.text=locate;
        [locatePicker cancelPicker];
    }else{
        [SVProgressHUD showErrorWithStatus:@"该地区暂未开放服务喔~"];
    }
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照上传
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
            break;
        case 1://本地相册
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
            break;
        default:
            break;
    }
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
