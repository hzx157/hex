//
//  APIRequestClient.m
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//




#import "APIRequestClient.h"
#import <MJExtension/MJExtension.h>
@implementation APIRequestClient
#define  BUSINESS_URL  @"http://112.124.101.198:8080/App/"
+(NSString *)baseUrl{
  return BUSINESS_URL;
}
+(instancetype)sharedClient{

    static APIRequestClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[APIRequestClient alloc]init];
    });
    
    return client;
}
+(AFHTTPSessionManager *)shareManager{
   static AFHTTPSessionManager *manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20.0;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    return manager;
}

-(void)POST:(NSString * )urlString parameters:( id)parameters
          progress:( void (^)( NSProgress * uploadProgress)) uploadProgress
           success:(successBlock)success
           failure:(failureBlock)failure{

    AFHTTPSessionManager *manager = [APIRequestClient shareManager];
   self.dataTask = [manager POST:urlString parameters:nil progress:uploadProgress success:^(NSURLSessionDataTask *  task, id  responseObject) {
            
          success(task,[responseObject mj_JSONObject],responseObject);
       
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
         failure(task,error,error);
    }];
    
}
- (void)downloadTaskWithUrl:(NSString *)urlString
                       progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                    destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
              completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError *  error))completionHandler{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:[[APIRequestClient baseUrl] stringByAppendingString:urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    self.downLoadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        destination(targetPath,response);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completionHandler];
    [_downLoadTask resume];
    

}
/*
-(void)uploadTaskWithUrlString:(NSString *)urlString
                    fromFile:(NSString *)fileURL
                    progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
           completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error,id model))completionHandler{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[[APIRequestClient baseUrl] stringByAppendingString:urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:fileURL];
    self.dataTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
        completionHandler(response,responseObject,error,responseObject);
        
    }];
    [_dataTask resume];

}
 */
-(void)uploadTaskWithUrlString:(NSString *)urlString
                      fromFile:(NSString *)fileURL
                      progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
             completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error,id model))completionHandler{
     NSURL *URL = [NSURL URLWithString:[[APIRequestClient baseUrl] stringByAppendingString:urlString]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       //   [formData appendPartWithFileData:data1 name:@"file" fileName:@"ios_huangzhenxiang.png" mimeType:@"image/png"];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:fileURL] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
     AFHTTPSessionManager *manager = [APIRequestClient shareManager];
  //  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
 NSLog(@"Error: %@", uploadProgress);
                      //    [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"sueccs = %@", [responseObject mj_JSONObject]);
                      }
                  }];
    
    [uploadTask resume];
}

@end
