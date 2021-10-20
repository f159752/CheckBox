//
//  BoxType.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 19.10.2021.
//

import UIKit

enum BoxType: Int {
  case boxTypeCircle = 0
  case boxTypeSquare

  var bgLayerName: String {
    return "bgLayer"
  }
  var borderLayerName: String {
    return "borderLayer"
  }
  var selectedElementLayerName: String {
    return "elementLayer"
  }
}
