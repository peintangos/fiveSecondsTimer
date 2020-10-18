//
//  ViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
//対戦ごとに一位になるID
var orderAllNew:Int?
var timeNumberStatic:Int = UserDefaults.standard.integer(forKey: "timeNumber")
var iconNumberStatic:Int = UserDefaults.standard.integer(forKey: "iconNumber")
var colorNumberStatic:Int = UserDefaults.standard.integer(forKey: "colorNumber")
var playerNumberAll:Int?
var isSaved:Bool?
class ViewController: UIViewController,UITextFieldDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isSaved = UserDefaults.standard.bool(forKey: "isNameSaved")
        print("viewdidload\(isSaved)")
    }
    
    
    var titleLabel = UILabel()
    @IBOutlet weak var playSelf: UIButton?
    @IBOutlet weak var playWithOthers: UIButton?
    var button:UIButton?

    var justGetMiddle:UIButton = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        settingTitle(view: titleLabel)
        makePlaySelf(playSelf: self.playSelf!)
        makePlayWithOthers(playWithOthers: self.playWithOthers!)
        print("viewDidAppear\(isSaved)")
        self.view.addSubview(self.titleLabel)
    }
    override func viewDidLayoutSubviews() {
        justGetMiddle(justGetMiddle: self.justGetMiddle)
        self.view.addSubview(self.justGetMiddle)
        makeAutoLayout(button: self.justGetMiddle, settingButton: self.button!)
    }
    override func viewWillAppear(_ animated: Bool) {
        isSaved = UserDefaults.standard.bool(forKey: "isNameSaved")
        print("viewWillAppear\(isSaved)")
        self.button = makeSettingButton()
        self.view.addSubview(self.button!)
        self.button!.addTarget(self,action:#selector(tapSetting),for: UIControl.Event.touchUpInside)
        self.button!.addTarget(self,action:#selector(tapSetting),for: UIControl.Event.touchUpInside)
        self.justGetMiddle.addTarget(self, action: #selector(getMiddle), for: UIControl.Event.touchUpInside)
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
    
    func makeAutoLayout(button:UIButton,settingButton:UIButton){
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200).isActive = true
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
    }
    
    func makePlaySelf(playSelf playself:UIButton){
        playself.backgroundColor = UIColor.white
        playself.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        playself.layer.borderWidth = 2.0
        playself.layer.borderColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        playself.layer.cornerRadius = 4.0
        playself.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        playself.frame = CGRect(x: self.view.bounds.size.width/2.0 - 150, y: self.view.bounds.size.height/2.0 - 50, width: 300, height: 50)
    }
    
    func makePlayWithOthers(playWithOthers playwithothers:UIButton){
        playwithothers.backgroundColor = UIColor.white
        playwithothers.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        playwithothers.layer.borderWidth = 2.0
        playwithothers.layer.borderColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        playwithothers.layer.cornerRadius = 4.0
        playwithothers.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        playwithothers.frame = CGRect(x: self.view.bounds.size.width/2.0 - 150, y: self.view.bounds.size.height/2.0 + 50, width: 300, height: 50)
    }
    func justGetMiddle(justGetMiddle:UIButton){
        justGetMiddle.center.x = self.view.center.x
        justGetMiddle.backgroundColor = UIColor.white
        justGetMiddle.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        justGetMiddle.layer.borderWidth = 2.0
        justGetMiddle.layer.borderColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        justGetMiddle.setTitle("ぴったし真ん中を狙う", for: .normal)
        justGetMiddle.setTitleColor(Setting.color.init(rawValue: colorNumberStatic)?.getUIColor(), for: .normal)
        justGetMiddle.titleLabel?.textColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        justGetMiddle.layer.cornerRadius = 4.0
        justGetMiddle.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        justGetMiddle.frame = CGRect(x: self.view.bounds.size.width/2.0 - 150, y: self.view.bounds.size.height/2.0 + 150, width: 300, height: 50)
//        justGetMiddle.frame.size = CGSize(width: 300, height: 50)
    }
    
    func settingButton (view viewA:UIButton){
        viewA.backgroundColor = UIColor.white
        viewA.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        viewA.layer.borderWidth = 2.0
        viewA.layer.borderColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        viewA.layer.cornerRadius = 4.0
        viewA.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func settingTitle (view viewA:UILabel){
        viewA.text = "\(timeNumberStatic)SecondsTimer"
        viewA.textAlignment = NSTextAlignment.center
        viewA.frame = CGRect(x:40,y:20,width: 300,height: 70)
        viewA.center = CGPoint(x: myBoundSize.width/2, y:150)
        viewA.font = UIFont.systemFont(ofSize: 20)
        viewA.textColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1)
        viewA.layer.borderWidth = 2.0
        viewA.layer.borderColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1).cgColor
        viewA.layer.cornerRadius = 4.0
    }
    
    @IBAction func tapOthers(_ sender: Any) {
        print("ボタンがタップされた時  \(isSaved)")
        let actionS = UIAlertController(title: "遊ぶ人数を選択してね", message: nil, preferredStyle: .actionSheet)
        actionS.addAction(UIAlertAction(title: "2人", style: .default, handler: { (action) in
            playerNumberAll = 2
            if isSaved!{
                playerNumberAll = 2
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                nextView.name = "player1"
//                nextView.playerNumber = 2
                self.present(nextView, animated: true, completion: nil)
                
            }else {
                let nav = UIAlertController(title: "一人目の名前を入力してね", message:nil, preferredStyle: .alert)
                nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
                    nextView.name = nav.textFields?[0].text!
//                    nextView.playerNumber = 2
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
            if isSaved!{
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
            if isSaved!{
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

