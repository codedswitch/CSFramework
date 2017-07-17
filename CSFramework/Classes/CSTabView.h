//
//  CSTabView.h
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import <UIKit/UIKit.h>
#import "CSTabViewInternalDelegate.h"

@interface CSTabView : UIView

@property (nonatomic, retain) IBOutlet UIButton* sectionTabButton01;
@property (nonatomic, retain) IBOutlet UIButton* sectionTabButton02;

@property (nonatomic, retain) IBOutlet UIView* sectionTabView01;
@property (nonatomic, retain) IBOutlet UIView* sectionTabView02;

@property (nonatomic, retain) IBOutlet UILabel *sectionTabLabel01;
@property (nonatomic, retain) IBOutlet UILabel *sectionTabLabel02;

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *sectionTabViewConstraint01;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *sectionTabViewConstraint02;

@property (nonatomic, assign) id<CSTabViewInternalDelegate> delegate;

@property (nonatomic, retain) NSArray *viewControllers;

@property (nonatomic, retain) UIColor *tabBackgroundHighlightColor;
@property (nonatomic, retain) UIColor *tabBackgroundNormalColor;
@property (nonatomic, retain) UIColor *labelBackgroundHighlightColor;
@property (nonatomic, retain) UIColor *labelBackgroundNormalColor;

- (void)setSelectionTabIndex:(NSInteger)index;
- (void)setSectionTabTitles:(NSArray*)titles;
- (IBAction)didTouchUpTabButtonAction:(id)sender;

- (void)setFullTabSelected;

@end
