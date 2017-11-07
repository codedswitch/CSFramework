//
//  NSString+DeviceType.m
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import "NSString+DeviceType.h"
#import "UIDevice+DeviceType.h"

@implementation NSString (DeviceType)

- (NSString *)concatenateClassToDeviceType {
    
    switch ([[UIDevice currentDevice] getDeviceTypeScreenXIB]) {
        case UIDeviceTypeScreenXIB35:
            return [NSString stringWithFormat:@"%@", self];
        case UIDeviceTypeScreenXIB4:
            return [NSString stringWithFormat:@"%@~iphone4", self];
        case UIDeviceTypeScreenXIB47:
            return [NSString stringWithFormat:@"%@~iphone47", self];
        case UIDeviceTypeScreenXIB55:
            return [NSString stringWithFormat:@"%@~iphone55", self];
        case UIDeviceTypeScreenXIB58:
            return [NSString stringWithFormat:@"%@~iphone58", self];
        case UIDeviceTypeScreenXIB97:
            return [NSString stringWithFormat:@"%@~ipad97", self];
        case UIDeviceTypeScreenXIB129:
            return [NSString stringWithFormat:@"%@~ipad129", self];
    }
}

@end
