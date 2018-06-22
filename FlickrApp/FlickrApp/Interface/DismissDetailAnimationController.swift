//
//  DismissDetailAnimationController.swift
//  FlickrApp
//
//  Created by melisadlg on 6/22/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

class DismissDetailAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var openingFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.alpha = 0.0
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            snapshotView?.frame = self.openingFrame!
            snapshotView?.alpha = 0.0
        }) { (_) -> Void in
            snapshotView?.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
