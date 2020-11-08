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


class TenSecondsTimeViewController: UIViewController,UITableViewDataSource{
    
    let dispopse = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.frame = CGRect(x: 0, y: 164 + self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView.contentInset.top = self.view.safeAreaInsets.top
        tableView.dataSource = self
//        tableView.delegate = self
        self.view.addSubview(self.tableView!)
        
        self.update()
        self.updateYourScore()
  
        
////        let vm = CountTimeViewModel(itemsList: self.countTimeDtoList)
//        var items:Observable<[CountTimeDto]> = Observable.just(self.countTimeDtoList)
//        items.bind(to: (self.tableView.rx.items(cellIdentifier: "cell"))){row,element,cell in
//            cell.textLabel?.text = element.name.description
//            print(element.name)
//        }.disposed(by: dispopse)
        update()
    }
    func update(){
        Alamofire.request("http://localhost:8080/countTime/list",method:.get).responseJSON { (reponse) in
            let deocder:JSONDecoder = JSONDecoder()
            do{
                let countTimeDtos :[CountTimeDto] = try deocder.decode([CountTimeDto].self, from: reponse.data!)
                self.countTimeDtoList = countTimeDtos
                self.tableView.reloadData()
            }catch{
                print("デコードに失敗しました。")
            }
        }
    }
    func updateYourScore(){
        let parameters:[String:String] = [
            "key":name]
        Alamofire.request("http://localhost:8080/countTime/keys",method: .get,parameters: parameters).validate(statusCode: 200..<400).responseString { [self]response in
            switch response.result {
            case .success:
                yourScore = String(data: response.data!,encoding: .utf8)!
            case .failure:
                print("失敗")
            }
        }
    }


    var tableView:UITableView!
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
        updateYourScore()
        self.tableView.reloadData()
    }
    var yourScore:String?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0{
            cell.textLabel?.text = "あなたの世界ランクは\(yourScore ?? "xx")位です"
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
