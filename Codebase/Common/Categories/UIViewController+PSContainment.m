#import "UIViewController+PSContainment.h"

@implementation UIViewController (PSContainment)


- (void)installChildVC: (UIViewController*) childVC toContainerView:(UIView *)containerView;
{
    [self installChildVC:childVC toContainerView:containerView edgeInsets:UIEdgeInsetsZero];
}

- (void)installChildVC: (UIViewController*) childVC toContainerView:(UIView *)containerView edgeInsets:(UIEdgeInsets)edgeInsets {
    
    if (childVC && [containerView isDescendantOfView:self.view]) {
        
        [self addChildViewController:childVC];
        
        CGRect containerRect = containerView.bounds;
        containerRect.origin.x += edgeInsets.left;
        containerRect.origin.y += edgeInsets.top;
        containerRect.size.width -= edgeInsets.left + edgeInsets.right;
        containerRect.size.height -= edgeInsets.top + edgeInsets.bottom;
        childVC.view.frame = containerRect;

        childVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [containerView addSubview:childVC.view];
        
        [childVC didMoveToParentViewController:self];
    }
}

-(void)installChildVC: (UIViewController*) childVC
      toContainerView:(UIView *)containerView
          layoutBlock:(void(^)(UIView *childView, UIView *containerView))layoutBlock {
    
    
    if (childVC && [containerView isDescendantOfView:self.view]) {
        
        [self addChildViewController:childVC];
        [containerView addSubview:childVC.view];
        
        if (layoutBlock) {
            layoutBlock(childVC.view, containerView);
        }
        
        [childVC didMoveToParentViewController:self];
    }
}

-(void)uninstallFromParent {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
