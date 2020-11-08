//
//  FirstLauchingViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/03.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class FirstLauchingViewController: UIViewController {
    let loginViewModel = LoginViewModel()
    let dispose = DisposeBag()
    var mainView:UIView!
    var usernameTextField:UITextField!
    var passwordTextField:UITextField!
    var label:UILabel!
    var loginButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeColorLayer(number: 0,view: self.view)
        do{
            self.usernameTextField = UITextField()
            self.usernameTextField.borderStyle = .roundedRect
            self.usernameTextField.keyboardType = .default
            self.usernameTextField.clearButtonMode = .whileEditing
            self.usernameTextField.placeholder = "Username"
//            親Viewのwidthは、55右にずらす。これは、子のimageViewでずらしてもそのズレをtextFieldは認識しない。
//            そこで、textFieldに対して親の55だけスペースがあることを認識させる
            let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 25))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
            imageView.image = UIImage(named: "user")
            uiView.addSubview(imageView)
            usernameTextField.leftView = uiView
            self.usernameTextField.leftViewMode = .always
            self.view.addSubview(self.usernameTextField)
        }
        do{
//            AutoLayoutを使用するために、frameは設定しない
            self.mainView = UIView()
//            AutoLayoutで、width/heightを130に設定している.真丸にするために65
            self.mainView.layer.cornerRadius = 65
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
            imageView.image = UIImage(named: "use")
//            clipsToBoundsをtrueにすることで、子VIewを超えておおきくなった場合に切り取ってくれる
            mainView.clipsToBounds = true
//            mainView.layer.borderColor = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 94 / 255, alpha: 1).cgColor
//            mainView.layer.borderWidth = 1
            mainView.addSubview(imageView)
            self.view.addSubview(mainView)
            imageView.contentMode = .scaleAspectFit
        }
        do{
            self.passwordTextField = UITextField()
            self.passwordTextField.borderStyle = .roundedRect
            self.passwordTextField.keyboardType = .default
            self.passwordTextField.clearButtonMode = .whileEditing
            self.passwordTextField.placeholder = "Password"
            let uiLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 25))
            let uiLeftViewImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
            uiLeftViewImage.image = UIImage(named: "password")
            uiLeftView.addSubview(uiLeftViewImage)
            passwordTextField.leftView = uiLeftView
            passwordTextField.leftViewMode = .always
            self.view.addSubview(self.passwordTextField)
        }
        do{
            self.loginButton = UIButton()
            self.loginButton.setTitle("SIGN IN", for: .normal)
            self.loginButton.backgroundColor = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 94 / 255, alpha: 1)
            self.loginButton.setTitleColor(UIColor.white, for: .normal)
            self.loginButton.rx.tap.subscribe{ [self](action) in
                self.saveUser()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(identifier: "ViewController")
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }.disposed(by: dispose)
            self.view.addSubview(self.loginButton)
        }
        do{
            self.label = UILabel()
            self.label.text = "Welcome to TenSecondsTimer"
            self.label.textColor = UIColor.white
            self.label.font = UIFont.systemFont(ofSize: 20)
            self.label.textAlignment = NSTextAlignment.center
            self.view.addSubview(label)
        }
        self.usernameTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.userNamePublishSubject).disposed(by: dispose)
        self.passwordTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.passwordPublishSubject).disposed(by: dispose)
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: dispose)
        loginViewModel.isValid().map{$0 ? 1 : 0.5}.bind(to: loginButton.rx.alpha).disposed(by: dispose)        
    }
    func makeColorLayer(number:Int,view:UIView){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        view.layer.insertSublayer(layer!, at: 0)
    }
//    初回のみ名前とパスワードを登録する。
    func saveUser(){
        UserDefaults.standard.setValue(self.usernameTextField.text!, forKey: "username")
        let parameters:[String:String] = [
        "username":self.usernameTextField.text!,
        "password":self.passwordTextField.text!
        ]
        Alamofire.request("http://localhost:8080/user/register",method:.post,parameters:parameters,encoding:JSONEncoding.default).responseJSON{
            response in
            switch response.result{
            case .success:
                print("通信に成功しました")
            case .failure:
                print("通信に失敗しました")
            }
        }
    }
    override func viewDidLayoutSubviews() {
     makeAutoLayout()
    }
    func makeAutoLayout(){
        self.usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.usernameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.usernameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.usernameTextField.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10).isActive = true
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 90).isActive = true
        
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 200).isActive = true
        
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.mainView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.mainView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.mainView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -160).isActive = true
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.label.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -250).isActive = true
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
