//
//  CSRequestManager.h
//  Pods
//
//  Created by Cris Uy on 15/03/2017.
//
//

#import <Foundation/Foundation.h>

@import AFNetworking;
@import SocketIO;

typedef void (^RequestProgressBlock)(NSProgress *progress);
typedef void (^RequestSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^RequestFailedBlock)(NSURLSessionDataTask *task, NSError *error);

typedef void (^RequestSocketBlock)(NSArray *data, SocketAckEmitter *ack);

@interface CSRequestManager : NSObject

@property (nonatomic, retain) AFHTTPSessionManager *manager;
@property (nonatomic, retain) SocketIOClient* socket;

+ (CSRequestManager *)sharedManager;

- (void)initializeManagerAuthenticatedForSocket:(NSString *)urlString;

- (void)getRequest:(NSString *)get
        parameters:(id)parameters
          progress:(RequestProgressBlock)progressBlock
           success:(RequestSuccessBlock)successBlock
            failed:(RequestFailedBlock)failedBlock
     authenticated:(BOOL)authenticated;

- (void)postRequest:(NSString *)post
         parameters:(id)parameters
           progress:(RequestProgressBlock)progressBlock
            success:(RequestSuccessBlock)successBlock
             failed:(RequestFailedBlock)failedBlock
      authenticated:(BOOL)authenticated;

- (void)postRequest:(NSString *)post
         parameters:(id)parameters
           progress:(RequestProgressBlock)progressBlock
            success:(RequestSuccessBlock)successBlock
             failed:(RequestFailedBlock)failedBlock
authenticatedForHTTP:(BOOL)authenticated;

- (void)getRequest:(NSString *)get
        parameters:(id)parameters
          progress:(RequestProgressBlock)progressBlock
           success:(RequestSuccessBlock)successBlock
            failed:(RequestFailedBlock)failedBlock
authenticatedForImage:(BOOL)authenticated;

// Upload Image
- (void)postRequest:(NSString *)post
         parameters:(id)parameters
              image:(UIImage *)image
           progress:(RequestProgressBlock)progressBlock
            success:(RequestSuccessBlock)successBlock
             failed:(RequestFailedBlock)failedBlock
authenticatedForImage:(BOOL)authenticated;

- (void)socketEventRequest:(NSString *)eventRequest
             eventResponse:(NSString *)eventResponse
                parameters:(id)parameters
               socketBlock:(RequestSocketBlock)socketBlock;

- (void)socketOnEventResponse:(NSString *)eventResponse
                  socketBlock:(RequestSocketBlock)socketBlock;


- (void)socketOnceEventResponse:(NSString *)eventResponse
                    socketBlock:(RequestSocketBlock)socketBlock;

@end
