//
//  CustomNavVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class CustomNavVC: UINavigationController {
    
    // MARK: - CustomNavVC lifecycle
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.setupStyle()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.setupStyle()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CustomNavVC interface setting
    private func setupStyle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
        self.navigationBar.backIndicatorImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysTemplate)
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysTemplate)
        self.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: .bold)]
        self.viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                                      style: .plain,
                                                                                      target: nil,
                                                                                      action: nil)
    }
    
    // MARK: - CustomNavVC override
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        for vc in viewControllers {
            vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                  style: .plain,
                                                                  target: nil,
                                                                  action: nil)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                          style: .plain,
                                                                          target: nil,
                                                                          action: nil)
    }
}
