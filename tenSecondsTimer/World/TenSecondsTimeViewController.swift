//
//  TenSecondsTimeViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class TenSecondsTimeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let dispopse = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        self.view.backgroundColor = .blue
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(self.tableView!)
  
//        本当はこうやりたかったが、できない。
//        var vm = CountTimeViewModel()
//        vm.itemObservalble.bind(to: (self.tableView?.rx.items(cellIdentifier: "Cell"))!){row,element,cell in
//            cell.textLabel?.text = element.name
//        }.disposed(by: dispopse)
        update()
    }
    func update(){
        Alamofire.request("http://localhost:8080/countTime/list",method:.get).responseJSON { (reponse) in
            let deocder:JSONDecoder = JSONDecoder()
            do{
                let countTimeDtos :[CountTimeDto] = try deocder.decode([CountTimeDto].self, from: reponse.data!)
                self.countTimeDtoList = countTimeDtos
                self.tableView?.reloadData()
                print(countTimeDtos)
            }catch{
                print("デコードに失敗しました。")
            }
        }
    }

    var tableView:UITableView?
    var countTimeDtoList = Array<CountTimeDto>()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else {
            return self.countTimeDtoList.count
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0{
            cell.textLabel?.text = "あなたの順位は未定です"
            return cell
        }
        cell.textLabel?.text = "\(indexPath.row + 1)位 \(String(self.countTimeDtoList[(indexPath as NSIndexPath).row].timeDifference))" ?? "ロード中"
        cell.detailTextLabel?.text = self.countTimeDtoList[indexPath.row].name ?? "ロード中"
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "あなたの秒当て順位"
        case 1:
            return "全世界の秒当てランキング"
        default:
            return ""
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
