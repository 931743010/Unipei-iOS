#import <UIKit/UIKit.h>

@interface UIViewController (PSContainment)

/// Remove self from parent view conroller, all in one
-(void)uninstallFromParent;

/// Add a child view controller to a descendant view of self.view
- (void)installChildVC: (UIViewController*) childVC toContainerView:(UIView *)containerView;

- (void)installChildVC: (UIViewController*) childVC toContainerView:(UIView *)containerView edgeInsets:(UIEdgeInsets)edgeInsets;

-(void)installChildVC: (UIViewController*) childVC
      toContainerView:(UIView *)containerView
          layoutBlock:(void(^)(UIView *childView, UIView *containerView))layoutBlock;

@end
