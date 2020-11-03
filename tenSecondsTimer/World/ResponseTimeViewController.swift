//
//  ResponseTimeViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import UIKit
import Alamofire

class ResponseTimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(self.tableView!)
        update()
    }
    var tableView:UITableView?
    var justGetMiddleDtoList = Array<JustGetMiddleDto>()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return self.justGetMiddleDtoList.count
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0 {
            cell.textLabel?.text = "あなたの順位未定です"
            return cell
        }else {
            cell.textLabel?.text = "\(indexPath.row + 1)位　\(String(self.justGetMiddleDtoList[(indexPath as NSIndexPath).row].difference))" ?? "ロード中"
        }
    
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "あなたの反射神経順位"
        case 1:
            return "全世界の反射神経ランキング"
        default:
            return ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    func update(){
        Alamofire.request("http://localhost:8080/justgetmiddle/list").responseJSON { (response) in
            let decoder = JSONDecoder()
            do{
                let justGetMiddleDtos = try! decoder.decode([JustGetMiddleDto].self, from: response.data!)
                print(justGetMiddleDtos)
                self.justGetMiddleDtoList = justGetMiddleDtos
//                こいつを走らせないと、初期値のから配列がずっと表示されてしまう
                self.tableView?.reloadData()
            }catch{
                print("デコードに失敗しています。")
            }
           
            
        }
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
