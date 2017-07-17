//
//  CSTabView.m
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import "CSTabView.h"

@implementation CSTabView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectionTabIndex:(NSInteger)index {
    
    for(int i = 0 ; i < self.viewControllers.count ; i++) {
        
        UIButton* button = [self valueForKey:[NSString stringWithFormat:@"sectionTabButton0%d",i+1]];
        UIView* view = [self valueForKey:[NSString stringWithFormat:@"sectionTabView0%d", i+1]];
        UILabel *label = [self valueForKey:[NSString stringWithFormat:@"sectionTabLabel0%d", i+1]];
        
        if(!button) break;
        
        BOOL isSelectIndex = (i == index);
        
        //        [button setEnabled:!isSelectIndex];
        [button setSelected:isSelectIndex];
        
        if (isSelectIndex) {
            view.alpha = 1.0f;
            
            if (self.labelBackgroundHighlightColor) {
                label.textColor = self.labelBackgroundHighlightColor;
            }
            
            if (self.tabBackgroundHighlightColor) {
                view.backgroundColor = self.tabBackgroundHighlightColor;
            }
        } else {
            view.alpha = 0.0f;
            
            if (self.labelBackgroundNormalColor) {
                label.textColor = self.labelBackgroundNormalColor;
            }
            
            if (self.tabBackgroundNormalColor) {
                view.backgroundColor = self.tabBackgroundNormalColor;
            }
        }
    }
}

- (void)setTabBackgroundHighlightColor:(UIColor *)color {
    self.tabBackgroundHighlightColor = color;
}

- (void)setTabBackgroundNormalColor:(UIColor *)color {
    self.tabBackgroundNormalColor = color;
}

- (void)setTabLabelHighlightColor:(UIColor *)color {
    self.labelBackgroundHighlightColor = color;
}

- (void)setTabLabelNormalColor:(UIColor *)color {
    self.labelBackgroundNormalColor = color;
}

- (void)setSectionTabTitles:(NSArray*)titles {
    
    for (int i = 0 ; i < self.viewControllers.count; i++) {
        
        UILabel *label = [self valueForKey:[NSString stringWithFormat:@"sectionTabLabel0%d", i+1]];

        if (!label) break;
        
        label.text = [titles objectAtIndex:i];
        
        //        UIButton* button = [self valueForKey:[NSString stringWithFormat:@"sectionTabButton0%d",i+1]];
        //
        //        if(!button) break;
        //
        //        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        //        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateHighlighted];
        //        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateSelected];
        //        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateDisabled];
        //
        //        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
        //        [button setExclusiveTouch:YES];
    }
}

- (IBAction)didTouchUpTabButtonAction:(id)sender {
    NSInteger index = [(UIButton*)sender tag];
    
    [self setSelectionTabIndex:index];
    
    if(delegate && [delegate respondsToSelector:@selector(didTouchUpSectionTabWithTabIndex:)]) {
        [delegate didTouchUpSectionTabWithTabIndex:index];
    }
}

- (void)setFullTabSelected {
    
    self.sectionTabViewConstraint01.constant = self.frame.size.height;
    self.sectionTabViewConstraint01.constant = self.frame.size.height;
}

@end
