//
//  ResponseTimeViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import UIKit
import Alamofire

class ResponseTimeViewController: UIViewController,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.frame = CGRect(x: 0, y: 164 + self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView.contentInset.top = self.view.safeAreaInsets.top
        tableView.dataSource = self
        self.view.addSubview(self.tableView!)
        update()
        updeYourScore()
    }
    var tableView:UITableView!
    var justGetMiddleDtoList = Array<JustGetMiddleDto>()
    var yourResponseRanking:String?
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
            cell.textLabel?.text = "あなたの世界ランクは\(yourResponseRanking ?? "xx")位"
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
        updeYourScore()
        self.tableView.reloadData()
    }
    func updeYourScore(){
        let parameters:[String:String] = [
            "key":name]
        Alamofire.request("http://localhost:8080/justgetmiddle/keys",method: .get,parameters: parameters).validate(statusCode: 200..<400).responseString{response in
            switch response.result {
            case .success:
                self.yourResponseRanking = String(data:response.data!,encoding: .utf8)
            case .failure:
                print("失敗しました。")
            }
        }
    }
    func update(){
        Alamofire.request("http://localhost:8080/justgetmiddle/list").responseJSON { (response) in
            let decoder = JSONDecoder()
            do{
                let justGetMiddleDtos = try decoder.decode([JustGetMiddleDto].self, from: response.data!)
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
