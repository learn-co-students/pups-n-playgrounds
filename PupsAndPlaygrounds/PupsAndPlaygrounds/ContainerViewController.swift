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
    case none, slideUp
  }
  
  // MARK: Properties
  var childVC: UIViewController? {
    willSet {
      previousChildVC = childVC
      previousChildCenterXConstraint = childCenterXConstraint
      previousChildCenterYConstraint = childCenterYConstraint
    }
  }
  var childCenterXConstraint: Constraint?
  var childCenterYConstraint: Constraint?
  
  var previousChildVC: UIViewController?
  var previousChildCenterXConstraint: Constraint?
  var previousChildCenterYConstraint: Constraint?
  
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
        $0.width.height.equalToSuperview()
      default:
        childCenterXConstraint = $0.centerX.equalToSuperview().constraint
        childCenterYConstraint = $0.centerY.equalToSuperview().constraint
        $0.width.height.equalToSuperview()
      }
    }
    
    // Notify child of movement
    childVC.didMove(toParentViewController: self)
    
    // Begin transition animation
    animate(withAnimation: animation)
  }
  
  // MARK: Animate Transition
  private func animate(withAnimation animation: Animation) {
    switch animation {
    case .slideUp:
      view.layoutIfNeeded()
      UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
        self.previousChildCenterYConstraint?.update(offset: -self.view.frame.height)
        self.childCenterYConstraint?.update(offset: 0)
        self.view.layoutIfNeeded()
      }) { _ in self.removePreviousChild() }
    default:
      break
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
