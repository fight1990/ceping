//
//  INetworking.m
//  iTestAFNetworking
//
//  Created by administrator on 15/11/23.
//  Copyright © 2015年 administrator. All rights reserved.
//

#import "INetworking.h"
#import "AFNetworking.h"
#import "JSEDefine.h"

typedef void(^wrong)();

static INetworking *network;

static BOOL isNetWorking = YES;


//登录信息.

NSString * const loginUrlStr = @"http://114.55.90.93:8081/web/app/qqblogin.json";

@implementation INetworking

-(void)setIpstr:(NSString *)ipstr{

    
    _ipstr = ipstr;
    
}

-(BOOL)isNetworking{
    return isNetWorking;
}


+(INetworking*)shareNet{

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        network = [[self alloc]init];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                    
                case AFNetworkReachabilityStatusNotReachable:{
                    
                    JSLog(@"无网络");
                    
                    isNetWorking = NO;
                    
                    break;
                    
                }
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    
                    JSLog(@"WiFi网络");
                    
                    isNetWorking = YES;
                    
                    break;
                    
                }
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    
                    isNetWorking = YES;
                    
                    JSLog(@"无线网络");
                    
                    break;
                    
                }
                    
                default:
                    
                    JSLog(@"未知网络");
                    
                    break;
                    
            }
            
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return network;
}

-(void)GET:(NSString*)URLString withParmers:(NSDictionary *)parmers do:(void(^)(id returnObject,BOOL isSuccess))myblok;{

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
//    session.requestSerializer = [AFJSONRequestSerializer];
//    session.responseSerializer = [AFHTTPResponseSerializer];
    
    session.requestSerializer.timeoutInterval = 10;
    
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    session.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    
    [session GET:URLString parameters:parmers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        myblok(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         myblok(error,NO);
    }];
}

-(void)POST:(NSString*)object parameters:(id)parameters do:(void(^)(id returnObject,BOOL isSuccess))myblok{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer.timeoutInterval = 10;

    [manager POST:object parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        myblok(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        myblok(error,NO);
    }];
}


// 下载；   //存放到document中了；
-(void)dowloadWithLoadString:(NSString*)urlstring{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error){
        _errorDolowdToDo();
        }
    }];
    
    [downloadTask resume];
}

// 上传的方法’

-(void)uploadImage{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:[NSData data] name:@"abc" fileName:@"文件名" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            JSLog(@"%@",error);
        } else {
            JSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}


@end
