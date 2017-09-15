//
//  CSRequestManager.m
//  Pods
//
//  Created by Cris Uy on 15/03/2017.
//
//

#import "CSRequestManager.h"
#import "CSRequestFileData.h"

#define USERDEFAULT_TOKEN_STRING                @"token"
#define AF_HTTPHEADERFIELD_AUTHENTICATION       @"Authorization"
#define AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE @"Bearer %@"

#define LOG_API                                 @"API: %@"
#define LOG_SOCKET_API_REQUEST                  @"API Socket Request: %@"
#define LOG_SOCKET_API_RESPONSE                 @"API Socket Response: %@"

#define PARAM_API                               @"PARAM: %@"

static CSRequestManager* _sharedManager = nil;

@interface CSRequestManager ()

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

- (void)monitortAFNetworkingReachabilityStatus:(RequestReachabilityBlock)reachabilityBlock {
    [self.httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"AFNetworkingReachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        reachabilityBlock(status);
    }];
}

- (BOOL)isAFNetworkingConnected {
    return self.httpManager.reachabilityManager.reachable;
}

- (void)initializeHTTPManagerAuthenticated:(BOOL)authenticated {
    
    if (self.httpManager) {
        
        [self checkAuthentication:authenticated];
        
        return;
    }
    
    self.httpManager = [AFHTTPSessionManager manager];
    self.httpManager.securityPolicy.allowInvalidCertificates = YES;
    
    self.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];      // HTTP Request
    self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];    // JSON Response
    
    [self checkAuthentication:authenticated];
    
    [self.httpManager.reachabilityManager startMonitoring];
    
    self.queue = [NSOperationQueue new];
}

- (void)checkAuthentication:(BOOL)authenticated {
    
    if (authenticated) {
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_TOKEN_STRING];
        [self.httpManager.requestSerializer setValue:[NSString stringWithFormat:AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE, token]
                                  forHTTPHeaderField:AF_HTTPHEADERFIELD_AUTHENTICATION];
    }
    
}

- (void)request:(NSString *)URLString
         method:(CSHttpMethod)method
     parameters:(id)parameters
       progress:(RequestProgressBlock)progressBlock
        success:(RequestSuccessBlock)successBlock
         failed:(RequestFailedBlock)failedBlock
  authenticated:(BOOL)authenticated
canCancelOperation:(BOOL)canCancelOperation {
    [self request:URLString
           method:method
       parameters:parameters
         progress:progressBlock
          success:successBlock
           failed:failedBlock
    authenticated:authenticated
    isSynchronous:NO
   dispatchGroupT:nil
canCancelOperation:canCancelOperation];
}

- (void)request:(NSString *)URLString
         method:(CSHttpMethod)method
     parameters:(id)parameters
       progress:(RequestProgressBlock)progressBlock
        success:(RequestSuccessBlock)successBlock
         failed:(RequestFailedBlock)failedBlock
  authenticated:(BOOL)authenticated
  isSynchronous:(BOOL)isSynchronous dispatchGroupT:(dispatch_group_t)dispatchGroupT
canCancelOperation:(BOOL)canCancelOperation {

    [self initializeHTTPManagerAuthenticated:authenticated];
    
    if (canCancelOperation) {
        [self.httpManager.operationQueue cancelAllOperations];
    }
    
    RequestProgressBlock requestProgressBlock = ^(NSProgress *progress) {
        
        progressBlock(progress);
    };
    
    RequestSuccessBlock requestSuccessBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        successBlock(task, responseObject);
        
        if (isSynchronous) {
            dispatch_group_leave(dispatchGroupT);
        }
    };
    
    RequestFailedBlock requestFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *errorData = [errorResponse dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];

        if (responseDictionary) {
            successBlock(task, responseDictionary);
        } else {
            failedBlock(task, error);
        }
        
        if (isSynchronous) {
            dispatch_group_leave(dispatchGroupT);
        }
    };
    
    NSLog(LOG_API, URLString);
    NSLog(PARAM_API, parameters);
    
    if (isSynchronous) {
        dispatch_group_enter(dispatchGroupT);
    }
    
    switch (method) {
        case CSHttpMethodGet:
            [self.httpManager GET:URLString parameters:parameters progress:requestProgressBlock success:requestSuccessBlock failure:requestFailedBlock];
            break;
        case CSHttpMethodPost:
            [self.httpManager POST:URLString parameters:parameters progress:requestProgressBlock success:requestSuccessBlock failure:requestFailedBlock];
            break;
        case CSHttpMethodHead:
        {
            [self.httpManager HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask *task) {
                requestSuccessBlock(task, nil);
            } failure:requestFailedBlock];
        }
            break;
        case CSHttpMethodPut:
            [self.httpManager PUT:URLString parameters:parameters success:requestSuccessBlock failure:requestFailedBlock];
            break;
        case CSHttpMethodPatch:
            [self.httpManager PATCH:URLString parameters:parameters success:requestSuccessBlock failure:requestFailedBlock];
            break;
        case CSHttpMethodDelete:
            [self.httpManager DELETE:URLString parameters:parameters success:requestSuccessBlock failure:requestFailedBlock];
            break;
    }
}

