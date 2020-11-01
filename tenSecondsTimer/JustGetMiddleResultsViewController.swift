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
    var justGetMiddleResultRanking: Results<JustGetMiddleResult>!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 3
        }else if (section == 1){
            return justGetMiddleResult.count ?? 0
        }
        return 3;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0{
            cell.textLabel?.text = "\(indexPath.row + 1)位 名前\(justGetMiddleResultRanking[(indexPath as NSIndexPath).row].name)　乖離率\(justGetMiddleResultRanking[(indexPath as NSIndexPath).row].difference)%"
        }else if indexPath.section == 1{
            cell.textLabel?.text = "\(justGetMiddleResult[(indexPath as NSIndexPath).row].date!) 乖離率\(justGetMiddleResult[(indexPath as NSIndexPath).row].difference)%"
        }
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
        if indexPath.section == 0{
            nextView?.justGetMiddleResult = self.justGetMiddleResultRanking[indexPath.row]
        }else if indexPath.section == 1{
            nextView?.justGetMiddleResult = self.justGetMiddleResult[indexPath.row]
        }
        present(nextView!, animated: true, completion: nil)
    }
    var stopButton:UIButton?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        let realm = try! Realm()
        self.justGetMiddleResultRanking = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "difference", ascending: true)
        self.justGetMiddleResult = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "dateNoMold", ascending: false)
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl!.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 200)
//        self.tableView!.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.stopButton = makeStartTimer()
        self.stopButton!.addTarget(self, action: #selector(end), for: UIControl.Event.touchUpInside)
        self.view.addSubview(stopButton!)
    }
    @objc private func onRefresh(_ sender: AnyObject) {
        self.tableView?.reloadData()
        self.tableView!.refreshControl?.endRefreshing()
        
    }
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        let wid = self.view.bounds.width/2 - 150
        let hei = self.view.bounds.height - 200
        startButton.frame = CGRect(x: wid, y:hei , width: 120, height: 120)
        startButton.titleLabel?.text = "終わる"
        let image = UIImage(named: "back")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: (self.view.bounds.width/2 - 150) / 2, y: (self.view.bounds.height/2 - 200) / 2 - 30, width: 60, height: 60)
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
//　　本当は、以下のようにしたかったができなくなったので、無理やり数字で合わせた
        startButton.addSubview(imageView)
        startButton.imageView?.contentMode = .scaleAspectFit
        startButton.contentHorizontalAlignment = .fill
        startButton.contentVerticalAlignment = .fill
        return startButton
    }
    @objc func refresh(){
        self.tableView?.reloadData()
    }
    override func viewWillLayoutSubviews() {
        let realm = try! Realm()
        self.justGetMiddleResultRanking = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "difference", ascending: true)
        self.justGetMiddleResult = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "dateNoMold", ascending: false)
    }
    @objc func end(){
//        これだと途中までしかモーダルが閉じなかった。
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 下から５件くらいになったらリフレッシュ
        guard tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-5, section: 0)) != nil else {
            return
        }
        // ここでリフレッシュのメソッドを呼ぶ
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
