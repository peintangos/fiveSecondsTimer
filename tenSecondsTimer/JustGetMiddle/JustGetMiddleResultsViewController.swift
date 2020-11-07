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
        nextView!.row = indexPath.row
        nextView!.section = indexPath.section
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
        tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 200)
//        self.tableView!.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.stopButton = makeStartTimer()
        self.stopButton!.addTarget(self, action: #selector(end), for: UIControl.Event.touchUpInside)
        self.view.addSubview(stopButton!)
        makeColorLayer()
    }
    func makeColorLayer(){
        var layer = CAGradientLayer()
        layer.frame = self.view.frame
        layer.colors = [UIColor.init(red: 252 / 250, green: 203 / 250, blue: 144 / 250, alpha: 1).cgColor,UIColor.init(red: 213 / 255, green: 126 / 255, blue: 235 / 255, alpha: 1).cgColor]
        layer.locations = [0.1,0.7]
        layer.startPoint = CGPoint(x: 0.3, y: 0)
        layer.endPoint = CGPoint(x: 0.2, y: 1)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    @objc private func onRefresh(_ sender: AnyObject) {
        self.tableView?.reloadData()
        self.tableView!.refreshControl?.endRefreshing()
        
    }
//    func makeStartTimer() -> UIButton{
//        do{
//            AutoLayoutを設定する場合は、fraeの大きさを決定しなくて良いが、AutoLayoutとimageの相性が悪いので、ここでは固定値として決定する
//            let uiButton = UIButton()
//            角を丸くする
//            uiButton.layer.cornerRadius = 40
//            UIButton()に画像を配置するには、これだけで良い
//            let image = UIImage(named: "back")
//            uiButton.setImage(image, for: .normal)
//            uiButton.backgroundColor = .white
//        }
//        位置はAutoLaoutで決定するので今は0 0 で良い
//        let stopButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        stopButton.backgroundColor = UIColor.white
//        let image = UIImage(named: "back")
//        let imageView = UIImageView(image: image)
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        imageView.layer.cornerRadius = 25
//        imageView.backgroundColor = .white
//        stopButton.addSubview(imageView)
//        return stopButton
//    }
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height - 180 , width: 100, height: 100)
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
//        これだと途中までしかモーダルが閉じなかった。
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
