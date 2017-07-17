//
//  CSTabViewController.h
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import <UIKit/UIKit.h>
#import "CSTabView.h"
#import "CSTabViewDelegate.h"
#import "CSTabViewInternalDelegate.h"

@interface CSTabViewController : UIViewController <CSTabViewInternalDelegate> {
    IBOutlet UIView* sectionTabView;
    IBOutlet UIView* contentView;
}

@property(nonatomic, retain) CSTabView* tabView;
@property(nonatomic, retain) NSMutableArray* viewControllerArray;
@property(nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, retain) UIColor *tabBackgroundHighlightColor;
@property (nonatomic, retain) UIColor *tabBackgroundNormalColor;
@property (nonatomic, retain) UIColor *labelBackgroundHighlightColor;
@property (nonatomic, retain) UIColor *labelBackgroundNormalColor;

- (void)setViewControllers:(UIViewController<CSTabViewDelegate>*)argValues,...NS_REQUIRES_NIL_TERMINATION;
- (void)setSelectedTabIndex:(NSInteger)tabIndex;

@end
