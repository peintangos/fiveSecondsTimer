//
//  ChangeIconsViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/17.
//


/**
 各種設定画面のモーダルを表示します
 */
import UIKit

class ChangeIconsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
//    遷移元から値を引き継ぐ
    var sectionNumber :Int?
    var rowNumber:Int?
//    選択している値を一時的に保存する変数（完了ボタンタップでUserDefaultsに保存する
    var timeNumber:Int?
    var iconNumber:Int?
    var colorNumber:Int?
    var buttoColorNumber:Int?
    var buttoWidthColorNumber:Int?
    var buttonTextColorNumber:Int?
    var buttonTextSizeNumber:Int?
    

//    Enumの個数を数えるのに、Enum本体にCaseIterableプロトコルを実装し、.allCases.countプロパティでアクセス
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        後でswitch文に書き換えること
        if self.sectionNumber! == 0 && self.rowNumber! == 0 {
            return Setting.time.allCases.count
        }else if sectionNumber! == 1 && self.rowNumber! == 0{
            return Setting.icon.allCases.count
        }else if sectionNumber! == 1 && self.rowNumber! == 1{
            return Setting.color.allCases.count
        }else if sectionNumber! == 1 && self.rowNumber! == 2{
            return Setting.color.allCases.count
        }else if sectionNumber! == 1 && self.rowNumber! == 3{
            return Setting.fontSize.allCases.count
        }
        else if sectionNumber! == 1 && self.rowNumber! == 4{
            return Setting.color.allCases.count
        }else if sectionNumber! == 1 && self.rowNumber! == 5{
            return Setting.time.allCases.count
        }
        else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let defaults = UserDefaults.standard
//        秒数設定を行う
//        Enumの方では、1始まりだがrowの数は0始まりなので、+1をする調整が必要
//        UserDefaultに設定してある値には、checkMarkをつけるという処理
//                後でswitch文に書き換えること
        if self.sectionNumber! == 0 && self.rowNumber! == 0 {
            cell.textLabel?.text = String(Setting.time.init(rawValue: indexPath.row + 1)!.rawValue)
            if defaults.integer(forKey: "timeNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
//            アイコン設定を行う
        }else if sectionNumber! == 1 && self.rowNumber! == 0{
            cell.textLabel?.text = Setting.icon.init(rawValue: indexPath.row + 1)!.getName()
            if defaults.integer(forKey: "iconNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
//            輪っかの色を設定する
        }else if sectionNumber! == 1 && self.rowNumber! == 1{
            cell.textLabel?.text = Setting.color.init(rawValue: indexPath.row + 1)!.getUIColor().accessibilityName
            if defaults.integer(forKey: "colorNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
//            ボタンの色を設定する
        }else if sectionNumber! == 1 && self.rowNumber! == 2{
            cell.textLabel?.text = Setting.color.init(rawValue: indexPath.row + 1)!.getUIColor().accessibilityName
            if defaults.integer(forKey: "buttonTextColorNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
//            ボタンの文字の大きさを設定する
        }else if sectionNumber! == 1 && self.rowNumber! == 3{
            cell.textLabel?.text = Setting.fontSize.init(rawValue: indexPath.row + 1)!.getName()
            if defaults.integer(forKey: "buttonTextSizeNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
        }
//        ボタンの枠の色を設定する
        else if sectionNumber! == 1 && self.rowNumber! == 4{
            cell.textLabel?.text = Setting.color.init(rawValue: indexPath.row + 1)!.getUIColor().accessibilityName
            if defaults.integer(forKey: "buttonColorNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
//            ボタンの枠の幅を設定する
        }else if sectionNumber! == 1 && self.rowNumber! == 5{
            cell.textLabel?.text = String(Setting.time.init(rawValue: indexPath.row + 1)!.rawValue)
            if defaults.integer(forKey: "buttonWithColorNumber") == indexPath.row + 1 {
                cell.accessoryType = .checkmark
            }
            
        }
        else {
            
        }
        return cell
    }
//    セルが選択された時、初期状態で表示していたセルのチェックマークを外すという処置をしたかったが、できなかった。
//    選択したときに、その値を変数に入れるという処理も同時に行っている。
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        if self.sectionNumber! == 0 && self.rowNumber! == 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "timeNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.timeNumber = indexPath.row + 1
        }else if sectionNumber! == 1 && self.rowNumber! == 0{
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "iconNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.iconNumber = indexPath.row + 1
        }else if sectionNumber! == 1 && self.rowNumber! == 1{
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "colorNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.colorNumber = indexPath.row + 1
        }else if sectionNumber! == 1 && self.rowNumber! == 2{
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "buttonTextColorNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.buttonTextColorNumber = indexPath.row + 1
        }else if sectionNumber! == 1 && self.rowNumber! == 3{
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "buttonTextSizeNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.buttonTextSizeNumber = indexPath.row + 1
        }
        else if sectionNumber! == 1 && self.rowNumber! == 4{
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "buttonColorNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.buttoColorNumber = indexPath.row + 1
        }else if sectionNumber! == 1 && self.rowNumber! == 5{
            let cell = tableView.cellForRow(at: IndexPath(row: defaults.integer(forKey: "buttonWithColorNumber") - 1, section: indexPath.section))
            cell?.accessoryType = .none
            self.buttoWidthColorNumber = indexPath.row + 1
        }
        else
        {
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .cyan
        do {
            let myTableView:UITableView!
            myTableView = UITableView(frame: view.frame, style: .grouped)
            myTableView.delegate = self
            myTableView.dataSource = self
//            これで行けた。複数選択されてしまうことを回避した
            myTableView.allowsMultipleSelection = false
            myTableView.contentInset.top = 44
            view.addSubview(myTableView)
        }
        do{
            let bar = UINavigationBar()
            bar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
            let navItem = UINavigationItem()
            navItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItem.Style.done, target: nil, action:#selector(self.goBack))
            bar.pushItem(navItem, animated: true)
            self.view.addSubview(bar)
        }
    }

    @objc func goBack(){
        let defaults = UserDefaults.standard
//        行いたいことは、UserDefaultsとxxxNumberStaticの更新。timeNumberは初期値でnilが入っているが、tableViewでタップされるとタップされた値が入っていく。ので、nilの場合は何もしないが、nilでない場合は、値が更新されているということなので、その値をUserDefaultsと全体で共通としてもっているxxxNumberStaticに入れる。
        if let timenum = timeNumber {
            defaults.set(timenum,forKey: "timeNumber")
            timeNumberStatic = timenum
        }
        if let iconnum = iconNumber {
            defaults.set(iconNumber!,forKey: "iconNumber")
            iconNumberStatic = iconnum
        }
        if let colornum = colorNumber {
            defaults.set(colorNumber!,forKey: "colorNumber")
            colorNumberStatic = colornum
        }
        if let buttonColornum = buttoColorNumber{
            defaults.set(buttoColorNumber!,forKey:"buttonColorNumber")
            buttonColorNumberStatic = buttonColornum
        }
        if let a = buttoWidthColorNumber{
            defaults.setValue(buttoWidthColorNumber!, forKey: "buttonWithColorNumber")
            buttonWidthNumberStatic = a
        }
        if let b = buttonTextColorNumber{
            defaults.setValue(buttonTextColorNumber!, forKey: "buttonTextColorNumber")
            buttonTextColorNumberStatic = b
        }
        if let size = buttonTextSizeNumber{
            defaults.setValue(buttonTextSizeNumber!, forKey: "buttonTextSizeNumber")
            buttonTextSizeNumberStatic = size
        }
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
