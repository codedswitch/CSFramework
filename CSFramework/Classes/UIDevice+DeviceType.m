//
//  UIDevice+DeviceType.m
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import "UIDevice+DeviceType.h"

@implementation UIDevice (DeviceType)

- (UIDeviceTypeScreenXIB)getDeviceTypeScreenXIB {
    
    NSInteger deviceScreenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger deviceScreenHeightPixel = [UIScreen mainScreen].nativeBounds.size.height;
    
    UIDeviceTypeScreenXIB deviceScreen;
    
    switch (deviceScreenHeight) {
        case 480:
            deviceScreen = UIDeviceTypeScreenXIB35;
            break;
        case 568:
            deviceScreen = UIDeviceTypeScreenXIB4;
            break;
        case 667:
            deviceScreen = UIDeviceTypeScreenXIB47;
            break;
        case 736:
            deviceScreen = UIDeviceTypeScreenXIB55;
            break;
        case 812:
            deviceScreen = UIDeviceTypeScreenXIB58;
            break;
        case 896:
            switch (deviceScreenHeightPixel) {
                case 1792:
                    deviceScreen = UIDeviceTypeScreenXIB61;
                    break;
                case 2688:
                    deviceScreen = UIDeviceTypeScreenXIB65;
                    break;
                default:
                    deviceScreen = UIDeviceTypeScreenXIB61;
                    break;
            }
            break;
        case 1024:
            deviceScreen = UIDeviceTypeScreenXIB97;
            break;
        case 1366:
            deviceScreen = UIDeviceTypeScreenXIB129;
            break;
        default:
            deviceScreen = UIDeviceTypeScreenXIB35;
            break;
    }
    
    return deviceScreen;
}

- (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end
