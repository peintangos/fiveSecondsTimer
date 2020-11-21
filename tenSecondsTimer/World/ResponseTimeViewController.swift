//
//  ResponseTimeViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import UIKit
import Alamofire

class ResponseTimeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //        20はiOS11用につけただけなので、後で対策を考える。
//        self.view.frame = CGRect(x: 0, y: 124, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.makeColorLayer(number: backgroundColorNumberStatic, viewT: self.view)
//        tableViewの高さは、セーフエリアとナビゲーションエリア、セグメントエリア分だけ小さくしなければ見れない領域が出てきてしまう。
//        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 164)
        self.tableView.contentInset.top = self.view.safeAreaInsets.top
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(self.tableView!)
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        updateAll()
//        self.tableView.backgroundColor = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 93 / 255, alpha: 1)
    }
    @objc func refresh(){
        updateAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.refreshControl.endRefreshing()
        }
    }
    override func viewDidLayoutSubviews() {
        print(self.view.safeAreaInsets.top)
        var heightT = safeAreaTopT! + 44 + 80
        self.view.frame = CGRect(x: 0, y: heightT, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 124)
    }
    var safeAreaTopHeight:CGFloat{
        if #available(iOS 11, *){
            return 44
        }else {
            return 0
        }
    }
    var tableView:UITableView!
    let refreshControl = UIRefreshControl()
    var justGetMiddleDtoList = Array<JustGetMiddleDto>()
    var yourResponseRanking:String?
    var justGetMiddleLabelDtoList = [Int:Array<JustGetMiddleDto>]()
    var isConnectionSuccess:Bool?
    var yourResponseLabelRanking:Int?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 20
        }else if section == 2{
//            配列を超える数を入れてしまうと、下のどこかでリストを超える要素にアクセスしてしまい、実行時エラーとなる
            return self.justGetMiddleDtoList.count > page ? page :self.justGetMiddleDtoList.count
        }else {
            return self.justGetMiddleDtoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0 {
            cell.textLabel?.text = "あなたの世界ランキングは\(yourResponseRanking ?? "??")位です"
            return cell
        }else if indexPath.section == 1{
            let rightAccView = UILabel(frame: CGRect(x: cell.frame.width, y: 0, width: 35, height: 35))
            rightAccView.center.y = cell.center.y
            rightAccView.textAlignment = NSTextAlignment.center
            rightAccView.font = UIFont.systemFont(ofSize: 15)
//            レコードがない場合に、順位の判定ができないため、レコードがない場合は全て??を返す
            guard let connection = self.isConnectionSuccess else {
                cell.textLabel?.text = "??"
                return cell
            }
            if indexPath.row + 1 < self.yourResponseLabelRanking! {
                cell.textLabel?.text = "??"
                return cell
            }
            if yourResponseLabelRanking == indexPath.row + 1{
                cell.textLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
            }
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "合コン王"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[0]?.count ?? 00))人"
            case 1:
                cell.textLabel?.text = "合コンコンサルタント4年目"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[1]?.count ?? 00))人"
            case 2:
                cell.textLabel?.text = "合コンコンサルタント3年目"
                rightAccView.text =  "\(String(self.justGetMiddleLabelDtoList[2]?.count ?? 00))人"
            case 3:
                cell.textLabel?.text = "合コンコンサルタント2年目"
                rightAccView.text =  "\(String(self.justGetMiddleLabelDtoList[3]?.count ?? 00))人"
            case 4:
                cell.textLabel?.text = "合コンコンサルタント1年目"
                rightAccView.text =  "\(String(self.justGetMiddleLabelDtoList[4]?.count ?? 00))人"
            case 5:
                cell.textLabel?.text = "飲み会コンサルタント3年目"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[5]?.count ?? 00))人"
            case 6:
                cell.textLabel?.text = "飲み会コンサルタント2年目"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[6]?.count ?? 00))人"
            case 7:
                cell.textLabel?.text = "飲み会コンサルタント1年目"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[7]?.count ?? 00))人"
            case 8:
                cell.textLabel?.text = "飲みサーの代表"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[8]?.count ?? 00))人"
            case 9:
                cell.textLabel?.text = "飲みサーの3年"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[9]?.count ?? 00))人"
            case 10:
                cell.textLabel?.text = "飲み会不可欠"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[10]?.count ?? 00))人"
            case 11:
                cell.textLabel?.text = "飲みサーの2年"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[11]?.count ?? 00))人"
            case 12:
                cell.textLabel?.text = "飲みサーの1年"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[12]?.count ?? 00))人"
            case 13:
                cell.textLabel?.text = "普通のサークルの代表"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[13]?.count ?? 00))人"
            case 14:
                cell.textLabel?.text = "合コンピンチヒッター"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[14]?.count ?? 00))人"
            case 15:
                cell.textLabel?.text = "普通のサークルの3年"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[15]?.count ?? 00))人"
            case 16:
                cell.textLabel?.text = "飲み会で最後まで生き残る方"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[16]?.count ?? 00))人"
            case 17:
                cell.textLabel?.text = "普通のサークルの2年"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[17]?.count ?? 00))人"
            case 18:
                cell.textLabel?.text = "クラスのお調子者"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[18]?.count ?? 00))人"
            case 19:
                cell.textLabel?.text = "たけち"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[19]?.count ?? 00))人"
            default:
                cell.textLabel?.text = "soon coming"
                rightAccView.text = "\(String(self.justGetMiddleLabelDtoList[19]?.count ?? 00))人"
            }
