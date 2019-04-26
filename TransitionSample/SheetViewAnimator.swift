//
//  SheetViewAnimator.swift
//  TransitionSample
//
//  Created by SHINGAI YOSHIMI on 2019/01/22.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

class SheetViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Action {
        case present
        case dismiss
    }

    private let action: Action
    private let duration: TimeInterval

    init(action: Action, duration: TimeInterval = 0.25) {
        self.action = action
        self.duration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch action {
        case .present:
            presentationTransition(using: transitionContext)
        case .dismiss:
            dismissalTransitionWillBegin(using: transitionContext)
        }
    }
}

private extension SheetViewAnimator {
    func presentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(to.view)
        to.view.frame.origin.y = containerView.frame.height

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        to.view.frame.origin.y -= to.view.frame.height
        },
                       completion: { finished in
                        transitionContext.completeTransition(true)
        })
    }

    func dismissalTransitionWillBegin(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        from.view.frame.origin.y = containerView.frame.height
        },
                       completion: { finished in
                        transitionContext.completeTransition(true)
        })
    }
}
