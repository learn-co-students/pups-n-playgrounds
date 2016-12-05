//
//  CustomAnnotationView.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    if hitView != nil { superview?.bringSubview(toFront: self) }
      
    return hitView
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let rect = bounds
    var isInsideRect = rect.contains(point)
    
    if !isInsideRect {
      for view in subviews {
        isInsideRect = view.bounds.contains(point)
        if isInsideRect { break }
      }
    }
    
    return isInsideRect
  }
}
