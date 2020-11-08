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
    var usernameTextField:UITextField!
    var passwordTextField:UITextField!
    var loginButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            self.usernameTextField = UITextField()
            self.usernameTextField.borderStyle = .roundedRect
            self.usernameTextField.keyboardType = .default
            self.usernameTextField.clearButtonMode = .whileEditing
            self.view.addSubview(self.usernameTextField)
        }
        do{
            self.passwordTextField = UITextField()
            self.passwordTextField.borderStyle = .roundedRect
            self.passwordTextField.keyboardType = .default
            self.usernameTextField.clearButtonMode = .whileEditing
            self.view.addSubview(self.passwordTextField)
        }
        do{
            self.loginButton = UIButton()
            self.loginButton.setTitle("login", for: .normal)
            self.loginButton.backgroundColor = .blue
            self.loginButton.rx.tap.subscribe{ [self](action) in
                self.saveUser()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(identifier: "ViewController")
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }.disposed(by: dispose)
            self.view.addSubview(self.loginButton)
        }
        self.usernameTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.userNamePublishSubject).disposed(by: dispose)
        self.passwordTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.passwordPublishSubject).disposed(by: dispose)
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: dispose)
        loginViewModel.isValid().map{$0 ? 1 : 0.1}.bind(to: loginButton.rx.alpha).disposed(by: dispose)
        UILabel().rx.text
        
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
        self.usernameTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.usernameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.usernameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300).isActive = true
        
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 450).isActive = true
        
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
