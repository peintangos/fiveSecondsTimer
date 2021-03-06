//
//  ViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

/**
 初期画面
 */

import UIKit
import RxSwift
import RealmSwift
import RxCocoa
import AVFoundation
//対戦ごとに一位になるID
var orderAllNew:Int?
//秒数をUserDefaultsからとってきて格納する箱
var timeNumberStatic:Int = UserDefaults.standard.integer(forKey: "timeNumber")
var isSaved:Bool = UserDefaults.standard.bool(forKey: "isNameSaved")
//アイコンをUserDefaultsからとってきて格納する箱
var iconNumberStatic:Int = UserDefaults.standard.integer(forKey: "iconNumber")
//輪っかの色をUserDefaultsからとってきて格納する箱
var colorNumberStatic:Int = UserDefaults.standard.integer(forKey: "circleColorNumber")
//ボタンの文字の色をUserDefaultsからとってきて格納する箱
var buttonTextColorNumberStatic:Int = UserDefaults.standard.integer(forKey: "buttonTextColorNumber")
//ボタンの文字の大きさをUserDefaultsからとってきて格納する箱
var buttonTextSizeNumberStatic:Int = UserDefaults.standard.integer(forKey: "buttonTextSizeNumber")
//ボタンの枠色をUserDefaultsからとってきて格納する箱
var buttonColorNumberStatic:Int = UserDefaults.standard.integer(forKey: "buttonWidthColorNumber")
//ボタンの輪っかの幅をUserDefaultsからとってきて格納する箱
var buttonWidthNumberStatic:Int = UserDefaults.standard.integer(forKey: "buttonWidthNumber")
//背景色をUserDefaultsからとってきて格納する箱
var backgroundColorNumberStatic:Int = UserDefaults.standard.integer(forKey: "backgroundColorNumber")
//飲み会モードの設定
var nomikaiModeStatic:Int = UserDefaults.standard.integer(forKey: "nomikaiMode")
//絆ルールをUserDefaultsからとってきて保存する箱
var kizunaRuleNumberStatic:Int = UserDefaults.standard.integer(forKey: "kizuna")
//王様ルールをUserDefaultsからとってきて保存する箱
var kingsRuleNumberStatic:Int = UserDefaults.standard.integer(forKey: "kings")
//初回で入力したユーザ名をUserDefaultに登録
var name:String = UserDefaults.standard.string(forKey: "username")!
var playerNumberAll:Int?
//リストで取得する配列の数を表現
//var responseListLength = 10

//セーフエリアの高さ
var safeAreaTopFirstView:CGFloat?
var safeAreaBottomFirstView:CGFloat?

var temporaryCount:Int?

var settingViewModel:SettingViewModel!

class ViewController: UIViewController,UITextFieldDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.playSound(name: "work.mp3")
//        ユーザデフォルトから各種設定を読み込む（初回ダウンロードのみ初期設定がないため、registerしてある設定から読み込む
            
        do{
//            let storyBd = UIStoryboard(name: "Main", bundle: nil)
//            let tutorialVC = storyBd.instantiateViewController(withIdentifier: "ViewController")
//            self.view.window?.rootViewController = tutorialVC
        }
        do{
            settingViewModel = SettingViewModel()
        }
        do{
            let defaults = UserDefaults.standard
            defaults.register(defaults: ["timeNumber":5,
                                         "isNameSaved":false,
                                         "iconNumber":1,
                                         "circleColorNumber":3,
                                         "buttonTextColorNumber":3,
                                         "buttonTextSizeNumber":2,
                                         "buttonWidthColorNumber":5,
                                         "buttonWidthNumber":1,
                                         "backgroundColorNumber":0,
                                         "nomikaiMode":1,
                                         "kizuna":1,
                                         "kings":1
                                         ])
            timeNumberStatic = defaults.integer(forKey: "timeNumber")
            isSaved = defaults.bool(forKey: "isNameSaved")
            iconNumberStatic = defaults.integer(forKey: "iconNumber")
            colorNumberStatic = defaults.integer(forKey: "circleColorNumber")
            buttonTextColorNumberStatic = defaults.integer(forKey: "buttonTextColorNumber")
            buttonTextSizeNumberStatic = defaults.integer(forKey: "buttonTextSizeNumber")
            buttonColorNumberStatic = defaults.integer(forKey: "buttonWidthColorNumber")
            buttonWidthNumberStatic = defaults.integer(forKey: "buttonWidthNumber")
            backgroundColorNumberStatic = defaults.integer(forKey: "backgroundColorNumber")
            nomikaiModeStatic = defaults.integer(forKey: "nomikaiMode")
            kizunaRuleNumberStatic = defaults.integer(forKey: "kizuna")
            kingsRuleNumberStatic = defaults.integer(forKey: "kings")
            
        }

