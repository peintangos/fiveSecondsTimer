//
//  SettingViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/11.
//

import UIKit
import RxCocoa
import RxSwift

let web = ["秒数の設定","名前の省略"]
let web2 = ["アイコン","輪っかの色","ボタンの文字の色","ボタンの文字の大きさ","ボタンの枠の色","ボタンの枠の幅","背景のグラデーションの設定"]
let rule = ["ルールの設定","レイアウトの設定","コンテンツ","初期設定"]
let web3 = ["飲み会モード","絆ルール","王様ルール"]

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return web2.count
        case 2:
            return web3.count
        case 3:
            return 1
        default:
//            適当
            return 4
        }

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rule[section]
    }
    var switchS = UISwitch(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var switchD = UISwitch(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var switchNomikaiMode = UISwitch(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        if indexPath.section == 0{
            if indexPath.row == 1 {
                cell.accessoryView = switchS
//                cell.backgroundColor = .lightGray
                switchS.frame.origin = CGPoint(x: cell.frame.width, y: (cell.frame.height - 31) / 2)
                cell.autoresizingMask = .flexibleHeight
                cell.addSubview(switchS)
                self.view.bringSubviewToFront(switchS)
            }else {
                cell.accessoryType = .disclosureIndicator
            }
            cell.textLabel?.text = web[indexPath.row]
        }else if indexPath.section == 1{
            cell.textLabel?.text = web2[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        }else if indexPath.section == 2 && indexPath.row == 0 {
//            名前省略の時には、訳わからない設定を入れているが、普通に下記のようにaccessoryViewに設定してあげればOK
            cell.accessoryView = switchNomikaiMode
            cell.textLabel?.text = web3[0]
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = web3[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        }else if indexPath.section == 3 {
            cell.textLabel?.text = "初期設定に戻す"
            cell.accessoryView = switchD
            switchD.frame.origin = CGPoint(x: cell.frame.width, y: (cell.frame.height - 31) / 2)
            cell.autoresizingMask = .flexibleHeight
            cell.addSubview(switchD)
            self.view.bringSubviewToFront(switchD)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            return
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            return
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ChangeIcons") as ChangeIconsViewController
        vc.modalPresentationStyle = .fullScreen
        let headerTitle:String!
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                headerTitle = "秒数の設定"
            case 1:
                headerTitle = "デフォルト"
            default:
                headerTitle = "デフォルト"
            }
        case 1:
            switch indexPath.row{
            case 0:
                headerTitle = "アイコンの設定"
            case 1:
                headerTitle = "輪っかの設定"
            case 2:
                headerTitle = "ボタンの文字の色の設定"
            case 3:
                headerTitle = "ボタンの文字の大きさの設定"
            case 4:
                headerTitle = "ボタン枠の色の設定"
            case 5:
                headerTitle = "ボタンの枠の幅の設定"
            case 6:
                headerTitle = "背景のグラデーションの設定"
            default:
                headerTitle = "デフォルト"
            }

        case 2:
            switch indexPath.row {
            case 0:
                headerTitle = "デフォルト"
            case 1:
                headerTitle = "絆ルール"
            case 2:
                headerTitle = "王様ルール"
            default:
                headerTitle = "デフォルト"
            }
        case 3:
            headerTitle = "初期設定に戻す"
        default:
            headerTitle = "デフォルト"
        }
        vc.sectionNumber = indexPath.section
        vc.rowNumber = indexPath.row
        vc.headerTitle = headerTitle
        self.present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return rule.count
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height)
//        self.view.backgroundColor = .white
        self.switchS.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
        self.switchD.addTarget(self, action: #selector(changeToDefaultSetting), for: UIControl.Event.valueChanged)
//        こいつを書かないと設定上オン/オフが切り替わっていたとしても、画面の表示が切り替わらない。
        self.switchS.isOn = UserDefaults.standard.bool(forKey: "isNameSaved")
        
        myTableView = UITableView(frame: CGRect(x: 0, y: safeAreaTopFirstView!, width: 0, height: 0), style: .grouped)
        self.view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
//        セーフエリアの色がナビゲーションの色と異なるため、Viewを追加
        let view = UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
//        以下がデフォルトのナビゲーションエリアの色らしい
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        self.view.addSubview(view)
        
        self.switchNomikaiMode.isOn = Setting.nomikaiMode.init(rawValue: UserDefaults.standard.integer(forKey: "nomikaiMode"))!.getBool()
        self.switchNomikaiMode.addTarget(self, action: #selector(changeSwitchNomikaiMode), for: UIControl.Event.valueChanged)
        
//        UISwitch →ViewModelへのバインドをする（他の設定値のバインディングについては、ChangeIconsViewController.swiftで行っている。
        switchS.rx.isOn.bind(to: settingViewModel.nameOmitVieModel).disposed(by: disposeBag)
//        switchNomikaiMode.rx.isOn.bind(to: settingViewModel.nomikaiModeViewModel).disposed(by: disposeBag)
        switchNomikaiMode.rx.isOn.map { $0 ? 1 : 0 }.bind(to: settingViewModel.nomikaiModeViewModel).disposed(by: disposeBag)
//        ViewModel→UIへのバインド
        settingViewModel.changed().bind(to: switchD.rx.isOn).disposed(by: disposeBag)
        
        switchD.rx.isOn.subscribe { isOn in
            if let value = isOn.element {
                timeNumberStatic = 5
                isSaved = false
                iconNumberStatic = 1
                colorNumberStatic = 3
                buttonTextColorNumberStatic = 3
                buttonTextSizeNumberStatic = 2
                buttonColorNumberStatic = 5
                buttonWidthNumberStatic = 1
                backgroundColorNumberStatic = 0
                nomikaiModeStatic = 1
                kizunaRuleNumberStatic = 1
                kingsRuleNumberStatic = 1
                
                let defaults = UserDefaults.standard
                defaults.set(timeNumberStatic,forKey: "timeNumber")
                defaults.set(false, forKey: "isNameSaved")
                defaults.set(iconNumberStatic, forKey: "iconNumber")
                defaults.set(colorNumberStatic, forKey: "circleColorNumber")
                defaults.set(buttonTextColorNumberStatic, forKey: "buttonTextColorNumber")
                defaults.set(buttonTextSizeNumberStatic, forKey: "buttonTextSizeNumber")
                defaults.set(buttonColorNumberStatic, forKey: "buttonWidthColorNumber")
                defaults.set(buttonWidthNumberStatic, forKey: "buttonWidthNumber")
                defaults.set(backgroundColorNumberStatic, forKey: "backgroundColorNumber")
                defaults.set(nomikaiModeStatic, forKey: "nomikaiMode")
                defaults.set(kizunaRuleNumberStatic, forKey: "kizuna")
                defaults.set(kingsRuleNumberStatic, forKey: "kings")
            }
                }.disposed(by: self.disposeBag)
        
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    var alert:UIAlertController!
    @objc func changeSwitchNomikaiMode(sender:UISwitch){
        let onCheck:Bool = sender.isOn
        let defo = UserDefaults.standard
        switch onCheck {
        case true:
            defo.setValue(1, forKey: "nomikaiMode")
            nomikaiModeStatic = 1
            alert = UIAlertController(title: "飲み会モードをオンにしました。\nお酒の飲み過ぎには注意してね！", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "はい", style: .default, handler: nil))
            present(alert, animated: true) {
                self.alert.view.superview?.isUserInteractionEnabled = true
                self.alert.view.superview?.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.close)))
            }
        case false:
            defo.setValue(0, forKey: "nomikaiMode")
            nomikaiModeStatic = 0
            alert = UIAlertController(title: "飲み会モードをオフにしました。", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "はい", style: .default, handler: nil))
            present(alert, animated: true) {
                self.alert.view.superview?.isUserInteractionEnabled = true
                self.alert.view.superview?.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.close)))
            }
        }
    }
    @objc func close(){
        alert.dismiss(animated: true, completion: nil)
        alert = nil
    }

    func makeColorLayer(number:Int,viewT:UIView){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = CGRect(x: 0, y: 0, width: viewT.frame.width, height: viewT.frame.height)
        viewT.layer.insertSublayer(layer!, at: 1)
    }

    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    var myTableView:UITableView!

    override func viewDidLayoutSubviews() {
        myTableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.contentInset.top = self.view.safeAreaInsets.top + 20
        self.view.bringSubviewToFront(self.switchS)
        self.view.addSubview(myTableView)
        self.view.sendSubviewToBack(myTableView)
        
        let navBar = UINavigationBar()

        //xとyで位置を、widthとheightで幅と高さを指定する
        navBar.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44)
