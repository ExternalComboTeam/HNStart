//
//  SearchMedicineViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/4.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchMedicineViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var array: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "自訂用藥".localized())
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
}
extension SearchMedicineViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MedicineAPI.search(key: searchBar.text ?? "") { (json) in
            self.array = json["data"].arrayValue
            self.tableView.reloadData()
        }
    }
}
extension SearchMedicineViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineCellCell
        cell.chName.text = "中文:" + self.array[indexPath.row]["name_c"].stringValue
        cell.enName.text = "English:" + self.array[indexPath.row]["name_e"].stringValue
        cell.inLabel.text = "成分:" + self.array[indexPath.row]["ingredient"].stringValue
        cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.4)
        return cell
    }
}
extension SearchMedicineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