//        左上の設定ボタンを作り、viewに配置する。また、タップ時のイベントをサブスクライブする。
        do{
            self.worldButton = makeWorld()
            self.worldButton?.rx.tap.subscribe{[weak self] _ in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(identifier: "WorldScoreViewController")
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }.disposed(by: dispose)
        }
//        一番下のボタンを作り、viewに配置する。また、タップ時のイベントをサブスクライブする。
        do{
            self.justGetMiddlePlayWithOthers.rx.tap.subscribe{[weak self] _ in
                self?.makeAlertForJustGetMiddle()
            }.disposed(by: dispose)
        }
    }
    
    func makeAlertForJustGetMiddle(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
        vc.modalPresentationStyle = .fullScreen
        let ui = UIAlertController(title: "遊ぶ人数を選択してね", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        ui.addAction(UIAlertAction.init(title: "2人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 2
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "3人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 3
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "4人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 4
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "5人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 5
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "6人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 6
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "7人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 7
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "8人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 8
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "9人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 9
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "10人", style: .default, handler: { (UIAlertAction) in
            temporaryCount = 10
            if isSaved{
                self.present(vc, animated: true, completion: nil)
            }else {
                let nameInput = UIAlertController(title: "一人目の名前を入力してね", message: nil, preferredStyle: UIAlertController.Style.alert)
                nameInput.addTextField { (uiTextField) in
                    uiTextField.delegate = self
                }
                nameInput.addAction(type(of: UIAlertAction).init(title: "入力完了", style: .default, handler: { (action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(identifier: "JustGetMiddlePlayWithOthers1ViewController") as! JustGetMiddlePlayWithOthers1ViewController
                    nextView.name = nameInput.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }))
                self.present(nameInput, animated: true, completion: nil)
            }
        }))
        ui.addAction(UIAlertAction.init(title: "戻る", style: .cancel, handler: nil))
        self.present(ui, animated: true, completion: nil)
    }
    
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }
    
    @IBOutlet weak var playSelf: ButtonWithLayoutAutoShrink?
    @IBOutlet weak var playWithOthers: ButtonWithLayoutAutoShrink?
    let dispose = DisposeBag()
    var titleLabel = UILabel()
    var button:UIButton?
    var justGetMiddle:UIButton = ButtonWithLayoutAutoShrink()
    var worldButton:UIButton?
    var justGetMiddlePlayWithOthers = ButtonWithLayoutAutoShrink()
    
    override func viewDidAppear(_ animated: Bool) {
        settingTitle(view: titleLabel)
        self.view.addSubview(self.titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        makePlaySelf(playSelf: self.playSelf!)
        makePlayWithOthers(playWithOthers: self.playWithOthers!)
        justGetMiddle(justGetMiddle: self.justGetMiddle)
        makeJustGetMiddlePlayWidthOthers()
        self.view.addSubview(self.justGetMiddle)
        self.view.addSubview(self.worldButton!)
        self.view.addSubview(self.justGetMiddlePlayWithOthers)
        makeAutoLayout(button: self.justGetMiddle, settingButton: self.button!,worldButton: self.worldButton!)
        
        if safeAreaTopFirstView == nil {
            safeAreaTopFirstView = self.view.safeAreaInsets.top
        }
        if safeAreaBottomFirstView == nil {
            safeAreaBottomFirstView = self.view.safeAreaInsets.bottom
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        settingUpdate()
        isSaved = UserDefaults.standard.bool(forKey: "isNameSaved")
        self.button = makeSettingButton()
        self.view.addSubview(self.button!)
        self.button!.addTarget(self,action:#selector(tapSetting),for: UIControl.Event.touchUpInside)
        self.button!.addTarget(self,action:#selector(tapSetting),for: UIControl.Event.touchUpInside)
        self.justGetMiddle.addTarget(self, action: #selector(getMiddle), for: UIControl.Event.touchUpInside)
        makeColorLayer(number: backgroundColorNumberStatic)
    }

    
    @objc func tapSetting(){
        let nextView = storyboard!.instantiateViewController(withIdentifier: "SettingViewController") as! UINavigationController//遷移先のViewControllerを設定
        self.navigationController?.pushViewController(nextView, animated: true)//遷移する
        let second = SettingViewController()
        second.modalPresentationStyle = .fullScreen
        self.present(second, animated: true, completion: nil)
    }
    @objc func getMiddle(){
        let nextView = storyboard!.instantiateViewController(identifier: "JustGetMiddle")
        self.present(nextView, animated: true, completion: nil)
    }
    
    func makeSettingButton() -> UIButton{
        let button = UIButton()
        button.frame.size = CGSize(width: 20, height: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named:"setting2")
        imageView.frame.size = CGSize(width: 30, height: 30)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addSubview(imageView)
        return button
    }
    func makeWorld() ->UIButton{
        let button = UIButton(frame: CGRect(x: 0, y:0, width: 30, height: 30))
        button.setImage(UIImage(named: "world"), for: .normal)
        return button
    }
    
    func makeAutoLayout(button:UIButton,settingButton:UIButton,worldButton:UIButton){
        let height = self.view.safeAreaInsets.top
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200).isActive = true
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10 + height).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        
        worldButton.translatesAutoresizingMaskIntoConstraints = false
        worldButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10 + height).isActive = true
        worldButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        worldButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        worldButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CGFloat(30)).isActive = true
    }
    
    func makePlaySelf(playSelf playself:UIButton){
        playself.backgroundColor = UIColor.white
        playself.setTitle("ストップウォッチで遊ぶ（一人で）", for: .normal)
        playself.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 2)
        playself.titleLabel?.adjustsFontSizeToFitWidth = true
        playself.tintColor = Setting.color.init(rawValue: buttonTextColorNumberStatic)?.getUIColor()
        playself.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        playself.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        playself.layer.cornerRadius = 4.0
        playself.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat((Setting.fontSize.init(rawValue: buttonTextSizeNumberStatic)?.getSize())!))
        playself.frame = CGRect(x: self.view.bounds.size.width/2.0 - 175, y: self.view.bounds.size.height/2.0 - 50, width: 350, height: 60)
    }
    
    func makePlayWithOthers(playWithOthers playwithothers:UIButton){
        playwithothers.backgroundColor = UIColor.white
        playwithothers.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 2)
        if Setting.nomikaiMode.init(rawValue: nomikaiModeStatic)!.getBool(){
            playwithothers.setTitle("飲みたい人はだ〜れだ？", for: .normal)
        }else {
            playwithothers.setTitle("ストップウォッチで遊ぶ（みんなで）", for: .normal)
            playwithothers.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        playwithothers.tintColor = Setting.color.init(rawValue: buttonTextColorNumberStatic)?.getUIColor()
        playwithothers.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        playwithothers.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        playwithothers.layer.cornerRadius = 4.0
        playwithothers.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat((Setting.fontSize.init(rawValue: buttonTextSizeNumberStatic)?.getSize())!))
        playwithothers.frame = CGRect(x: self.view.bounds.size.width/2.0 - 175, y: self.view.bounds.size.height/2.0 + 50, width: 350, height: 60)
    }
    func justGetMiddle(justGetMiddle:UIButton){
        justGetMiddle.center.x = self.view.center.x
        justGetMiddle.backgroundColor = UIColor.white
        justGetMiddle.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        justGetMiddle.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        justGetMiddle.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat((Setting.fontSize.init(rawValue: buttonTextSizeNumberStatic)?.getSize())!))
        justGetMiddle.setTitle("反射神経で遊ぶ（一人で）", for: .normal)
        justGetMiddle.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 2)
