//
//  LayerManager.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 19.10.2021.
//

import UIKit

class LayerManager {
  static func backgroundLayer(type: BoxType,
                          path: UIBezierPath,
                          fillColor: UIColor) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.name = type.bgLayerName
    layer.path = path.cgPath

    layer.fillColor = fillColor.cgColor
    layer.strokeColor = UIColor.clear.cgColor
    layer.lineWidth = 0
    return layer
  }
  
  static func borderLayer(type: BoxType,
                          path: UIBezierPath,
                          fillColor: UIColor = UIColor.clear,
                          strokeColor: UIColor,
                          lineWidth: CGFloat) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.name = type.borderLayerName
    layer.path = path.cgPath

    layer.fillColor = fillColor.cgColor
    layer.strokeColor = strokeColor.cgColor
    layer.lineWidth = lineWidth
    return layer
  }
  
  static func chechMark(type: BoxType,
                        path: UIBezierPath,
                        fillColor: UIColor = UIColor.clear,
                        strokeColor: UIColor,
                        lineWidth: CGFloat) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.name = type.selectedElementLayerName
    layer.path = path.cgPath

    layer.fillColor = fillColor.cgColor
    layer.strokeColor = strokeColor.cgColor
    layer.lineWidth = lineWidth
    return layer
  }
  
}
