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
//            ここで、単純に3と書くとレコードが3個ない場合にクラッシュする。セクションの数は常に一定数担保されている必要がある。
            return justGetMiddleResult.count <= 3 ? justGetMiddleResult.count : 3
        }else if (section == 1){
            return justGetMiddleResult.count 
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
            cell.textLabel?.text = "\(indexPath.row + 1)位 名前\(justGetMiddleResultRanking[(indexPath as NSIndexPath).row].name) ポイント：\(justGetMiddleResultRanking[(indexPath as NSIndexPath).row].difference)%"
            if justGetMiddleIdStatic! == justGetMiddleResultRanking[(indexPath as NSIndexPath).row].id{
                cell.textLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
                cell.detailTextLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
            }
        }else if indexPath.section == 1{
            cell.textLabel?.text = "\(justGetMiddleResult[(indexPath as NSIndexPath).row].date!) ポイント：\(justGetMiddleResult[(indexPath as NSIndexPath).row].difference)%"
            if justGetMiddleIdStatic! == justGetMiddleResult[(indexPath as NSIndexPath).row].id{
                cell.textLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
                cell.detailTextLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
            }
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
        nextView?.modalPresentationStyle = .fullScreen
        nextView!.row = indexPath.row
        nextView!.section = indexPath.section
        if indexPath.section == 0{
            nextView?.justGetMiddleResult = self.justGetMiddleResultRanking[indexPath.row]
        }else if indexPath.section == 1{
            nextView?.justGetMiddleResult = self.justGetMiddleResult[indexPath.row]
        }
        present(nextView!, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    var stopButton:UIButton?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        下で上書きしているので、何の意味もない。
        tableView = UITableView(frame: CGRect(x: view.frame.origin.x, y: safeAreaTopFirstView!, width: view.frame.width, height: view.frame.height), style: UITableView.Style.grouped)
        tableView?.dataSource = self
        tableView?.delegate = self
//        なぜか意味不明だが、以下の文をつけることによって、layerのグラデーションが反映される
//        仮説だが、下のUIColorはred,green,blueを255でわり、正規化する必要があるが、それを行なっていないために色として生成されていない。
//        tableViewの背景色が色の生成に失敗した場合は、親のviewのバックグラウンドカラー(今回の場合だとlayer)に依存するという設定になっているではないだろうか
        tableView?.backgroundColor = UIColor.init(red: 3, green: 3, blue: 124, alpha: 0)
        self.view.addSubview(tableView!)
        let realm = try! Realm()
        self.justGetMiddleResultRanking = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "difference", ascending: true)
        self.justGetMiddleResult = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "dateNoMold", ascending: false)
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl!.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        tableView?.frame = CGRect(x: 0, y: safeAreaTopFirstView!, width: self.view.frame.width, height: self.view.frame.height - 250)
//        self.tableView!.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.stopButton = makeStartTimer()
        self.stopButton!.addTarget(self, action: #selector(end), for: UIControl.Event.touchUpInside)
        self.view.addSubview(stopButton!)
        makeColorLayer(number: backgroundColorNumberStatic)
    }
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }
    @objc private func onRefresh(_ sender: AnyObject) {
        self.tableView?.reloadData()
        self.tableView!.refreshControl?.endRefreshing()
        
    }

    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height - safeAreaBottomFirstView! - 100 , width: 100, height: 100)
        startButton.backgroundColor = UIColor.white
        startButton.layer.cornerRadius = 50
        let image = UIImage(named: "back")
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
//　　本当は、以下のようにしたかったができなくなったので、無理やり数字で合わせた
//        imageView.center = stopButton.center
        startButton.addSubview(imageView)
        startButton.imageView?.contentMode = .scaleAspectFit
        startButton.contentHorizontalAlignment = .fill
        startButton.contentVerticalAlignment = .fill
        return startButton
    }
//    func makeAutoLayout(){
//        self.stopButton?.translatesAutoresizingMaskIntoConstraints = false
//        self.stopButton?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
//        self.stopButton?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
//    }
//    override func viewDidLayoutSubviews() {
//        makeAutoLayout()
//    }
    @objc func refresh(){
        self.tableView?.reloadData()
    }
    override func viewWillLayoutSubviews() {
        let realm = try! Realm()
        self.justGetMiddleResultRanking = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "difference", ascending: true)
        self.justGetMiddleResult = realm.objects(JustGetMiddleResult.self).sorted(byKeyPath: "dateNoMold", ascending: false)
    }
    @objc func end(){
//        これだと途中までしかモーダルが閉じなかった
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//        self.presentedViewController?.dismiss(animated: true, completion: nil)
//        self.presentedViewController?.dismiss(animated: true, completion: nil)
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
//    以下のメソッドって何用に使ってたんだっけ、、、これがあるとクラッシュするから消す
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        // 下から５件くらいになったらリフレッシュ
//        guard tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-5, section: 0)) != nil else {
//            return
//        }
//        // ここでリフレッシュのメソッドを呼ぶ
//        self.tableView?.reloadData()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
