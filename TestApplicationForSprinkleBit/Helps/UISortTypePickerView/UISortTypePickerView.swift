//
//  UISortTypePickerView.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

// MARK: - SortType
enum SortType: Int {
    case byAdding = 0
    case byName = 1
    case byYearPublishing = 2
    case byRating = 3
}

class SortTypeModel: NSObject {
    let sortType: SortType
    let name: String
    
    init(type: SortType, name: String) {
        self.sortType = type
        self.name = name
        super.init()
    }
}

// MARK: - Protocol
@objc protocol UISortTypePickerViewrDelegate {
    func pickerView(_ pickerView: UISortTypePickerView, didSelectRow row: Int, inComponent component: Int)
    @objc optional func pickerViewDidCancel(_ pickerView: UISortTypePickerView)
}

// MARK: - Protocol
@objc protocol UISortTypePickerViewDataSource {
    @objc optional func numberOfComponents(in pickerView: UISortTypePickerView) -> Int
    func pickerView(_ pickerView: UISortTypePickerView, numberOfRowsInComponent component: Int) -> Int
    func pickerView(_ pickerView: UISortTypePickerView, titleForRow row: Int, forComponent component: Int) -> String?
}

class UISortTypePickerView: UIViewController {
    weak var delegate: UISortTypePickerViewrDelegate? = nil
    weak var dataSources: UISortTypePickerViewDataSource? = nil

    private var containerView = UIView()
    var pickerView = UIPickerView()
    private var scrollToRow: Int = 0
    private var component: Int = 0
    private var row: Int = 0

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupStyle()
    }
    
    convenience init(scrollToRow: Int) {
        self.init()
        self.setupStyle()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.scrollToRow = scrollToRow
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    func setupStyle() {
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + 260.0, width: self.view.frame.size.width, height: 260.0)
        
        pickerView.frame = CGRect(x: 0.0, y: 44.0, width: self.view.frame.size.width, height: 216.0)
        pickerView.backgroundColor = UIColor.white
        pickerView.clipsToBounds = false
        
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 44.0))
        pickerToolBar.barStyle = .default
        pickerToolBar.isTranslucent = true
        pickerToolBar.tintColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        pickerToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: DPAutolocalizedString("filter_done_button", nil), style: .done, target: self, action: #selector(doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: DPAutolocalizedString("filter_done_cancel", nil), style: .plain, target: self, action: #selector(cancelAction))
        
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = DPAutolocalizedString("UISortTypePickerView_title", nil)
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
        titleLabel.textColor = UIColor.black
        
        let titleBarBtn = UIBarButtonItem(customView: titleLabel)
        
        pickerToolBar.items = [cancelButton, spaceButton, titleBarBtn, spaceButton, doneButton]
        pickerToolBar.isUserInteractionEnabled = true
        
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
        self.view.addGestureRecognizer(cancelTap)
        
        containerView.addSubview(pickerView)
        containerView.addSubview(pickerToolBar)
        self.view.addSubview(containerView)
        
        self.pickerView.selectRow(scrollToRow, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showPicker(animated: true)
    }
    
    private func showPicker(animated: Bool) {
        if (animated) {
            UIView.animate(withDuration: 0.25) {
                self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            }
        } else {
            containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - containerView.frame.size.height, width: containerView.frame.size.width, height: containerView.frame.size.height)
        }
        
    }
    
    @objc private func doneAction() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        }) { (finish) in
            if (finish) {
                
                self.dismiss(animated: true, completion: {
                    if let method = self.delegate?.pickerView {
                        return method(self, self.row, self.component)
                    }
                })
            }
        }
    }
    
    @objc private func cancelAction() {
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        }) { (finish) in
            if (finish) {
                self.dismiss(animated: true, completion: {
                    if let method = self.delegate?.pickerViewDidCancel?(self) {
                        return method
                    }
                })
            }
        }
    }
}

extension UISortTypePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let method = self.dataSources?.numberOfComponents?(in: self) {
            return method
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let method = self.dataSources?.pickerView(self, numberOfRowsInComponent: component) {
            return method
        }
        return 0
    }
}

extension UISortTypePickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.component = component
        self.row = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let method = self.dataSources?.pickerView(self, titleForRow: row, forComponent: component) {
            return method
        }
        return ""
    }
}
