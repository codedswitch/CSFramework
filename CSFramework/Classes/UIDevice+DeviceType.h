//
//  UIDevice+DeviceType.h
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UIDeviceTypeScreenXIB) {
    // iPhone 4s
    // index 0 in .xib
    UIDeviceTypeScreenXIB35    = 0,      // in points; width = 320, height = 480
    
    // iPhone 5
    // iPhone 5s
    // index 1 in .xib
    UIDeviceTypeScreenXIB4     = 1,      // in points; width = 320, height = 568
    
    // iPhone 6
    // iPhone 6s
    // index 2 in .xib
    UIDeviceTypeScreenXIB47    = 2,      // in points; width = 375, height = 667
    
    // iPhone 6+
    // iPhone 6s+
    // index 3 in .xib
    UIDeviceTypeScreenXIB55    = 3,      // in points; width = 414, height = 736
    
    // iPhone X
    UIDeviceTypeScreenXIB58    = 4,      // in points: width = 375, height = 812
    
    // iPad 2
    // iPad Air
    // iPad Air 2
    // iPad Retina
    // index 0 in ~ipad.xib
    UIDeviceTypeScreenXIB97    = 5,     // in points; width = 768, height = 1024
    
    // iPad Pro
    // index 1 in ~ipad.xib
    UIDeviceTypeScreenXIB129   = 6,     // in points; width = 1024, height = 1366
};

@interface UIDevice (DeviceType)

- (UIDeviceTypeScreenXIB)getDeviceTypeScreenXIB;
- (BOOL)isIpad;

@end