//            cellのacceerosyViewを使う手があったが、fameの調節がうまくいかなったので、こちらにした
            cell.addSubview(rightAccView)
            return cell
        }
        else if indexPath.section == 2{
            cell.textLabel?.text = "\(indexPath.row + 1)位　\(String(self.justGetMiddleDtoList[(indexPath as NSIndexPath).row].difference))"
            cell.detailTextLabel?.text = String(self.justGetMiddleDtoList[(indexPath as NSIndexPath).row].name)
        }else {
            
        }
    
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //    テーブルの最下層でアクティビィティインジケータを表示する
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastSectionIndex = 2
    //        インジケータを出し始めるタイミングを決定する。最後のインデックス-3のところでインジケータの表示を始める
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
               // print("this is the last cell")
                let spinner = UIActivityIndicatorView(style: .large)
//                なぜか、色が設定できなかった。
//                spinner.color = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 93 / 255, alpha: 1)
                spinner.color = .systemGreen
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
            }
        }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "あなたの反射神経順位"
        case 1:
            return "遊び人ランク"
        case 2:
            return "全世界の反射神経ランク"
        default:
            return ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        updateAll()
        self.tableView.reloadData()
    }
    func updateAll(){
        update()
        updeYourScore()
        updateLabel()
        updeYourScoreLabel()
    }
    func updeYourScore(){
//        現状、レコードがない場合に失敗してしまう
        let parameters:[String:String] = [
            "key":name]
        Alamofire.request("http://localhost:8080/justgetmiddle/keys",method: .get,parameters: parameters).validate(statusCode: 200..<400).responseData{response in
            switch response.result {
            case .success:
                self.yourResponseRanking = String(data:response.data!,encoding: .utf8)
            case .failure:
                print("ReponseTime.updeYourScoreデコードに失敗しました。")
            }
        }
    }
    func updeYourScoreLabel(){
        let parameters:[String:String] = [
            "key":name]
        Alamofire.request("http://localhost:8080/justgetmiddle/rank",method: .get,parameters: parameters).validate(statusCode: 200..<400).responseString{response in
            switch response.result {
            case .success:
                self.isConnectionSuccess = true
                self.yourResponseLabelRanking = Int(response.value!)
            case .failure:
                print("ReponseTime.updeYourScoreLabelデコードに失敗した。")
            }
        }
    }
    func updateLabel(){
        Alamofire.request("http://localhost:8080/justgetmiddle/listLabel",method: .get).validate(statusCode: 200..<400).responseJSON { (response) in
            let decoder = JSONDecoder()
            do{
                let list = try decoder.decode(JustGetMiddleLabelDto.self, from: response.data!)
                self.justGetMiddleLabelDtoList = list.map
                self.tableView?.reloadData()
            }catch{
                print("ReponseTime.updateLabelデコ失敗")
            }
        }
    }
    func update(){
//        let parameters:[String:Int] = [
//            "key": responseListLength]
        Alamofire.request("http://localhost:8080/justgetmiddle/list").responseJSON { [self] (response) in
            let decoder = JSONDecoder()
            do{
                let justGetMiddleDtos = try decoder.decode([JustGetMiddleDto].self, from: response.data!)
                self.justGetMiddleDtoList = justGetMiddleDtos
//                こいつを走らせないと、初期値のから配列がずっと表示されてしまう
                self.tableView?.reloadData()
                self.loading = false
            }catch{
                print("ReponseTime.updateデコードに失敗しています。")
            }
        }
        loading = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 20
//        到達した瞬間に実行されてしまうと一瞬でインジケータが消えてしまうので、少し余分にスクロールした時に初めて、update()を呼ぶ
        if y - reload_distance > h {
            if !loading{
                page = page + 10
                update()
            }
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        page = 10
    }
    var loading = false
    var page = 10
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
           // テキスト色を変更する
        header.textLabel?.textColor = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 93 / 255, alpha: 1)
    }
    func makeColorLayer(number:Int,viewT:UIView){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = CGRect(x: 0, y: 0, width: viewT.frame.width, height: viewT.frame.height)
        viewT.layer.insertSublayer(layer!, at: 1)
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
