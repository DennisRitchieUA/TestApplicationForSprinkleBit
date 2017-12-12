//
//  PageSegment.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class SegmengModel : NSObject {
    var segmentSize:CGFloat = 0.0
    var xPosition:CGFloat = 0.0
    
    static func initWithSegmentSize(segmentSize: CGFloat, xPosition: CGFloat) -> SegmengModel {
        let model = SegmengModel()
        model.segmentSize = segmentSize
        model.xPosition = xPosition
        return model
    }
}

class PageSegment: UISegmentedControl {
    
    var selectedIndicator:UIView? = nil
    var dataSource = [SegmengModel]()
    var onScrollView:UIScrollView? = nil
    var defaultFont = UIFont.systemFont(ofSize: 14.0)
    
    static let paddingWithText:CGFloat = 18.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
    }
    
    init(dataSource: Array<Any>, property: String) {
        super.init(items: (dataSource as NSArray).value(forKey: property) as? [Any])
        self.calculateWithElement(array: dataSource, property: property)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupStyle() {
        self.backgroundColor = UIColor.white
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal,
                             rightSegmentState: .normal,
                             barMetrics: .default)
        
        self.setTitleTextAttributes([NSAttributedStringKey.font: defaultFont,
                                     NSAttributedStringKey.foregroundColor: UIColor.black.withAlphaComponent(0.5)],
                                    for: .normal)
        self.setTitleTextAttributes([NSAttributedStringKey.font: defaultFont,
                                     NSAttributedStringKey.foregroundColor: UIColor.black],
                                    for: .selected)
        self.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear,
                                                       height: 44.0,
                                                       lineHeight: 1.0), for: .normal,
                                                                         barMetrics: .default)
        self.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear,
                                                       height: 44.0,
                                                       lineHeight: 1.0),
                                for: .selected,
                                barMetrics: .default)
        self.addTarget(self,
                       action: #selector(self.indexChange(sender:)),
                       for: .valueChanged)
        
        self.selectedIndicator = UIView(frame: CGRect(x: 0.0,
                                                      y: self.bounds.size.height-1,
                                                      width: 1,
                                                      height: 1))
        self.selectedIndicator?.backgroundColor = UIColor.black
        self.addSubview(self.selectedIndicator!)
    }
    
    @objc private func indexChange(sender: PageSegment) {
        let model = dataSource[sender.selectedSegmentIndex]
        let newRect = CGRect(x: model.xPosition,
                             y: self.bounds.size.height - 3,
                             width: model.segmentSize,
                             height: 3)
        UIView.animate(withDuration: 0.15,
                       delay: 0.0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.selectedIndicator?.frame = newRect
                        if (self.onScrollView != nil) {
                            self.onScrollView?.scrollRectToVisible(newRect,
                                                                   animated: true)
                        }
        }, completion: nil)
    }
    
    public func setSelectedSegmentIndex(selectedSegmentIndex: Int, animation: Bool = false) {
        super.selectedSegmentIndex = selectedSegmentIndex
        let model = self.dataSource[selectedSegmentIndex]
        let newRect = CGRect(x: model.xPosition,
                             y: self.bounds.size.height - 3.0,
                             width: model.segmentSize,
                             height: 3.0)
        if (!animation) {
            self.selectedIndicator?.frame = newRect
        } else {
            UIView.animate(withDuration: 0.15,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            self.selectedIndicator?.frame = newRect
                            if (self.onScrollView != nil) {
                                self.onScrollView?.scrollRectToVisible(newRect,
                                                                       animated: true)
                            }
            }, completion: nil)
        }
    }
    
    override public var selectedSegmentIndex: Int {
        get {
            return super.selectedSegmentIndex
        }
        set {
            super.selectedSegmentIndex = newValue
            self.setSelectedSegmentIndex(selectedSegmentIndex: newValue)
        }
    }
    
    private func calculateWithElement(array: Array<Any>, property: String) {
        let font = defaultFont
        let arrayNS:NSArray = array as NSArray
        let stringsArray = (arrayNS.value(forKey: property) as? [String] as NSArray?)
        let totalString = stringsArray?.componentsJoined(by: "")
        let size: CGFloat = totalString!.size(withAttributes: [NSAttributedStringKey.font: font]).width
        
        
        let totalWidth:CGFloat = CGFloat(size + CGFloat((Int(ceilf(Float(2 * PageSegment.paddingWithText))) * self.numberOfSegments)))
        
        var tempArray = [SegmengModel]()
        
        if (totalWidth < UIScreen.main.bounds.size.width) {
            let width:CGFloat = UIScreen.main.bounds.size.width / CGFloat(self.numberOfSegments)
            var xPosition:CGFloat = 0.0
            for i in 0..<self.numberOfSegments {
                let model = SegmengModel()
                model.segmentSize = width
                model.xPosition = xPosition
                xPosition += width
                self.setWidth(width, forSegmentAt: i)
                tempArray.append(model)
            }
        } else {
            var xPosition:CGFloat = 0.0
            for i in 0..<self.numberOfSegments {
                let title: NSString = self.titleForSegment(at: i)! as NSString
                let size: CGFloat = title.size(withAttributes: [NSAttributedStringKey.font: font]).width
                var width:CGFloat = CGFloat(ceilf(Float(size)))
                width += 2.0 * PageSegment.paddingWithText
                let model = SegmengModel()
                model.segmentSize = width
                model.xPosition = xPosition
                xPosition += width
                self.setWidth(width, forSegmentAt: i)
                tempArray.append(model)
            }
        }
        self.dataSource = tempArray
    }
}
