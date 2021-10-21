//
//  AnimationManager.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 21.10.2021.
//

import UIKit


class AnimationManager {
  var animationDuration: CGFloat
  
  init(_ animationDuration: CGFloat) {
    self.animationDuration = animationDuration
  }
  
  func strokeAnimation(reverse: Bool) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = reverse ? 1.0 : 0.0
    animation.toValue = reverse ? 0.0 : 1.0
    animation.duration = animationDuration
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    return animation
  }

}
