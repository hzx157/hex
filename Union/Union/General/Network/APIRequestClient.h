//
//  APIRequestClient.h
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef void(^successBlock)(NSURLSessionDataTask *task, id responseObject,id  respone);
typedef void(^failureBlock)(NSURLSessionDataTask *task, NSError *error,id  respone);
@interface APIRequestClient : NSObject

@property (nonatomic,copy)NSURLSessionDataTask *dataTask;
@property (nonatomic,copy)NSURLSessionDownloadTask *downLoadTask;
@property (nonatomic,copy)AFHTTPSessionManager *httpManager;
+(instancetype)sharedClient;



/*  POST 请求
 *  urlString  url
 *  parameters 字典
 *
 */
-(void)POST:(NSString * )urlString parameters:(id)parameters
      progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
     success:(successBlock)success
     failure:(failureBlock)failure;

/*  下载
 *  urlString  url
 *  filePath 下载路径
 *
 */
- (void)downloadTaskWithUrl:(NSString *)urlString
                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
          completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError *  error))completionHandler;


/*  上传
 *  urlString  url
 *  fileURL 上传路径
 *
 */
-(void)uploadTaskWithUrlString:(NSString *)urlString
                      fromFile:(NSString *)fileURL
                      progress:( void (^)(NSProgress *uploadProgress)) uploadProgressBlock
             completionHandler:( void (^)(NSURLResponse *response, id  responseObject, NSError  *  error,id model))completionHandler;


//-(void)uploadTaskWithStreamedRequest;

@end
