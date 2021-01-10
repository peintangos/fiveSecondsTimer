//
//  ResultsPlayWithOthersViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/10.
//

import UIKit
import RealmSwift

var randomIntMiracleCount:Int?

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
        cell.detailTextLabel?.text = "タイム：\(tableCells![(indexPath as NSIndexPath).row].timerSecond!)\(tableCells![(indexPath as NSIndexPath).row].timerMill!) ポイント：\(tableCells![(indexPath as NSIndexPath).row].timeDifference.description)"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        if Setting.nomikaiMode.init(rawValue: nomikaiModeStatic)!.getBool() {
            if randomIntMiracleCount! >= (Setting.kings.init(rawValue: kingsRuleNumberStatic)?.getInt())! {
                if indexPath.row == 0 {
                    imageView.image = UIImage(named: "king")
                    cell.accessoryView = imageView
                    name = "王様：\(tableCells![(indexPath as NSIndexPath).row].name!)"
                    return cell
                }
                return cell
            }
            if randomIntMiracleCount! >= (Setting.kizuna.init(rawValue: kizunaRuleNumberStatic)?.getInt())! {
                imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
                cell.accessoryView = imageView
                nameList.append(tableCells![(indexPath as NSIndexPath).row].name!)
                return cell
            }            
        }

        let randomNumber = Int.random(in: 1..<3)
        
        switch indexPath.row{
        case playerNumberAll! - 2:
            if randomNumber >= 2{
                imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
                cell.accessoryView = imageView
                nameList.append(tableCells![(indexPath as NSIndexPath).row].name!)
            }
        case playerNumberAll! - 1:
            imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
            cell.accessoryView = imageView
            nameList.append(tableCells![(indexPath as NSIndexPath).row].name!)
        default:
            return cell
        }
        return cell
    }
    var nameList = Array<String>()
    var alert:UIAlertController!
    override func viewDidAppear(_ animated: Bool) {
        if Setting.nomikaiMode.init(rawValue: nomikaiModeStatic)!.getBool() {
            nameList.forEach { (nameElement) in
                name += nameElement + "さん\n"
                print(nameElement)
                print(name)
            }
            if randomIntMiracleCount! >= (Setting.kings.init(rawValue: kingsRuleNumberStatic)?.getInt())! {
                alert = UIAlertController(title: "👑王様タイム！\n王様は一緒に飲みたい人を指名できるよ！", message: name, preferredStyle: .alert)
                present(alert, animated: true, completion: {
                    self.alert.view.superview?.isUserInteractionEnabled = true
                    self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeAlert)))
                })
                return
            }
            if randomIntMiracleCount! >= (Setting.kizuna.init(rawValue: kizunaRuleNumberStatic)?.getInt())!{
                alert = UIAlertController(title: "絆タイム!\n全員で飲んで、絆を深める！", message: name, preferredStyle: .alert)
                present(alert, animated: true, completion: {
                    self.alert.view.superview?.isUserInteractionEnabled = true
                    self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeAlert)))
                })
                return
            }
            alert = UIAlertController(title: "飲み足りない人☆", message: name, preferredStyle: .alert)
            present(alert, animated: true, completion: {
                self.alert.view.superview?.isUserInteractionEnabled = true
                self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeAlert)))
            })
        }
        
    }
    @objc func closeAlert() {
            alert.dismiss(animated: true, completion: nil)
            alert = nil
        }
    var name = ""
    override func viewWillAppear(_ animated: Bool) {
        self.stopButton = makeStartTimer()
        self.view.addSubview(self.stopButton!)
        self.stopButton!.addTarget(self, action: #selector(end), for: UIControl.Event.touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        myTableView = UITableView(frame: view.frame,style: .grouped)
        randomIntMiracleCount = Int.random(in: 1..<10)
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
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.frame.height - 150 - safeAreaBottomFirstView!, width: 100, height: 100)
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