- (void)initializeURLManager {
    
    if (self.urlManager) {
        return;
    }
    
    self.urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (NSString *)getHTTPMethodString:(CSHttpMethod)method {
    switch (method) {
        case CSHttpMethodGet:
            return @"GET";
        case CSHttpMethodPost:
            return @"POST";
        case CSHttpMethodHead:
            return @"HEAD";
        case CSHttpMethodPut:
            return @"PUT";
        case CSHttpMethodPatch:
            return @"PATCH";
        case CSHttpMethodDelete:
            return @"DELETE";
    }
}

- (void)request:(NSString *)URLString
         method:(CSHttpMethod)method
     parameters:(id)parameters
          files:(NSArray *)files
       progress:(RequestProgressBlock)progressBlock
        success:(RequestSuccessBlock)successBlock
         failed:(RequestFailedBlock)failedBlock
  authenticated:(BOOL)authenticated {

    NSLog(LOG_API, URLString);
    NSLog(PARAM_API, parameters);
    
    NSString *methodString = [self getHTTPMethodString:method];
    
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:methodString
                                                                                              URLString:URLString
                                                                                             parameters:parameters
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      int i = 0;
      for (CSRequestFileData *file in files) {
          [formData appendPartWithFileData:file.fileData name:file.key fileName:file.filename mimeType:file.mimeType];
          i++;
      }
                                                                              } error:&error];
    
    [self initializeURLManager];
    
    if (authenticated) {
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_TOKEN_STRING];
        [request setValue:[NSString stringWithFormat:AF_HTTPHEADERFIELD_AUTHENTICATION_VALUE, token]
       forHTTPHeaderField:AF_HTTPHEADERFIELD_AUTHENTICATION];
    }
    
    RequestProgressBlock requestProgressBlock = ^(NSProgress *progress) {
        progressBlock(progress);
    };
    
    RequestFailedBlock requestFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        
        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *errorData = [errorResponse dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
        
        if (responseDictionary) {
            successBlock(task, responseDictionary);
        } else {
            failedBlock(task, error);
        }
    };
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    uploadTask = [self.urlManager uploadTaskWithStreamedRequest:request
                                                       progress:requestProgressBlock
                                              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                  if (error) {
                                                      NSLog(@"Error: %@", [error description]);
                                                      
                                                      requestFailedBlock(uploadTask, error);
                                                  } else {
                                                      NSLog(@"Response Object: %@", responseObject);
                                                      
                                                      successBlock(uploadTask, responseObject);
                                                  }
                                               }];
    [uploadTask resume];
}

- (void)initializeManagerAuthenticatedForSocket:(NSString *)urlString {
    
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES, @"reconnects": @YES, @"forceNew": @YES}];
    
    [self.socket onAny:^(SocketAnyEvent * _Nonnull handler) {
        NSLog(@"ON ANY: %@", handler);
    }];
    
    [self.socket connect];
}

- (void)socketEventRequest:(NSString *)eventRequest
             eventResponse:(NSString *)eventResponse
                parameters:(id)parameters
               socketBlock:(RequestSocketBlock)socketBlock {
    
    RequestSocketBlock requestSocketBlock = ^(NSArray *data, SocketAckEmitter *ack) {
        socketBlock(data, ack);
    };
    
    NSLog(LOG_SOCKET_API_REQUEST, eventRequest);
    NSLog(LOG_SOCKET_API_RESPONSE, eventResponse);
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
        socketBlock(data, ack);
    };
    
    NSLog(LOG_SOCKET_API_RESPONSE, eventResponse);
    
    [self.socket on:eventResponse callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"Response Object: %@", data);
        
        requestSocketBlock(data, ack);
    }];
}

- (void)socketOnceEventResponse:(NSString *)eventResponse socketBlock:(RequestSocketBlock)socketBlock {
    
    RequestSocketBlock requestSocketBlock = ^(NSArray *data, SocketAckEmitter *ack) {
        socketBlock(data, ack);
    };
    
    NSLog(LOG_SOCKET_API_RESPONSE, eventResponse);
    
    [self.socket once:eventResponse callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"Response Object: %@", data);
        
        requestSocketBlock(data, ack);
    }];
}

@end
