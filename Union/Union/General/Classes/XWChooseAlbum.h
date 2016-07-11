//
//  XWChooseAlbum.h
//  XWKitDemo
//
//  Created by xiaowuxiaowu on 16/4/17.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//


#import <Photos/Photos.h>
#import <Foundation/Foundation.h>

typedef void(^ChoosePhotoAlbumBlock)(NSDictionary *info);
typedef void(^ChooseVideoAlbumBlock)(UIImage *image,NSString *path);
typedef void(^ChoosePhotoAlbumWithJKimageBlock)(NSArray *imgArray);


@interface XWChooseAlbum : NSObject

@property (nonatomic,assign)NSInteger maximumNumberOfSelection;//多选时的最大总数
@property (nonatomic,assign)PHAssetMediaType mediaType;
@property (nonatomic,strong)UIViewController *ViewController;   //来自哪个
@property (nonatomic,assign)BOOL allowsEditing;  //是否要剪切图片 默认是NO
+(XWChooseAlbum *)shareSinge;

//从相册选择 系统选择
-(void)localPhoto:(ChoosePhotoAlbumBlock )block;

//拍照
-(void)takePhoto:(ChoosePhotoAlbumBlock )block;

//多选择
-(void)LocalPhotoWithChooseArray:(NSMutableArray *)array jkBlock:(ChoosePhotoAlbumWithJKimageBlock )jkBlock;

//视频
-(void)takeVideo:(ChooseVideoAlbumBlock )block;
@end
