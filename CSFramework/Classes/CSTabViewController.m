//
//  CSTabViewController.m
//  Pods
//
//  Created by Cris Uy on 17/07/2017.
//
//

#import "CSTabViewController.h"
#import "NSString+DeviceType.h"

@interface CSTabViewController ()

@end

@implementation CSTabViewController
@synthesize selectedIndex;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        
        self.viewControllerArray = [NSMutableArray array];
        
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setSelectedTabIndex:(NSInteger)tabIndex {
    [self.tabView setSelectionTabIndex:tabIndex];
    [self didTouchUpSectionTabWithTabIndex:tabIndex];
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

- (void)refreshSectionTabView {
    
    NSArray* subViews = [sectionTabView subviews];
    
    for (UIView* view in subViews) {
        [view removeFromSuperview];
    }
    
    NSArray* viewArray = [[NSBundle mainBundle] loadNibNamed:[NSStringFromClass([CSTabView class]) concatenateClassToDeviceType] owner:self options:nil];
    
    CSTabView* tabView = [viewArray objectAtIndex:0];
    
    NSMutableArray* titleArray = [NSMutableArray array];
    
    for (UIViewController<CSTabViewDelegate>* viewController in self.viewControllerArray) {
        [titleArray addObject:[viewController titleForTabSectionInRootTabViewController]];
    }
    
    tabView.viewControllers = self.viewControllerArray;
    [tabView setSectionTabTitles:titleArray];
    [tabView setTabBackgroundNormalColor:self.tabBackgroundNormalColor];
    [tabView setTabBackgroundHighlightColor:self.tabBackgroundHighlightColor];
    [tabView setLabelBackgroundNormalColor:self.labelBackgroundNormalColor];
    [tabView setLabelBackgroundHighlightColor:self.labelBackgroundHighlightColor];
    
    tabView.delegate = self;
    
    self.tabView = tabView;
    
    [sectionTabView addSubview:tabView];
    
}

- (void)setViewControllers:(UIViewController<CSTabViewDelegate>*)argValues,... {
    
    self.viewControllerArray = [NSMutableArray array];
    
    va_list arguments;
    
    va_start(arguments, argValues);
    
    UIViewController* viewController = argValues;
    
    while (viewController) {
        
        [self.viewControllerArray addObject:viewController];
        
        // Next View Controller
        viewController = va_arg(arguments, typeof(UIViewController<CSTabViewDelegate>*));
    }
    
    va_end(arguments);
    
    [self refreshSectionTabView];
    
}

#pragma mark - TabViewInternalDelegate
- (void)didTouchUpSectionTabWithTabIndex:(NSInteger)index {
    self.selectedIndex = index;
    
    UIViewController* viewController = [self.viewControllerArray objectAtIndex:index];
    
    viewController.view.frame = contentView.bounds;
    
    NSArray* subViews = [contentView subviews];
    
    if (subViews.count > 0) {
        
        for (UIView* view in subViews) {
            [view removeFromSuperview];
        }
        
        [contentView addSubview:viewController.view];
        
        NSArray *aOSVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
        NSInteger iOSVersionMajor = [[aOSVersions objectAtIndex:0] intValue];
        
        if (iOSVersionMajor < 5) [viewController viewWillAppear:YES];
        
    } else {
        
        [contentView addSubview:viewController.view];
        
        [viewController viewWillAppear:YES];
    }
}

@end
