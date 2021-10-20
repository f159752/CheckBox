//
//  PathManager.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 19.10.2021.
//

import UIKit

class PathManager {
  private var size: CGFloat = 0
  private var cornerRadius: CGFloat = 0
  
  private var arcCenter: CGPoint = CGPoint.zero
  private var radius: CGFloat = 0
  private var startAngle: CGFloat = 0
  private var endAngle: CGFloat = Double.pi * 2
  
  public func pathFor(boxType: BoxType) -> UIBezierPath {
    switch boxType {
    case .boxTypeSquare:
      let rect = CGRect(origin: CGPoint(x: 0, y: 0),
                        size: CGSize(width: size, height: size))
      return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
    case .boxTypeCircle:
      return UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
  }
  
  public func pathFor(state: CheckBox.State) -> UIBezierPath {
    let path = UIBezierPath()
    if state == .on(full: true) {
      path.move(to: CGPoint(x: size * 0.3, y: size * 0.525))
      path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.725))
      path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.25))
    } else if state == .on(full: false) {
      path.move(to: CGPoint(x: size * 0.25, y: size * 0.5))
      path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.5))
    }
    return path
  }

  public func setup(arcCenter: CGPoint,
                    radius: CGFloat,
                    startAngle: CGFloat,
                    endAngle: CGFloat) {
    self.arcCenter = arcCenter
    self.radius = radius
    self.startAngle = startAngle
    self.endAngle = endAngle
  }
  
  public func setup(size: CGFloat,
                    cornerRadius: CGFloat) {
    self.size = size
    self.cornerRadius = cornerRadius
  }
  
  
  

}
