//
//  ViewController.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 19.10.2021.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var mainCheckBox: CheckBox!
  @IBOutlet var checkBoxChildren: [CheckBox]!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainCheckBox.delegate = self
    checkBoxChildren.forEach({ $0.delegate = self })
    mainCheckBox.addChildren(checkBoxChildren)
  }


}

extension ViewController: CheckBoxDelegate {
  func didChangeStateCheckBox(_ checkBox: CheckBox, state: CheckBox.State) {
    print(checkBox, state)
  }
}
