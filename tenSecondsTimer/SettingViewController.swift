//
//  SettingViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/11.
//

import UIKit

class SettingViewController: UINavigationController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .orange
        super.viewDidLoad()
        self.setNavigationBar()
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
//        ここでyを0にすると少しずれてしまうので20を設定する
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: screenSize.height))
        let navItem = UINavigationItem(title: "設定画面")
        let doneItem = UIBarButtonItem(title: "完了", style: UIBarButtonItem.Style.done, target: nil, action: #selector(done))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    @objc func done() {
        self.dismiss(animated: true, completion: nil)
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
