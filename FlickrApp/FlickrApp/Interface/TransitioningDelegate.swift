//
//  TransitioningDelegate.swift
//  FlickrApp
//
//  Created by melisadlg on 6/22/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var openingFrame: CGRect!
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = PresentDetailAnimationController()
        presentationAnimator.openingFrame = openingFrame!
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator = DismissDetailAnimationController()
        dismissAnimator.openingFrame = openingFrame!
        return dismissAnimator
    }
}
