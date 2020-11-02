//
//  TenSecondsTimeViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import UIKit

class TenSecondsTimeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        self.view.backgroundColor = .blue
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(self.tableView!)
    }
    var tableView:UITableView?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 10
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "あなたの秒当て順位"
        case 1:
            return "全世界の秒当てランキング"
        default:
            return ""
        }
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
