//
//  ViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
//対戦ごとに一位になるID
var orderAllNew:Int?
class ViewController: UIViewController,UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var titleLabel = UILabel()
    @IBOutlet weak var playSelf: UIButton?
    @IBOutlet weak var playWithOthers: UIButton?
    var button:UIButton?
    
    override func viewDidAppear(_ animated: Bool) {
        settingTitle(view: titleLabel)
        makePlaySelf(playSelf: self.playSelf!)
        makePlayWithOthers(playWithOthers: self.playWithOthers!)
        self.view.addSubview(self.titleLabel)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.button = makeSettingButton()
        self.view.addSubview(self.button!)
        self.button!.addTarget(self,action:#selector(tapSetting),for: UIControl.Event.touchUpInside)
        self.button!.addTarget(self,action:#selector(tapSetting),for: UIControl.Event.touchUpInside)
    }

    
    @objc func tapSetting(){
        print("ff")
//        let nextVC = storyboard?.instantiateViewController(identifier: "SettingViewController")
//        self.navigationController?.pushViewController(nextVC!, animated: true)
        
//        let nextView = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! UINavigationController
//        self.navigationController?.pushViewController(nextView, animated: true)
//           let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)//遷移先のStoryboardを設定
        let nextView = storyboard!.instantiateViewController(withIdentifier: "SettingViewController") as! UINavigationController//遷移先のViewControllerを設定
           self.navigationController?.pushViewController(nextView, animated: true)//遷移する
        let second = SettingViewController()
        second.modalPresentationStyle = .fullScreen
        self.present(second, animated: true, completion: nil)
//        self.navigationController?.pushViewController(second, animated: true)
//        let objVC: SettingViewController? = (storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController)
//        let navi = UINavigationController(rootViewController: objVC!)
//        self.navigationController?.pushViewController(navi, animated: true)
        
    }
    
    func makeSettingButton() -> UIButton{
        let button = UIButton()
        button.frame = CGRect(x: self.view.bounds.size.width - 100, y: self.view.bounds.size.height - 100 , width: 30, height: 30)
        let imageView = UIImageView()
        imageView.image = UIImage(named:"setting")
        imageView.frame.size = CGSize(width: 30, height: 30)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
//        button.backgroundColor = .orange
        button.addSubview(imageView)
        return button
    }
    
    func makePlaySelf(playSelf playself:UIButton){
        playself.backgroundColor = UIColor.white
        playself.tintColor = UIColor.orange
        playself.layer.borderWidth = 2.0
        playself.layer.borderColor = UIColor.orange.cgColor
        playself.layer.cornerRadius = 4.0
        playself.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        playself.frame = CGRect(x: self.view.bounds.size.width/2.0 - 150, y: self.view.bounds.size.height/2.0 - 50, width: 300, height: 50)
    }
    
    func makePlayWithOthers(playWithOthers playwithothers:UIButton){
        playwithothers.backgroundColor = UIColor.white
        playwithothers.tintColor = UIColor.orange
        playwithothers.layer.borderWidth = 2.0
        playwithothers.layer.borderColor = UIColor.orange.cgColor
        playwithothers.layer.cornerRadius = 4.0
        playwithothers.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        playwithothers.frame = CGRect(x: self.view.bounds.size.width/2.0 - 150, y: self.view.bounds.size.height/2.0 + 50, width: 300, height: 50)
    }
    
    func settingButton (view viewA:UIButton){
        viewA.backgroundColor = UIColor.white
        viewA.tintColor = UIColor.orange
        viewA.layer.borderWidth = 2.0
        viewA.layer.borderColor = UIColor.orange.cgColor
        viewA.layer.cornerRadius = 4.0
        viewA.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func settingTitle (view viewA:UILabel){
        viewA.text = "5SecondsTimer"
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
        //        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //        alert.title = "遊ぶ人数を入力してね"
        //        alert.addTextField{
        //            (textField) -> Void in
        //            textField.keyboardType = .numberPad
        //            textField.delegate = self
        //        }
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
        //            print("3")
        //        }))
        //        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
//        牡蠣では
        print("3")
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "Player1ViewController") as! Player1ViewController
        present(nextView, animated: true, completion: nil)
    }
    
}

