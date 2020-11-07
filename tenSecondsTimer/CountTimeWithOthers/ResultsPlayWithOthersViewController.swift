//
//  ResultsPlayWithOthersViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/10.
//

import UIKit
import RealmSwift


class ResultsPlayWithOthersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var tableCells: Results<EachRecord>!
    var myTableView:UITableView!
    var stopButton:UIButton?
//    var playerNumber:Int?
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNumberAll ?? 4
    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        例えばここをtableCells?にすると二重にOptionalがつくことになる。というかnameで強制アンラップしても返ってくる値はオプショナルになる。
//        下記に例を記
//        ① オプショナル2重
//        ② オプショナル1重
//        ③ オプショナル2重を2回の強制アンラップで解除
//
//        print(tableCells?[(indexPath as NSIndexPath).row])
//        print(tableCells?[(indexPath as NSIndexPath).row].name!)
//        print((tableCells?[(indexPath as NSIndexPath).row].name!)!)
        cell.textLabel?.text = "\((indexPath as NSIndexPath).row + 1)位\(tableCells![(indexPath as NSIndexPath).row].name!)"
        cell.detailTextLabel?.text = "タイム：\(tableCells![(indexPath as NSIndexPath).row].timerSecond!)\(tableCells![(indexPath as NSIndexPath).row].timerMill!) 解離：\(tableCells![(indexPath as NSIndexPath).row].timeDifference.description)"

        var randomNumber = Int.random(in: 1..<3)
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        switch indexPath.row{
        case playerNumberAll! - 2:
            if randomNumber >= 2{
                imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
                cell.accessoryView = imageView
            }
        case playerNumberAll! - 1:
            imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
            cell.accessoryView = imageView
        default:
            return cell
        }
        return cell
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        self.stopButton = makeStartTimer()
        self.view.addSubview(self.stopButton!)
        self.stopButton!.addTarget(self, action: #selector(end), for: UIControl.Event.touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView = UITableView(frame: view.frame,style: .grouped)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = UIColor.init(red: 3, green: 3, blue: 124, alpha: 0)
//        myTableView.backgroundColor = .black
        view.addSubview(myTableView)
        let realm = try! Realm()
        self.tableCells = realm.objects(EachRecord.self).sorted(byKeyPath: "timeDifference", ascending: true).filter("orderAll = \(orderAllNew!)")
        makeColorLayer()
//
    }
    func makeColorLayer(){
        var layer = CAGradientLayer()
        layer.frame = self.view.frame
        layer.colors = [UIColor.init(red: 205 / 250, green: 156 / 250, blue: 242 / 250, alpha: 1).cgColor,UIColor.init(red: 246 / 255, green: 243 / 255, blue: 255 / 255, alpha: 1).cgColor]
        layer.locations = [0.1,0.7]
        layer.startPoint = CGPoint(x: 0.3, y: 0)
        layer.endPoint = CGPoint(x: 0.2, y: 1)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height - 200 , width: 100, height: 100)
        startButton.backgroundColor = UIColor.white
        startButton.layer.cornerRadius = 50
        startButton.titleLabel?.text = "終わる"
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
    @objc func end(){
//        これだと途中までしかモーダルが閉じなかった。
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "結果発表"
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