//        cornerRadiusを使用するときは以下のclipToBoundsも一緒に使わないと枠からはみ出た部分が表示されてしまう
        justGetMiddle.clipsToBounds = true
        justGetMiddle.setTitleColor(Setting.color.init(rawValue: buttonTextColorNumberStatic)?.getUIColor(), for: .normal)
        justGetMiddle.layer.cornerRadius = 4.0
        justGetMiddle.frame = CGRect(x: self.view.bounds.size.width/2.0 - 175, y: self.view.bounds.size.height/2.0 + 150, width: 350, height: 60)
    }
    func makeJustGetMiddlePlayWidthOthers(){
        self.justGetMiddlePlayWithOthers.center.x = self.view.center.x
        self.justGetMiddlePlayWithOthers.backgroundColor = UIColor.white
        self.justGetMiddlePlayWithOthers.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        self.justGetMiddlePlayWithOthers.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        self.justGetMiddlePlayWithOthers.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat((Setting.fontSize.init(rawValue: buttonTextSizeNumberStatic)?.getSize())!))
        if Setting.nomikaiMode.init(rawValue: nomikaiModeStatic)!.getBool(){
            self.justGetMiddlePlayWithOthers.setTitle("飲みたい人はだ〜れだ？？？", for: .normal)
        }else {
            self.justGetMiddlePlayWithOthers.setTitle("反射神経で遊ぶ（みんなで）", for: .normal)
        }
