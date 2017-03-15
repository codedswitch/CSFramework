//
//  CSRequestFileData.h
//  Pods
//
//  Created by Cris Uy on 15/03/2017.
//
//

#import <Foundation/Foundation.h>

@interface CSRequestFileData : NSObject

@property (nonatomic, retain) NSData *fileData;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *mimeType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
