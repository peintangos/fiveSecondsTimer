//
//  SettingViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/11.
//

import UIKit

let web = ["秒数の設定","名前の省略"]
let web2 = ["アイコンの設定","背景色の設定"]
let rule = ["ルールの設定","レイアウトの設定"]

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }else {
            return 2;
        }
    
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rule[section]
    }
    var switchS = UISwitch(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
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
        }else {
            cell.textLabel?.text = web2[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ChangeIcons") as ChangeIconsViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return rule.count
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .white
        self.switchS.addTarget(self, action: #selector(tappedSwitch), for: UIControl.Event.touchUpInside)
    }
    @objc func tappedSwitch(sender:UISwitch){
        print("33")
    }
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    var myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)

    override func viewDidLayoutSubviews() {
        myTableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.contentInset.top = 44 - self.view.safeAreaInsets.top
        self.view.bringSubviewToFront(self.switchS)
        self.view.addSubview(myTableView)
        self.view.sendSubviewToBack(myTableView)
        
        let navBar = UINavigationBar()

        //xとyで位置を、widthとheightで幅と高さを指定する
        navBar.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44)
        

        //ナビゲーションアイテムのタイトルを設定
        let navItem : UINavigationItem = UINavigationItem(title: "設定画面")

        //ナビゲーションバー右のボタンを設定
        navItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goBack))
        
        //ナビゲーションバーにアイテムを追加
        navBar.pushItem(navItem, animated: true)

        //Viewにナビゲーションバーを追加
        self.view.addSubview(navBar)
//        self.view.sendSubviewToBack(navBar)
//        navBar.backgroundColor = .orange
        
    }
}
