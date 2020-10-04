//
//  SecondController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
import RealmSwift

class SecondController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UITabBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        もし、全てを返したかったら、以下を返せば良い
//        return self.tableCells.count
        if section == 0{
            return 3
        }
        return self.tableCells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = tableCells[(indexPath as NSIndexPath).row].timeDifference.description
            cell.detailTextLabel?.text = self.moldTime(tableCells[(indexPath as NSIndexPath).row].date!)
            if tableCells[(indexPath as NSIndexPath).row].timeDifference <= 3 {
//                セルの背景色を変えたい場合は以下
//                cell.contentView.backgroundColor = UIColor.orange
                cell.textLabel?.textColor = UIColor.orange
            }
            return cell
        }
        else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = self.tableCellsHistory[(indexPath as NSIndexPath).row].name
            cell.detailTextLabel?.text = "\(self.moldTime(self.tableCellsHistory[(indexPath as NSIndexPath).row].date!))\(self.tableCellsHistory[(indexPath as NSIndexPath).row].timeDifference)"
            return cell
            
        }
    }
    func moldTime(_ time:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from:time)
    }
    var tableCells: Results<Record>!
    var tableCellsHistory: Results<Record>!
    var myTableView:UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.myTableView = UITableView(frame: view.frame,style: .grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
//        myTableView.backgroundColor = UIColor.init(red: 110/255, green: 119/255, blue: 124/255, alpha: 0)
        myTableView.backgroundColor = UIColor.init(red: 3, green: 3, blue: 124, alpha: 0)
        view.addSubview(myTableView)
        let realm = try! Realm()
        self.tableCells = realm.objects(Record.self).sorted(byKeyPath: "timeDifference", ascending: true)
        self.tableCellsHistory = realm.objects(Record.self).sorted(byKeyPath: "date",ascending: false)
    }

    func update(){
        if let newNum = self.myTableView {
            self.myTableView.reloadData()
        } else {
            print("newNumに値は設定されていません。")
        }
        
    }
    var titleList = ["ランキング","直近のスコア"]
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleList[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func viewWillAppear(_ animated: Bool) {
        self.update()
    }
//
    
    //    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//            //This method will be called when user changes tab.
//        let realm = try! Realm()
//        self.tableCells = realm.objects(Record.self)
//        print("33")
//        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
