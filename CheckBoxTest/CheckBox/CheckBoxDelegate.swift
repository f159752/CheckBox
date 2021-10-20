//
//  CheckBoxDelegate.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 20.10.2021.
//

import Foundation

protocol CheckBoxDelegate: AnyObject {
  func didChangeStateCheckBox(_ checkBox: CheckBox, state: CheckBox.State)
}