//        navBar.backgroundColor = UIColor.red
        //ナビゲーションアイテムのタイトルを設定
        let navItem : UINavigationItem = UINavigationItem(title: "設定画面")

        //ナビゲーションバー右のボタンを設定
        navItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goBack))
        
        //ナビゲーションバーにアイテムを追加
        navBar.pushItem(navItem, animated: true)

        //Viewにナビゲーションバーを追加
        self.view.addSubview(navBar)
//        self.view.sendSubviewToBack(navBar)
//        navBar.backgroundColor = .orange
        
    }
    @objc func changeSwitch(sender:UISwitch){
        let onCheck:Bool = sender.isOn
        let userDefault = UserDefaults.standard
        if onCheck {
            let check = UIAlertController(title: "名前の省略設定をONにしました", message: nil, preferredStyle: .alert)
            check.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(check, animated: true, completion: nil)
            userDefault.set(true,forKey: "isNameSaved")
        }else {
            let check = UIAlertController(title: "名前の省略設定をOFFにしました", message: nil, preferredStyle: .alert)
            check.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            userDefault.set(false,forKey: "isNameSaved")
            self.present(check, animated: true, completion: nil)
        }
    }
    @objc func changeToDefaultSetting(sender:UISwitch){
//        ここひとつでも色が変更されていたら、OFFにするっていうやつしたい。Rx使えそう
//        sender.isOn = false
    }
}
