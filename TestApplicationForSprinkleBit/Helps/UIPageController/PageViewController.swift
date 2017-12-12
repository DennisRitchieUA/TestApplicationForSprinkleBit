//
//  PageViewController.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var segmentArray = [UIViewController]() {
        didSet {
            self.setupSegment()
        }
    }
    
    var haveSearchField = false {
        didSet {
            if (scrollView != nil) {
                var rect = scrollView!.frame
                rect.origin.y = 44.0
                scrollView!.frame = rect
            }
        }
    }
    var scrollView: UIScrollView?
    var segmentControl: PageSegment?
    var pageController: UIPageViewController?
    var currentIndex: Int = 0
    var haveSearchView = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSegment() {
        scrollView?.removeFromSuperview()
        
        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: haveSearchField ? 44.0 : 0.0, width: view.frame.size.width, height: 44.0))
        
        segmentControl = PageSegment(dataSource: segmentArray, property: "title")
        segmentControl?.setNeedsLayout()
        segmentControl?.layoutIfNeeded()
        //тут сменить цвет скролл вью
        scrollView?.backgroundColor = UIColor.black
        scrollView?.bounces = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        segmentControl?.translatesAutoresizingMaskIntoConstraints = false
        segmentControl?.onScrollView = scrollView
        segmentControl?.selectedSegmentIndex = 0
        scrollView?.addSubview(segmentControl!)
        view.addSubview(scrollView!)
        
        let views: [String: UIView] = ["segmentControl": segmentControl!]
        scrollView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[segmentControl]-0-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: views))
        scrollView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[segmentControl]-0-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: views))
        self.scrollView?.layoutIfNeeded()
        
        if (self.segmentArray.count > 0) {
            self.segmentControl!.addTarget(self, action: #selector(indexChange(sender:)), for: .valueChanged)
            self.pageController = UIPageViewController(transitionStyle: .scroll,
                                                       navigationOrientation: .horizontal,
                                                       options: nil)
            let  topPadding = self.scrollView!.frame.origin.y + self.scrollView!.frame.size.height
            self.pageController?.view.frame = CGRect(x: 0.0,
                                                     y: topPadding + (haveSearchView ? 44.0 : 0.0),
                                                     width: self.view.frame.size.width,
                                                     height: self.view.frame.size.height - topPadding)
            self.pageController?.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.pageController?.delegate = self
            self.pageController?.dataSource = self
            self.addChildViewController(self.pageController!)
            self.view.addSubview(self.pageController!.view)
            self.pageController?.didMove(toParentViewController: self)
            self.pageController?.setViewControllers([self.segmentArray[self.currentIndex]], direction: .forward, animated: false, completion: nil)
            self.segmentControl?.selectedSegmentIndex = self.currentIndex
            
            for view in self.pageController!.view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = false
                }
            }
        }
    }
    
    @objc private func indexChange(sender: PageSegment) {
        
        var direction:UIPageViewControllerNavigationDirection
        
        if (self.currentIndex < sender.selectedSegmentIndex) {
            direction = .forward
        } else {
            direction = .reverse
        }
        self.currentIndex = sender.selectedSegmentIndex
        self.pageController?.setViewControllers([self.segmentArray[self.currentIndex]], direction: direction, animated: true)
    }
    
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let indexBeforeController = self.segmentArray.index(of: viewController)! - 1
        
        if (indexBeforeController < self.segmentArray.count && indexBeforeController >= 0) {
            return self.segmentArray[indexBeforeController]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let indexNextController  = self.segmentArray.index(of: viewController)! + 1
        if (indexNextController < self.segmentArray.count) {
            return self.segmentArray[indexNextController]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let indexController = self.segmentArray.index(of: pendingViewControllers.first!)!
        if (indexController < self.segmentArray.count) {
            self.currentIndex = indexController
            self.segmentControl?.setSelectedSegmentIndex(selectedSegmentIndex: indexController, animation: true)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) {
            let indexController = self.segmentArray.index(of: previousViewControllers.first!)!
            if (indexController < self.segmentArray.count) {
                self.currentIndex = indexController
                self.segmentControl?.setSelectedSegmentIndex(selectedSegmentIndex: indexController, animation: true)
            }
        }
    }
    
}
