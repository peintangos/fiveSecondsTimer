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


class TenSecondsTimeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    let dispopse = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.frame = CGRect(x: 0, y: 164 + self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 164)
        self.tableView.contentInset.top = self.view.safeAreaInsets.top
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(self.tableView!)
        
        self.update()
        self.updateYourScore()
        
//        self.tableView.backgroundColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
        
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
        switch section {
        case 0:
            return 1
        case 1:
            return 8
        case 2:
            return self.countTimeDtoList.count
        default:
            return self.countTimeDtoList.count
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
           // テキスト色を変更する
        header.textLabel?.textColor = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 93 / 255, alpha: 1)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        if y > (h + reload_distance) {
            print("load more rows")
//            update()
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
        if indexPath.section == 0 {
            cell.textLabel?.text = "あなたの世界ランクは\(yourScore ?? "xx")位です"
            return cell
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "soon coming"
                cell.accessoryView = UILabel()
            case 1:
                cell.textLabel?.text = "soon coming"
            case 2:
                cell.textLabel?.text = "soon coming"
            case 3:
                cell.textLabel?.text = "soon coming"
            case 4:
                cell.textLabel?.text = "soon coming"
            case 5:
                cell.textLabel?.text = "soon coming"
            case 6:
                cell.textLabel?.text = "soon coming"
            case 7:
                cell.textLabel?.text = "soon coming"
            case 8:
                cell.textLabel?.text = "soon coming"
            case 9:
                cell.textLabel?.text = "soon coming"
            case 10:
                cell.textLabel?.text = "soon coming"
            case 11:
                cell.textLabel?.text = "soon coming"
            case 12:
                cell.textLabel?.text = "soon coming"
            case 13:
                cell.textLabel?.text = "soon coming"
            case 14:
                cell.textLabel?.text = "soon coming"
            case 15:
                cell.textLabel?.text = "soon coming"
            case 16:
                cell.textLabel?.text = "soon coming"
            case 17:
                cell.textLabel?.text = "soon coming"
            case 18:
                cell.textLabel?.text = "soon coming"
            case 19:
                cell.textLabel?.text = "soon coming"
            default:
                cell.textLabel?.text = "soon coming"
            }
            cell.accessoryType = .checkmark
            return cell
        }else if indexPath.section == 2 {
            cell.textLabel?.text = "\(indexPath.row + 1)位 \(String(self.countTimeDtoList[(indexPath as NSIndexPath).row].timeDifference))" 
            cell.detailTextLabel?.text = self.countTimeDtoList[indexPath.row].name 
            return cell
        }else {
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "あなたの秒当て順位"
        case 1:
            return "遊び人ランク"
        case 2:
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
