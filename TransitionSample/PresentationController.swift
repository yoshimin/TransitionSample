//
//  PresentationController.swift
//  TransitionSample
//
//  Created by SHINGAI YOSHIMI on 2019/01/22.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    private enum Style {
        case compact
        case expanded

        var ratio: CGFloat {
            switch self {
            case .compact: return 0.5
            case .expanded: return 1
            }
        }
    }
    private let dimmingView = UIView()
    private var style: Style = .compact

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView else { return }

        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, at: 0)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmingView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor)
            ])
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView)))

        presentedViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0.5
        })
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
        super.dismissalTransitionDidEnd(completed)
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height * style.ratio)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        let s = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.frame.size)
        let o = CGPoint(x: 0, y: containerView.frame.height - s.height)
        return CGRect(origin: o, size: s)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        updatePresentedViewFrame(animated: false)
    }
}

private extension PresentationController {
    func updatePresentedViewFrame(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            self.presentedView?.layoutIfNeeded()
        }
    }

    @objc func didTapDimmingView() {
        dismiss()
    }

    func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let presentedView = presentedView, let containerView = containerView else { return }

        let translation = sender.translation(in: sender.view)
        presentedView.frame.size.height -= translation.y
        presentedView.frame.origin.y = containerView.frame.height - presentedView.frame.height
        presentedView.layoutIfNeeded()
        sender.setTranslation(.zero, in: presentedView)

        if sender.state == .ended {
            let maxHeight = containerView.frame.height
            if presentedView.frame.height < maxHeight * (Style.compact.ratio - 0)*0.5 {
                dismiss()
            } else if presentedView.frame.height < maxHeight * (Style.compact.ratio + (Style.expanded.ratio - Style.compact.ratio)*0.5) {
                style = .compact
                updatePresentedViewFrame(animated: true)
            } else {
                style = .expanded
                updatePresentedViewFrame(animated: true)
            }
        }
    }
}
