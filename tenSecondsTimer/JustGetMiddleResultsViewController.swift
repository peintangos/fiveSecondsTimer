//
//  JustGetMiddleResultsViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/24.
//

/**
 ぴったしを狙う画面の結果発表のviewです
 */

import UIKit
import RealmSwift

class JustGetMiddleResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var justGetMiddleResult: Results<JustGetMiddleResult>!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 3
        }else if (section == 1){
            return 10;
        }
        return 3;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "乖離率\(justGetMiddleResult[(indexPath as NSIndexPath).row].difference) 名前\(justGetMiddleResult[(indexPath as NSIndexPath).row].name)"
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ランキング"
        }else if section == 1 {
            return "過去の履歴"
        }else {
            return "未定"
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyBoard.instantiateViewController(withIdentifier:"JustGetMiddleResultsDetailViewController") as? JustGetMiddleResultsDetailViewController
        
        present(nextView!, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        let realm = try! Realm()
        self.justGetMiddleResult = realm.objects(JustGetMiddleResult.self)
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl!.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    @objc private func onRefresh(_ sender: AnyObject) {
        self.tableView?.reloadData()
        self.tableView!.refreshControl?.endRefreshing()
        
    }
    @objc func refresh(){
        self.tableView?.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
