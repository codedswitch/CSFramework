//
//  CSRequestManager.m
//  Pods
//
//  Created by Cris Uy on 15/03/2017.
//
//

#import "CSRequestManager.h"

#define USERDEFAULT_TOKEN_STRING @"token"
#define AF_HTTPHEADERFIELD_AUTHENTICATION @"Authorization"
#define AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE @"Bearer %@"

#define LOG_API     @"API: %@"
#define PARAM_API   @"PARAM: %@"

static CSRequestManager* _sharedManager = nil;

@interface CSRequestManager ()

- (void)startAFNetworkingReachability;
- (BOOL)isAFNetworkingConnected;

@end

@implementation CSRequestManager

+ (CSRequestManager *)sharedManager {
    
    @synchronized(self) {
        if (_sharedManager == nil) {
            _sharedManager = [[self alloc] init];
        }
    }
    
    return _sharedManager;
}

- (void)startAFNetworkingReachability {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        //        typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
        //            AFNetworkReachabilityStatusUnknown          = -1,
        //            AFNetworkReachabilityStatusNotReachable     = 0,
        //            AFNetworkReachabilityStatusReachableViaWWAN = 1,
        //            AFNetworkReachabilityStatusReachableViaWiFi = 2,
        //        };
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication Error" message:@"Sorry! Please check your internet connection and try again." preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
//                [[CRootViewController sharedController] presentViewController:alertController animated:YES completion:nil];
            });
        }
        
    }];
    
    if ([self isAFNetworkingConnected]) {
        
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication Error" message:@"Sorry! Please check your internet connection and try again." preferredStyle:UIAlertControllerStyleAlert];
        //
        //        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //
        //        }]];
        //
        //        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //            if (UIApplicationOpenSettingsURLString != NULL) {
        //                NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        //                [[UIApplication sharedApplication] openURL:URL];
        //            }
        //        }]];
        //
        //        dispatch_async(dispatch_get_main_queue(), ^ {
        //            [[KWTGRootViewController sharedController] presentViewController:alertController animated:YES completion:nil];
        //        });
    }
    
    [self.manager.reachabilityManager startMonitoring];
}

- (BOOL)isAFNetworkingConnected {
    return self.manager.reachabilityManager.reachable;
}

- (void)getRequest:(NSString *)get
        parameters:(id)parameters
          progress:(RequestProgressBlock)progressBlock
           success:(RequestSuccessBlock)successBlock
            failed:(RequestFailedBlock)failedBlock
     authenticated:(BOOL)authenticated {
    
    [self initializeManagerAuthenticated:authenticated];
    
    RequestProgressBlock requestProgressBlock = ^(NSProgress *progress) {
        
        progressBlock(progress);
    };
    
    RequestSuccessBlock requestSuccessBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        successBlock(task, responseObject);
    };
    
    RequestFailedBlock requestFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
//        [ProgressHUD dismiss];
        
        failedBlock(task, error);
    };
    
    NSLog(LOG_API, get);
    NSLog(PARAM_API, parameters);
    [self.manager GET:get parameters:parameters progress:requestProgressBlock success:requestSuccessBlock failure:requestFailedBlock];
}

- (void)postRequest:(NSString *)post
         parameters:(id)parameters
           progress:(RequestProgressBlock)progressBlock
            success:(RequestSuccessBlock)successBlock
             failed:(RequestFailedBlock)failedBlock
      authenticated:(BOOL)authenticated {
    
    [self initializeManagerAuthenticated:authenticated];
    
    RequestProgressBlock requestProgressBlock = ^(NSProgress *progress) {
        
        progressBlock(progress);
    };
    
    RequestSuccessBlock requestSuccessBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        successBlock(task, responseObject);
    };
    
    RequestFailedBlock requestFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
//        [ProgressHUD dismiss];
        
        failedBlock(task, error);
    };
    
    NSLog(LOG_API, post);
    NSLog(PARAM_API, parameters);
    [self.manager POST:post parameters:parameters progress:requestProgressBlock success:requestSuccessBlock failure:requestFailedBlock];
}

- (void)postRequest:(NSString *)post
         parameters:(id)parameters
           progress:(RequestProgressBlock)progressBlock
            success:(RequestSuccessBlock)successBlock
             failed:(RequestFailedBlock)failedBlock
authenticatedForHTTP:(BOOL)authenticated {
    
    [self initializeManagerAuthenticatedForHTTP:authenticated];
    
    RequestProgressBlock requestProgressBlock = ^(NSProgress *progress) {
        
        progressBlock(progress);
    };
    
    RequestSuccessBlock requestSuccessBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        successBlock(task, responseObject);
    };
    
    RequestFailedBlock requestFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
//        [ProgressHUD dismiss];
        
        failedBlock(task, error);
    };
    
    NSLog(LOG_API, post);
    NSLog(PARAM_API, parameters);
    [self.manager POST:post parameters:parameters progress:requestProgressBlock success:requestSuccessBlock failure:requestFailedBlock];
}

- (void)initializeManagerAuthenticatedForHTTP:(BOOL)authenticated {
    self.manager = [AFHTTPSessionManager manager];
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (authenticated) {
        NSString *token = [[NSUserDefaults standardUserDefaults]stringForKey:USERDEFAULT_TOKEN_STRING];
        [self.manager.requestSerializer setValue:[NSString stringWithFormat:AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE, token]
                              forHTTPHeaderField:AF_HTTPHEADERFIELD_AUTHENTICATION];
    }
    
    [self startAFNetworkingReachability];
}

