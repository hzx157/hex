//
//  XWChooseAlbum.m
//  XWKitDemo
//
//  Created by xiaowuxiaowu on 16/4/17.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "XWChooseAlbum.h"
#import <objc/runtime.h>
#import "XWKitMacro.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
@interface XWChooseAlbum()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>
@property (nonatomic,copy)ChoosePhotoAlbumBlock block;
@property (nonatomic,copy)ChoosePhotoAlbumWithJKimageBlock jkBlock;  //多选择的时候
@property (nonatomic,copy)ChooseVideoAlbumBlock videoBlock;//视频


@end
static char XWChooseAlbumKey = '\0';
@implementation XWChooseAlbum

+(XWChooseAlbum *)shareSinge{

      XWChooseAlbum *__album =  objc_getAssociatedObject(self, &XWChooseAlbumKey);
    if(!__album){
        __album = [[XWChooseAlbum alloc]init];
        __album.allowsEditing = NO;
        __album.maximumNumberOfSelection = 1;
         objc_setAssociatedObject(self, &XWChooseAlbumKey, __album, OBJC_ASSOCIATION_RETAIN);
    }
    return __album;
    
}
//从相册选择
-(void)localPhoto:(ChoosePhotoAlbumBlock)block{
    if(![self isOpen]){
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = self.allowsEditing;
    [self.ViewController presentViewController:picker animated:YES completion:nil];
    self.block = block;
}

//拍照
-(void)takePhoto:(ChoosePhotoAlbumBlock)block{
    if(![self isOpen]){
        
        return;
    }
    
    self.block = block;
    
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = self.allowsEditing;
        //资源类型为照相机
        picker.sourceType = sourceType;
        
        [self.ViewController presentViewController:picker animated:YES completion:nil];
        
    }else {
        //DLog(@"该设备无摄像头");
    }
}

//录制视频
-(void)takeVideo:(ChooseVideoAlbumBlock)block{
    
    
    if(![self isOpen]){
        return;
    }
    
    self.videoBlock = block;
    
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;//;self.isEditedImage;
        //资源类型为照相机
        picker.sourceType = sourceType;
        
        //picker.mediaTypes =
        //  [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        // 确定摄像，非照像。
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
        
        picker.videoMaximumDuration = 10.0;
        
        
        
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.modalPresentationStyle =UIModalPresentationPopover;
        
        
        [self.ViewController presentViewController:picker animated:YES completion:NULL];
        
    }else {
    }
    
}

#pragma 用户选择好图片后的回调函数



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    
    
       UIImage *tempSaveImage= info[@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //保存图片到相册
     
        UIImageWriteToSavedPhotosAlbum(tempSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
   // UIImage *image= self.isEditedImage ? [info objectForKey:@"UIImagePickerControllerEditedImage"] : info[@"UIImagePickerControllerOriginalImage"];
    
    if (tempSaveImage != nil) {
        
        /*
        if (image.size.width > 1023) {
            NSData *imageData=UIImageJPEGRepresentation(image, 0.8);
            image=[UIImage imageWithData:imageData];
        }
        */
        
        self.block(info);
    }else{
        //视频
        
        if (!info)
            return ;
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        NSString *videoPath;
        NSURL *videoUrl;
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            videoUrl = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            videoPath = [videoUrl path];
            
            UIImage *thumbnailImage = [XWCommon xw_getVideoImage:videoPath];
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            self.videoBlock(thumbnailImage,videoPath);
            // [weakSelf didSendMessageWithVideoConverPhoto:thumbnailImage videoPath:videoPath];
        } else {
            
        }
        
        
    }
    
    
    
    
}

//保存图片到相册的回调函数
-(void) image: (UIImage *)image didFinishSavingWithError: (NSError *)error
  contextInfo: (void *) contextInfo{
    
    NSString *msg=nil;
    if (error==NULL) {
        msg=@"保存图片成功";
    }else {
        msg=@"保存图片失败";
    }
    
    DLog(@"msg=%@",msg);
}

#pragma 编辑图片的取消回调函数
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL )isOpen{
    
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"打开相机失败"
                                                       message:@"请打开 设置-隐私-相机 来进行设置"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"读取相册失败"
                                                       message:@"请打开 设置-隐私-照片 来进行设置"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
    
}


#pragma mark ---------多选择
-(void)LocalPhotoWithChooseArray:(NSMutableArray *)array jkBlock:(ChoosePhotoAlbumWithJKimageBlock )jkBlock{
    
    
    if(![self isOpen]){
        
        return;
    }
    
    
    self.jkBlock = jkBlock;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // create options for fetching photo only
           // PHFetchOptions *fetchOptions = [PHFetchOptions new];
           // fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", self.mediaType];
            
            // assign options
          //  picker.assetsFetchOptions = fetchOptions;
         //   picker.defaultAssetCollection = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
            
            // to present picker as a form sheet in iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self.ViewController presentViewController:picker animated:YES completion:nil];
            
        });
    }];
    
}




#pragma mark - JKImagePickerControllerDelegate
-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.jkBlock(assets);
    
}
-(void)xxoo:(NSArray *)array{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    for (PHAsset *asset in array) {
        
        
        if(asset.mediaType == PHAssetMediaTypeImage){
            // 是否要原图
            CGSize size =  CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
              //  [self addMessage:result];
                NSLog(@"%@", info);
            }];
        }else{
            [[PHImageManager defaultManager]requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                NSLog(@"%@", info);
               // [self addMessage:info[PHImageCancelledKey]];
            }];
        }
    }
}
@end
