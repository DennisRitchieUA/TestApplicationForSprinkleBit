//
//  FilterVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

// MARK: - Protocol
@objc protocol SelectFilterDelegate {
    func didSelectFilter(selectedFiltersIDs: [Int]?)
}

class FilterVC: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private var dataSource = [Genre]()
    var selectedGenres = [Int]()
    weak var delegate: SelectFilterDelegate? = nil
    
    // MARK: - FilterVC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setupInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FilterVC load data
    private func loadData() {
        dataSource = Genre.mr_findAllSorted(by: "name", ascending: true) as! [Genre]
    }
    
    // MARK: - FilterVC interface setting
    private func setupInterface() {
        self.title = DPAutolocalizedString("FilterVC_title", nil)
        
        let doneBtn = UIBarButtonItem(title: DPAutolocalizedString("done_btn", nil),
                                      style: .done,
                                      target: self,
                                      action: #selector(self.doneAction))
        self.navigationItem.rightBarButtonItem = doneBtn
    }
    
    // MARK: - FilterVC actions
    @objc private func doneAction() {
        if let method = self.delegate?.didSelectFilter {
            method(selectedGenres.count > 0 ? selectedGenres : nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension FilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row].mr_inThreadContext()
        guard let genre_id = model?.genres_id?.intValue else { return }
        
        if let index = selectedGenres.index(where: {$0 == genre_id}) {
            selectedGenres.remove(at: index)
        } else {
            selectedGenres.append(genre_id)
        }
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - UITableViewDataSource
extension FilterVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell",
                                                 for: indexPath) as! FilterCell
        let model = dataSource[indexPath.row].mr_inThreadContext()
        cell.textLabel?.text = model?.name
        
        guard let genre_id = model?.genres_id?.intValue else {
            cell.accessoryType = .none
            return cell
        }
        
        if (selectedGenres.contains(genre_id)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
