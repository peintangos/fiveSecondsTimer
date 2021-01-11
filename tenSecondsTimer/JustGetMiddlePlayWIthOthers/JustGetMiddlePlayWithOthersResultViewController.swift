//
//  JustGetMiddlePlayWithOthersResultViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

var randomIntMiracle:Int?

class JustGetMiddlePlayWithOthersResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultRanking.count
    }
    var nameList = Array<String>()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(indexPath.row + 1)位 名前:\(resultRanking[indexPath.row].name) ポイント：\(resultRanking[indexPath.row].difference)"
        cell.detailTextLabel?.text = "日付:\(resultRanking[indexPath.row].date!)"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        if Setting.nomikaiMode.init(rawValue: nomikaiModeStatic)!.getBool(){
            if randomIntMiracle! >= (Setting.kings.init(rawValue: kingsRuleNumberStatic)?.getInt())! {
                if indexPath.row == 0 {
                    imageView.image = UIImage(named: "king")
                    cell.accessoryView = imageView
                    name = "王様：\(resultRanking[indexPath.row].name)"
                    return cell
                }
                return cell
            }
            if randomIntMiracle! >= (Setting.kizuna.init(rawValue: kizunaRuleNumberStatic)?.getInt())! {
                imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
                cell.accessoryView = imageView
                nameList.append(resultRanking[indexPath.row].name)
                return cell
            }
        }
        let randomNumber = Int.random(in: 1..<5)
        switch indexPath.row{
        case temporaryCount! - 3:
            if randomNumber >= 3{
                imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
                cell.accessoryView = imageView
                nameList.append(resultRanking[indexPath.row].name)
            }
        case temporaryCount! - 2:
            if randomNumber >= 2{
                imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
                cell.accessoryView = imageView
                nameList.append(resultRanking[indexPath.row].name)
            }
        case temporaryCount! - 1:
            imageView.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
            cell.accessoryView = imageView
            nameList.append(resultRanking[indexPath.row].name)
        default:
            return cell
        }
        return cell
    }
    var resultRanking:Results<JustGetMiddleResultsObject>!
    var stopButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        myTalbeView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped)
//        myTalbeView = UITableView(frame: view.frame,style: .grouped)
        myTalbeView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 200), style: .grouped)
        myTalbeView.delegate = self
        myTalbeView.dataSource = self
//        以下のように、tableViewのbackgroundcolorを透明にすることで、最下層にあるviewの背景色を見えるようにする
        myTalbeView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(myTalbeView!)
    
        let realm = try! Realm()
        self.resultRanking = realm.objects(JustGetMiddleResultsObject.self).sorted(byKeyPath: "difference", ascending: true).filter("numberForAGame = \(numberForAGame!)")
        self.stopButton = makeStartTimer()
        self.view.addSubview(self.stopButton!)
        self.stopButton?.rx.tap.subscribe({ _ in
            switch temporaryCount {
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
        }).disposed(by: dispose)
        makeColorLayer(number: backgroundColorNumberStatic)
        
        randomIntMiracle = Int.random(in: 1...10)
    
    }
    var alert:UIAlertController!
    override func viewDidAppear(_ animated: Bool) {
        if Setting.nomikaiMode.init(rawValue: nomikaiModeStatic)!.getBool(){
            nameList.forEach { (nameElement) in
                name += nameElement + "さん\n"
                print(nameElement)
                print(name)
            }
//            王様ルールでは、0→10,1→8,2→4に対応している。(1~10がランダムに出る。その中で各数字以上であればif文に引っかかる
            if randomIntMiracle! >= (Setting.kings.init(rawValue: kingsRuleNumberStatic)?.getInt())! {
                alert = UIAlertController(title: "👑王様タイム！\n王様は一緒に飲みたい人を指名できるよ！", message: name, preferredStyle: .alert)
                present(alert, animated: true, completion: {
                    self.alert.view.superview?.isUserInteractionEnabled = true
                    self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeAlert)))
                })
                return
            }
//            絆ルールでは、0→9,1→6,2→2に対応している。
            if randomIntMiracle! >= (Setting.kizuna.init(rawValue: kizunaRuleNumberStatic)?.getInt())!{
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
    var name = ""
    @objc func closeAlert() {
            alert.dismiss(animated: true, completion: nil)
            alert = nil
        }

    let dispose = DisposeBag()
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }
    @objc func goBack(){
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "結果発表"
    }
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.frame.height - 170 - safeAreaBottomFirstView!, width: 100, height: 100)
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
    var myTalbeView:UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
