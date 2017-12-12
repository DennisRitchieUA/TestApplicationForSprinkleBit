//
//  MainVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

class MainVC: PageViewController {
    
    private lazy var listOfPopularVC : ListOfPopularVC = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListOfPopularVC") as! ListOfPopularVC
        vc.title = DPAutolocalizedString("main_vc_segmen_controll_first_item", nil)
        return vc
    }()
    
    private lazy var favoriteVC : FavoriteVC = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteVC
        vc.title = DPAutolocalizedString("main_vc_segmen_controll_second_item", nil)
        return vc
    }()
    
    // MARK: - ListOfPopularVC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.setupInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MainVC load data
    private func loadData() {
        self.segmentArray = [listOfPopularVC, favoriteVC]
        let filterBtn = UIBarButtonItem(image: UIImage(named: "filterIcon"), style: .plain, target: listOfPopularVC, action: #selector(listOfPopularVC.filterAction(_:)))
        self.navigationItem.rightBarButtonItem = filterBtn
    }
    
    // MARK: - MainVC interface setting
    private func setupInterface() {
        self.title = "TestApplicationForSprinkleBit"
        let searchBtn = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(self.searchAction(_:)))
        self.navigationItem.leftBarButtonItem = searchBtn
    }
    
    // MARK: - MainVC override
    override var currentIndex: Int {
        get {
            return super.currentIndex
        }
        set {
            super.currentIndex = newValue
            if (currentIndex == 0) {
                let filterBtn = UIBarButtonItem(image: UIImage(named: "filterIcon"), style: .plain, target: listOfPopularVC, action: #selector(listOfPopularVC.filterAction(_:)))
                self.navigationItem.rightBarButtonItem = filterBtn
            } else {
                let sortedBtn = UIBarButtonItem(image: UIImage(named: "sortedIcon"), style: .plain, target: favoriteVC, action: #selector(favoriteVC.sortedAction(_:)))
                self.navigationItem.rightBarButtonItem = sortedBtn
            }
        }
    }
    
    // MARK: - ListOfPopularVC actions
    @objc func searchAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

