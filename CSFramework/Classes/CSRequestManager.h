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
typedef void (^RequestReachabilityBlock)(AFNetworkReachabilityStatus status);

typedef void (^RequestSocketBlock)(NSArray *data, SocketAckEmitter *ack);

typedef NS_ENUM(NSInteger, CSHttpMethod) {
    CSHttpMethodGet     = 0,
    CSHttpMethodPost    = 1,
    CSHttpMethodHead    = 2,
    CSHttpMethodPut     = 3,
    CSHttpMethodPatch   = 4,
    CSHttpMethodDelete  = 5
};

@interface CSRequestManager : NSObject

+ (CSRequestManager *)sharedManager;

// HTTP(S)
@property (nonatomic, retain) AFHTTPSessionManager *httpManager;
@property (nonatomic, retain) AFURLSessionManager *urlManager;
@property (nonatomic, retain) NSOperationQueue *queue;

- (void)monitortAFNetworkingReachabilityStatus:(RequestReachabilityBlock)reachabilityBlock;

- (void)request:(NSString *)URLString
         method:(CSHttpMethod)method
     parameters:(id)parameters
       progress:(RequestProgressBlock)progressBlock
        success:(RequestSuccessBlock)successBlock
         failed:(RequestFailedBlock)failedBlock
  authenticated:(BOOL)authenticated
  isSynchronous:(BOOL)isSynchronous
 dispatchGroupT:(dispatch_group_t)dispatchGroupT
canCancelOperation:(BOOL)canCancelOperation;

// Upload Files (Array)
- (void)request:(NSString *)URLString
         method:(CSHttpMethod)method
     parameters:(id)parameters
          files:(NSArray *)files
       progress:(RequestProgressBlock)progressBlock
        success:(RequestSuccessBlock)successBlock
         failed:(RequestFailedBlock)failedBlock
  authenticated:(BOOL)authenticated;

// Socket
@property (nonatomic, retain) SocketIOClient* socket;

- (void)initializeManagerAuthenticatedForSocket:(NSString *)urlString;

- (void)socketEventRequest:(NSString *)eventRequest
             eventResponse:(NSString *)eventResponse
                parameters:(id)parameters
               socketBlock:(RequestSocketBlock)socketBlock;

- (void)socketOnEventResponse:(NSString *)eventResponse
                  socketBlock:(RequestSocketBlock)socketBlock;


- (void)socketOnceEventResponse:(NSString *)eventResponse
                    socketBlock:(RequestSocketBlock)socketBlock;

@end
