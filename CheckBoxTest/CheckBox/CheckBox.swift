//
//  CheckBox.swift
//  CheckBoxTest
//
//  Created by Artem Shpilka on 19.10.2021.
//

import UIKit

@IBDesignable class CheckBox: UIView {
  
  //MARK: - Private Variable
  private var _type: BoxType = .boxTypeCircle
  private var state = State.off {
    didSet {
      selected = state.selected
      fullSelected = state.selectedFull
    }
  }
  private let pathManager = PathManager()
  weak var delegate: CheckBoxDelegate?
  weak var owner: CheckBox? = nil
  private var children: [CheckBox] = []
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
    setupView()
  }

  override func prepareForInterfaceBuilder() {
    commonInit()
    setupView()
  }
  
  private func commonInit() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapCheckBox)))
  }
  
  //MARK: - Public Variable
  @IBInspectable
  var type: Int = 0 {
    didSet {
      _type = BoxType(rawValue: type) ?? .boxTypeCircle
      setupView()
    }
  }

  @IBInspectable
  var isActive: Bool = true {
    didSet {
      setupView()
    }
  }

  @IBInspectable
  var bgColor: UIColor = .black {
    didSet {
      setupView()
    }
  }

  @IBInspectable
  var selected: Bool = true {
    didSet {
      setupView()
    }
  }

  @IBInspectable
  var fullSelected: Bool = true {
    didSet {
      setupView()
    }
  }
  
  @IBInspectable
  var borderColor: UIColor = .green {
    didSet {
      setupView()
    }
  }
  
  @IBInspectable
  var onFullColor: UIColor = .green {
    didSet {
      setupView()
    }
  }
  
  @IBInspectable
  var onPartColor: UIColor = .gray {
    didSet {
      setupView()
    }
  }
  
  @IBInspectable
  var borderLineWidth: CGFloat = 5 {
    didSet {
      setupView()
    }
  }
  
  @IBInspectable
  var markLineWidth: CGFloat = 5 {
    didSet {
      setupView()
    }
  }
  
  @IBInspectable
  var cornerRadius: CGFloat = 5 {
    didSet {
      setupView()
    }
  }
  
  //MARK: - Public Methods
  public func addChild(_ checkBox: CheckBox) {
    checkBox.owner = self
    children.append(checkBox)
  }
  
  public func addChildren(_ newChildren: [CheckBox]) {
    newChildren.forEach({ $0.owner = self })
    children.append(contentsOf: newChildren)
  }
  
  public func removeChild(_ checkBox: CheckBox) {
    if let index = children.firstIndex(where: { $0 == checkBox }) {
      checkBox.owner = nil
      children.remove(at: index)
    }
  }

  //MARK: - Private Methods
  private func setupView() {
    pathManager.setup(size: frame.size.width,
                      cornerRadius: cornerRadius)
    pathManager.setup(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                      radius: frame.size.width / 2,
                      startAngle: 0,
                      endAngle: Double.pi * 2)
    drawBg()
    drawBorder()
    drawSelectedElement()
    
    backgroundColor = UIColor.clear
  }
  
  private func drawBg() {
    let bgLayer = LayerManager.backgroundLayer(
      type: _type,
      path: pathManager.pathFor(boxType: _type),
      fillColor: bgColor)
    addReplaceSublayer(bgLayer, name: _type.bgLayerName)
  }
  
  private func drawBorder() {
    let borderLayer = LayerManager.borderLayer(
      type: _type,
      path: pathManager.pathFor(boxType: _type),
      fillColor: .clear,
      strokeColor: borderColor,
      lineWidth: borderLineWidth)
    addReplaceSublayer(borderLayer, name: _type.borderLayerName)
  }
  
  private func drawSelectedElement() {
    switch state {
    case .off:
      removeSublayer(with: _type.selectedElementLayerName)
    case .on(_):
      let path = pathManager.pathFor(state: state)
      let checkMarkLayer = LayerManager.chechMark(type: _type,
                                                  path: path,
                                                  strokeColor: onFullColor,
                                                  lineWidth: markLineWidth)
      addReplaceSublayer(checkMarkLayer, name: _type.selectedElementLayerName)
    }
  }

  @objc
  private func handleTapCheckBox() {
    guard isActive else { return }
    changeState()
  }
  
  private func changeState() {
    // .off -> .on -> .off
    let oldState = state
    let newState: State = {
      return oldState == .off ? .on(full: true) : .off
    }()
    
    if let owner = owner {
      let children = owner.children.filter({ $0 != self })
      if children.allSatisfy({ $0.state == newState }) {
        if newState == .off {
          let newState = State.off
          owner.state = newState
          owner.delegate?.didChangeStateCheckBox(owner, state: newState)
        } else {
          let newState = State.on(full: true)
          owner.state = newState
          owner.delegate?.didChangeStateCheckBox(owner, state: newState)
        }
      } else {
        let newState = State.on(full: false)
        owner.state = newState
        owner.delegate?.didChangeStateCheckBox(owner, state: newState)
      }
    }

    if !children.isEmpty {
      if children.allSatisfy({ $0.state == oldState }) {
        if oldState == .off {
          children.forEach({
            let state = State.on(full: true)
            $0.state = state
            $0.delegate?.didChangeStateCheckBox($0, state: state)
          })
          state = .on(full: true)
        } else if oldState == .on(full: true) || oldState == .on(full: false) {
          children.forEach({
            let state = State.off
            $0.state = state
            $0.delegate?.didChangeStateCheckBox($0, state: state)
          })
          state = .off
        }
      } else {
        children.forEach({
          let state = State.off
          $0.state = state
          $0.delegate?.didChangeStateCheckBox($0, state: state)
        })
        state = .off
      }
    }
    
    state = newState
    delegate?.didChangeStateCheckBox(self, state: state)
  }
  
  //MARK: - Layers
  private func removeSublayer(with name: String) {
    if let index = layer.sublayers?.firstIndex(where: { $0.name == name }) {
      layer.sublayers?.remove(at: index)
    }
  }
  
  private func addReplaceSublayer(_ subLayer: CALayer, name: String) {
    if let oldLayer = layer.sublayers?.first(where: { $0.name == name }) {
      layer.replaceSublayer(oldLayer, with: subLayer)
    } else {
      layer.addSublayer(subLayer)
    }
  }
  
  //MARK: - State
  enum State {
    case off
    case on(full: Bool)

    init(selected: Bool, full: Bool) {
      switch (selected, full) {
      case (false, _):
        self = .off
      case (true, _):
        self = .on(full: full)
      }
    }
    
    private var id: Int {
      switch self {
      case .off: return 0
      case .on(let full):
        return full ? 1 : 2
      }
    }
    
    var selected: Bool {
      return self != .off
    }
    
    var selectedFull: Bool {
      switch self {
      case .on(let full):
        return full
      default:
        return false
      }
    }
    
    static func ==(lhs: State, rhs: State) -> Bool {
      return lhs.id == rhs.id
    }
    
    static func !=(lhs: State, rhs: State) -> Bool {
      return lhs.id != rhs.id
    }
  }
}

