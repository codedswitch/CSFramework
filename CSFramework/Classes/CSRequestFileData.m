//
//  CSRequestFileData.m
//  Pods
//
//  Created by Cris Uy on 15/03/2017.
//
//

#import "CSRequestFileData.h"

@implementation CSRequestFileData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

    if (self = [super init]) {
        
        self.fileData   = [dictionary objectForKey:@"fileData"];
        self.key        = [dictionary objectForKey:@"key"];
        self.filename   = [dictionary objectForKey:@"filename"];
        self.mimeType   = [dictionary objectForKey:@"mimeType"];
        
    }
    
    return self;

}

@end
