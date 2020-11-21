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
//        myTableView = UITableView(frame: view.frame,style: .grouped)
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 200), style: .grouped)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
//        myTableView.backgroundColor = .black
        view.addSubview(myTableView)
        let realm = try! Realm()
        self.tableCells = realm.objects(EachRecord.self).sorted(byKeyPath: "timeDifference", ascending: true).filter("orderAll = \(orderAllNew!)")
        makeColorLayer(number: backgroundColorNumberStatic)
//
    }
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.frame.height - 150 , width: 100, height: 100)
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
        switch playerNumberAll {
        case 2:
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 3:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 4:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 5:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 6:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 7:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 8:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 9:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case 10:
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        default:
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
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
