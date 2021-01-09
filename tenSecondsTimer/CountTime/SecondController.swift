//
//  SecondController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

/**
 一人用のViewの結果画面です
 */

import UIKit
import RealmSwift

class SecondController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UITabBarDelegate{
    var recordId:Int?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        このテーブルのセクションの数には、少し考慮が必要
//        単に、tableCellsの個数を返すと、tableCellsの個数が3個未満の時にバグるので、3コマでは分岐する
        if section == 0{
            switch tableCells.count{
            case 0:
                return 0
            case 1:
                return 1
            case 2:
                return 2
            case 3:
                return 3
            default:
                return 3
            }
        }else if section == 1 {
            if tableCellsHistory.count == 0 {
                return 0
            }else {
                return tableCellsHistory.count
            }
        }else {
//            あり得ないと思うが
            return self.tableCells.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        StoryBoardを使わなくても画面遷移ができることを発見
        let vc = ThirdViewController()
        if indexPath.section == 0 {
            vc.tableCells = self.tableCells
            vc.section = 0
            vc.row = indexPath.row
        }else if indexPath.section == 1 {
            vc.tableCellsHistory = self.tableCellsHistory
            vc.section = 1
            vc.row = indexPath.row
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = "\((indexPath as NSIndexPath).row + 1)位 名前 \(tableCells[(indexPath as NSIndexPath).row].name!) 解離\(floor(tableCells[(indexPath as NSIndexPath).row].timeDifference * 10000) / 10000 )"
            cell.detailTextLabel?.text = "日付：\(self.moldTime(tableCells[(indexPath as NSIndexPath).row].date!))"
            if recordIdStatic == tableCells[(indexPath as NSIndexPath).row].id{
                cell.textLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
                cell.detailTextLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = "\(self.moldTime(self.tableCellsHistory[(indexPath as NSIndexPath).row].date!)) 解離\(floor(self.tableCellsHistory[(indexPath as NSIndexPath).row].timeDifference * 10000) / 10000)"
//            cell.detailTextLabel?.text = "名前\(self.tableCellsHistory[(indexPath as NSIndexPath).row].name!)"
            if recordIdStatic == tableCellsHistory[(indexPath as NSIndexPath).row].id{
                cell.textLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
                cell.detailTextLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
            }
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
    }
    func moldTime(_ time:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
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
        makeColorLayer(number: backgroundColorNumberStatic)
    }
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }

    func update(){
        if self.myTableView != nil {
            self.myTableView.reloadData()
        } else {
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