//        cornerRadiusを使用するときは以下のclipToBoundsも一緒に使わないと枠からはみ出た部分が表示されてしまう
        justGetMiddlePlayWithOthers.clipsToBounds = true
        justGetMiddlePlayWithOthers.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 2)
        self.justGetMiddlePlayWithOthers.setTitleColor(Setting.color.init(rawValue: buttonTextColorNumberStatic)?.getUIColor(), for: .normal)
        self.justGetMiddlePlayWithOthers.layer.cornerRadius = 4.0
        self.justGetMiddlePlayWithOthers.frame = CGRect(x: self.view.bounds.size.width/2.0 - 175, y: self.view.bounds.size.height/2.0 + 250, width: 350, height: 60)
    }
//    無理やり過ぎてやりたくはないが、Rxの関係で、viewWillAppeaerの前でもう一度代入すると動かなくなるので、設定だけ更新する
    func settingUpdate(){
        self.justGetMiddlePlayWithOthers.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        self.justGetMiddlePlayWithOthers.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        self.justGetMiddlePlayWithOthers.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat((Setting.fontSize.init(rawValue: buttonTextSizeNumberStatic)?.getSize())!))
        self.justGetMiddlePlayWithOthers.setTitleColor(Setting.color.init(rawValue: buttonTextColorNumberStatic)?.getUIColor(), for: .normal)
    }
    
    func settingButton (view viewA:UIButton){
        viewA.backgroundColor = UIColor.white
        viewA.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        viewA.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        viewA.layer.borderColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        viewA.layer.cornerRadius = 4.0
        viewA.titleLabel?.font = UIFont.systemFont(ofSize: 50)
    }
    
    func settingTitle (view viewA:UILabel){
        viewA.text = "\(timeNumberStatic) Seconds Timer"
        viewA.textAlignment = NSTextAlignment.center
        viewA.frame = CGRect(x:40,y:Int(self.view.frame.height) / 3 + Int(self.view.safeAreaInsets.top) ,width:350,height: 70)
        viewA.center = CGPoint(x: myBoundSize.width/2, y:150)
        viewA.font = UIFont.systemFont(ofSize: 20)
        viewA.textColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1)
        viewA.layer.borderWidth = 2.0
        viewA.layer.borderColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1).cgColor
        viewA.layer.cornerRadius = 4.0
    }
    
    @IBAction func tapOthers(_ sender: Any) {
        let actionS = UIAlertController(title: "遊ぶ人数を選択してね", message: nil, preferredStyle: .actionSheet)
        actionS.addAction(UIAlertAction(title: "2人", style: .default, handler: { (action) in
            playerNumberAll = 2
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
                nextView.modalPresentationStyle = .fullScreen
//                nextView.playerNumber = 2
                self.present(nextView, animated: true, completion: nil)
                
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 2
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
            }
        }
        )
        
        )
        
        actionS.addAction(UIAlertAction(title: "3人", style: .default, handler: {(action) in
            playerNumberAll = 3
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 3
                self.present(nextView, animated: true, completion: nil)
                
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 3
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }
        }))
        actionS.addAction(UIAlertAction(title: "4人", style: .default, handler: {(action) in
            playerNumberAll = 4
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
                nextView.modalPresentationStyle = .fullScreen
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
                    nextView.modalPresentationStyle = .fullScreen
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "5人", style: .default, handler: {(action) in
            playerNumberAll = 5
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "6人", style: .default, handler: {(action) in
            playerNumberAll = 6
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "7人", style: .default, handler: {(action) in
            playerNumberAll = 7
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "8人", style: .default, handler: {(action) in
            playerNumberAll = 8
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "9人", style: .default, handler: {(action) in
            playerNumberAll = 9
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "10人", style: .default, handler: {(action) in
            playerNumberAll = 10
            if isSaved{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 4
                self.present(nextView, animated: true, completion: nil)
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 4
                    self.present(nextView, animated: true, completion: nil)
                    
                }))
                nav.addTextField(configurationHandler: {(textField) in
                    textField.delegate = self
                })
                nav.addAction(UIAlertAction(title: "戻る", style:UIAlertAction.Style.cancel, handler: nil))
                self.present(nav, animated: true, completion: nil)
                
            }

            
        }))
        actionS.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: nil))
        self.present(actionS, animated: true, completion: nil)

    }


    
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        do {
            let path = Bundle.main.bundleURL.appendingPathComponent(name)
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
            // 音声の再生
            print("a")
            audioPlayer.play()
        } catch {
            print("b")
        }
    }
}

    var audioPlayer:AVAudioPlayer!