- (void)initializeManagerAuthenticated:(BOOL)authenticated {
    self.manager = [AFHTTPSessionManager manager];
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    //    [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (authenticated) {
        NSString *token = [[NSUserDefaults standardUserDefaults]stringForKey:USERDEFAULT_TOKEN_STRING];
        [self.manager.requestSerializer setValue:[NSString stringWithFormat:AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE, token]
                              forHTTPHeaderField:AF_HTTPHEADERFIELD_AUTHENTICATION];
    }
    
    [self startAFNetworkingReachability];
}

- (void)getRequest:(NSString *)get
        parameters:(id)parameters
          progress:(RequestProgressBlock)progressBlock
           success:(RequestSuccessBlock)successBlock
            failed:(RequestFailedBlock)failedBlock
authenticatedForImage:(BOOL)authenticated {
    
    [self initializeManagerAuthenticatedForImage:authenticated];
    
    RequestSuccessBlock requestSuccessBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response Object Image: %@", responseObject);
        
        successBlock(task, responseObject);
    };
    
    RequestFailedBlock requestFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
//        [ProgressHUD dismiss];
        
        failedBlock(task, error);
    };
    
    NSLog(LOG_API, get);
    NSLog(PARAM_API, parameters);
    [self.manager GET:get parameters:parameters progress:progressBlock success:requestSuccessBlock failure:requestFailedBlock];
}

- (void)initializeManagerAuthenticatedForImage:(BOOL)authenticated {
    self.manager = [AFHTTPSessionManager manager];
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    if (authenticated) {
        NSString *token = [[NSUserDefaults standardUserDefaults]stringForKey:USERDEFAULT_TOKEN_STRING];
        [self.manager.requestSerializer setValue:[NSString stringWithFormat:AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE, token]
                              forHTTPHeaderField:AF_HTTPHEADERFIELD_AUTHENTICATION];
    }
    
    [self startAFNetworkingReachability];
}

- (void)postRequest:(NSString *)post
         parameters:(id)parameters
              image:(UIImage *)image
           progress:(RequestProgressBlock)progressBlock
            success:(RequestSuccessBlock)successBlock
             failed:(RequestFailedBlock)failedBlock
authenticatedForImage:(BOOL)authenticated {
    
    NSLog(LOG_API, post);
    NSLog(PARAM_API, parameters);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:post parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    RequestProgressBlock requestProgressBlock = ^(NSProgress *progress) {
        
        progressBlock(progress);
    };
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request
                                               progress:requestProgressBlock
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (error) {
                                              NSLog(@"Error: %@", [error description]);
                                              
//                                              [ProgressHUD dismiss];
                                              
                                              failedBlock(nil, error);
                                          } else {
                                              NSLog(@"Response Object: %@", responseObject);
                                              
                                              successBlock(nil, responseObject);
                                          }
                                      }];
    
    [uploadTask resume];
}

- (void)initializeManagerAuthenticatedForSocket:(NSString *)urlString {
    
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    //    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES, @"reconnects": @YES, @"forceNew": @YES}];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES, @"reconnects": @YES, @"forceNew": @YES}];
    
    [self.socket onAny:^(SocketAnyEvent * _Nonnull handler) {
        NSLog(@"ONANY: %@", handler);
    }];
    
    [self.socket connect];
}

- (void)socketEventRequest:(NSString *)eventRequest
             eventResponse:(NSString *)eventResponse
                parameters:(id)parameters
               socketBlock:(RequestSocketBlock)socketBlock {
    
    RequestSocketBlock requestSocketBlock = ^(NSArray *data, SocketAckEmitter *ack) {
        
//        [ProgressHUD dismiss];
        
        socketBlock(data, ack);
    };
    
    NSLog(LOG_API, eventRequest);
    NSLog(LOG_API, eventResponse);
    NSLog(PARAM_API, parameters);
    
    [self.socket emit:eventRequest with:parameters];
    
    [self.socket once:eventResponse callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"Response Object: %@", data);
        
        requestSocketBlock(data, ack);
    }];
}

- (void)socketOnEventResponse:(NSString *)eventResponse
                  socketBlock:(RequestSocketBlock)socketBlock {
    
    RequestSocketBlock requestSocketBlock = ^(NSArray *data, SocketAckEmitter *ack) {
        
//        [ProgressHUD dismiss];
        
        socketBlock(data, ack);
    };
    
    NSLog(LOG_API, eventResponse);
    
    [self.socket on:eventResponse callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"Response Object: %@", data);
        
        requestSocketBlock(data, ack);
    }];
}

- (void)socketOnceEventResponse:(NSString *)eventResponse socketBlock:(RequestSocketBlock)socketBlock {
    
    RequestSocketBlock requestSocketBlock = ^(NSArray *data, SocketAckEmitter *ack) {
        
//        [ProgressHUD dismiss];
        
        socketBlock(data, ack);
    };
    
    NSLog(LOG_API, eventResponse);
    
    [self.socket once:eventResponse callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"Response Object: %@", data);
        
        requestSocketBlock(data, ack);
    }];
}

@end
