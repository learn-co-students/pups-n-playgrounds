//
//  ContainerViewController.swift
//  Form
//
//  Created by William Robinson on 11/30/16.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import SnapKit

class ContainerViewController: UIViewController {
    
    // MARK: Transition Animation Type
    enum Animation {
        case none, slideUp, slideDown, slideLeft, slideRight
    }
    
    // MARK: Properties
    var childVC: UIViewController? {
        willSet {
            previousChildVC = childVC
            previousChildCenterXConstraint = childCenterXConstraint
            previousChildCenterYConstraint = childCenterYConstraint
            
            previousChildFadeView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            previousChildFadeView.effect = UIBlurEffect(style: .dark)
            previousChildFadeView.alpha = 0
            
            previousChildVC?.view.addSubview(previousChildFadeView)
        }
    }
    
    var childCenterXConstraint: Constraint?
    var childCenterYConstraint: Constraint?
    
    var previousChildVC: UIViewController?
    var previousChildCenterXConstraint: Constraint?
    var previousChildCenterYConstraint: Constraint?
    lazy var previousChildFadeView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.themeMarine
    }
    
    // MARK: Setup
    func setup(forAnimation animation: Animation) {
        guard let childVC = childVC else { print("error unwrapping child view controller"); return }
        
        // Add child view controller
        addChildViewController(childVC)
        
        // Add child view
        view.addSubview(childVC.view)
        
        // Constrain child view
        childVC.view.snp.makeConstraints {
            switch animation {
            case .slideUp:
                childCenterXConstraint = $0.centerX.equalToSuperview().constraint
                childCenterYConstraint = $0.centerY.equalToSuperview().offset(view.frame.height).constraint
            case .slideDown:
                childCenterXConstraint = $0.centerX.equalToSuperview().constraint
                childCenterYConstraint = $0.centerY.equalToSuperview().offset(-view.frame.height).constraint
            case .slideLeft:
                childCenterXConstraint = $0.centerX.equalToSuperview().offset(view.frame.width).constraint
                childCenterYConstraint = $0.centerY.equalToSuperview().constraint
            case .slideRight:
                childCenterXConstraint = $0.centerX.equalToSuperview().offset(-view.frame.width).constraint
                childCenterYConstraint = $0.centerY.equalToSuperview().constraint
            default:
                childCenterXConstraint = $0.centerX.equalToSuperview().constraint
                childCenterYConstraint = $0.centerY.equalToSuperview().constraint
            }
            
            $0.width.height.equalToSuperview()
        }
        
        // Notify child of movement
        childVC.didMove(toParentViewController: self)
        
        // Begin transition animation
        animate(withAnimation: animation)
    }
    
    // MARK: Animate Transition
    private func animate(withAnimation animation: Animation) {
        var previousChildCenterYConstraintOffset: CGFloat?
        var childCenterYConstraintOffset: CGFloat?
        
        var previousChildCenterXConstraintOffset: CGFloat?
        var childCenterXConstraintOffset: CGFloat?
        
        switch animation {
        case .slideUp:
            previousChildCenterYConstraintOffset = -self.view.frame.height
            childCenterYConstraintOffset = 0
        case .slideDown:
            previousChildCenterYConstraintOffset = self.view.frame.height
            childCenterYConstraintOffset = 0
        case .slideLeft:
            previousChildCenterXConstraintOffset = -self.view.frame.width
            childCenterXConstraintOffset = 0
        case .slideRight:
            previousChildCenterXConstraintOffset = -self.view.frame.width
            childCenterXConstraintOffset = 0
        default:
            break
        }
        
        // Begin animation
        view.layoutIfNeeded()
        UIView.animateKeyframes(
            withDuration: 0.4,
            delay: 0,
            options: UIViewKeyframeAnimationOptions(animationOptions: .curveEaseInOut),
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    
                    // Blur previous view
                    self.previousChildFadeView.alpha = 1
                    self.view.layoutIfNeeded()
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                    
                    // Slide up and down
                    if let previousOffset = previousChildCenterYConstraintOffset,
                        let offset = childCenterYConstraintOffset {
                        self.previousChildCenterYConstraint?.update(offset: previousOffset)
                        self.childCenterYConstraint?.update(offset: offset)
                        
                        // Slide left and right
                    } else if let previousOffset = previousChildCenterXConstraintOffset,
                        let offset = childCenterXConstraintOffset {
                        self.previousChildCenterXConstraint?.update(offset: previousOffset)
                        self.childCenterXConstraint?.update(offset: offset)
                    }
                    
                    self.view.layoutIfNeeded()
                }
        }) { _ in
            self.previousChildVC?.view.subviews.last?.removeFromSuperview()
            self.removePreviousChild()
        }
    }
    
    // MARK: Remove Previous Child
    private func removePreviousChild() {
        
        // Notify previous child of removal
        previousChildVC?.willMove(toParentViewController: nil)
        
        // Remove constraints on previous child view
        previousChildCenterXConstraint = nil
        previousChildCenterYConstraint = nil
        
        // Remove previous child view
        previousChildVC?.view.removeFromSuperview()
        
        // Remove previous child
        previousChildVC?.removeFromParentViewController()
    }
}
