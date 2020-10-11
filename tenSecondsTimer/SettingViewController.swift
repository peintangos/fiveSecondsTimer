//
//  SettingViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/11.
//

import UIKit

let web = ["アイコンの設定","秒数の設定","背景色の設定"]
class SettingViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.setNavigationBar()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        こいつを設定してあげないと表が上に行ってしまう。上に行った結果ナビゲーションとかぶってしまうので、一旦下に下げる。
//        下に下げるとその上に乗っているナビゲーションも一緒に下がってしまうので、ナビゲーションの位置は変える
        tableView.contentInset.top = 50
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
//        もし、TableViewControllerを設定しない場合なぜかずれてしまうので、ここでyを0にすると少しずれてしまうので20を設定する
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: -50, width: screenSize.width, height: screenSize.height))
        let navItem = UINavigationItem(title: "設定画面")
        let doneItem = UIBarButtonItem(title: "完了", style: UIBarButtonItem.Style.done, target: nil, action: #selector(done))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    @objc func done() {
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = web[(indexPath as NSIndexPath).row]
        return cell
    }
//    タップしても画面遷移をしない。。
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("タップされた")
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailSettingController")
            self.navigationController?.pushViewController(secondVC!, animated: true)
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
