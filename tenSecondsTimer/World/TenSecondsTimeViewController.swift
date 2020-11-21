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
//        20はiOS11用につけただけなので、後で対策を考える。
//        self.view.frame = CGRect(x: 0, y: 124, width: self.view.frame.width, height: self.view.frame.height)
        var height = 0
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
        // iPhone 6
          // iPhone 6s
          // iPhone 7
          // iPhone 8
            height = 80
            break;
        case 2208:
            // iPhone 6 Plus
            // iPhone 6s Plus
            // iPhone 7 Plus
            // iPhone 8 Plus
            height = 80
            break
        case 2436:
            //iPhone X
            height = 124
            break
        default:
            height = 124
            break
        }
        print(UIScreen.main.nativeBounds.height)
        print(height)

        self.view.frame = CGRect(x: 0, y: CGFloat(height), width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: view.frame, style: .grouped)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 124)
        self.tableView.contentInset.top = self.view.safeAreaInsets.top
        self.tableView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.makeColorLayer(number: backgroundColorNumberStatic, viewT: self.view)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(self.tableView!)
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        updateAll()

        
//        self.tableView.backgroundColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
        
////        let vm = CountTimeViewModel(itemsList: self.countTimeDtoList)
//        var items:Observable<[CountTimeDto]> = Observable.just(self.countTimeDtoList)
//        items.bind(to: (self.tableView.rx.items(cellIdentifier: "cell"))){row,element,cell in
//            cell.textLabel?.text = element.name.description
//            print(element.name)
//        }.disposed(by: dispopse)
        update()
    }
    
    override func viewDidLayoutSubviews() {
        var height = 0
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
        // iPhone 6
          // iPhone 6s
          // iPhone 7
          // iPhone 8
            height = 80
            break;
        case 2208:
            // iPhone 6 Plus
            // iPhone 6s Plus
            // iPhone 7 Plus
            // iPhone 8 Plus
            height = 80
            break
        case 2436:
            //iPhone X
            height = 124
            break
        default:
            height = 124
            break
        }
        var heightT = safeAreaTopT! + 44 + 80
        self.view.frame = CGRect(x: 0, y: heightT, width: self.view.frame.width, height: self.view.frame.height)
    }
    @objc func refresh(){
        updateAll()
//        少し、クルクルが終わるのが早いので、遅らせる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.refreshControl.endRefreshing()
        }
        
    }
    var safeAreaTopHeight:CGFloat{
        if #available(iOS 11, *){
            return 44
        }else {
            return 0
        }
    }
    var countTimeLabelDtoList = [Int:Array<CountTimeDto>]()
    var isConnectionSuccess:Bool?
    var yourCountTimeLabelRanking:Int?
    func update(){
        let parameters:[String:Int]=[
            "page":self.page]
        Alamofire.request("http://localhost:8080/countTime/list",method:.get,parameters: parameters).responseJSON { (reponse) in
            let deocder:JSONDecoder = JSONDecoder()
            do{
                let countTimeDtos :[CountTimeDto] = try deocder.decode([CountTimeDto].self, from: reponse.data!)
                self.countTimeDtoList = countTimeDtos
                self.tableView.reloadData()
                self.loading = false
            }catch{
                print("TenSeconds.updateデコードに失敗しました。")
            }
        }
        self.loading = true
    }
    var page = 10
    override func viewWillDisappear(_ animated: Bool) {
//        viewが離れるたびに、ページ数をリセットする
        self.page = 10
    }
    func updateYourScore(){
        let parameters:[String:String] = [
            "key":name]
        Alamofire.request("http://localhost:8080/countTime/keys",method: .get,parameters: parameters).validate(statusCode: 200..<400).responseString { [self]response in
            switch response.result {
            case .success:
                yourScore = String(data: response.data!,encoding: .utf8)!
            case .failure:
                print("TenSeconds.updateYourScore失敗")
            }
        }
    }
    func updateLabel(){
        Alamofire.request("http://localhost:8080/countTime/listLabel",method: .get).validate(statusCode: 200..<400).responsePropertyList { (response) in
            let decoder = JSONDecoder()
            do{
                let data = try decoder.decode(CountTimeLabelDto.self, from: response.data!)
                self.countTimeLabelDtoList = data.map
            }catch{
                print("TenSeconds.updaetLabelデコードに失敗してるよ〜")
            }
        }
    }
    func updateYourLabelScore(){
        let parameters:[String:String] = [
            "key":name]
        Alamofire.request("http://localhost:8080/countTime/rank",method:.get,parameters: parameters).validate(statusCode: 200..<400).responseString { (response) in
            switch response.result{
            case .success:
                self.isConnectionSuccess = true
                self.yourCountTimeLabelRanking = Int(response.value!)
            case .failure:
                print("TenSeconds.updateYourLabelScoreデコードに失敗しています。")
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
            return 20
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
    var count = 0
    var countG = 0
    var loading = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 20.0
        if y > (h + reload_distance) {
//            初期値はfalseなので、初めて最下層に到達した場合はこのif文が実行される
//            その後、初めてupdate()が呼ばれたタイミングで、loadingをtrueにする
//            その後、非同期処理で値が帰ってきた後にloadingをfalseにする
            if !self.loading {
                page = page + 10
                update()
            }
        }
    }
//    テーブルの最下層でアクティビィティインジケータを表示する
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = 2
//        インジケータを出し始めるタイミングを決定する。最後のインデックス-3のところでインジケータの表示を始める
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 3
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
           // print("this is the last cell")
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .systemGreen
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    func makeColorLayer(number:Int,viewT:UIView){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = CGRect(x: 0, y: 0, width: viewT.frame.width, height: viewT.frame.height)
        viewT.layer.insertSublayer(layer!, at: 1)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        updateAll()
        self.tableView.reloadData()
    }
    func updateAll(){
        update()
        updateYourScore()
        updateLabel()
        updateYourLabelScore()
    }
    var yourScore:String?
    let refreshControl = UIRefreshControl()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0 {
            cell.textLabel?.text = "あなたの世界ランキングは\(yourScore ?? "??")位です"
            return cell
        }else if indexPath.section == 1 {
            let rightAccView = UILabel(frame: CGRect(x: cell.frame.width, y: 0, width: 35, height: 35))
            rightAccView.center.y = cell.center.y
            rightAccView.textAlignment = NSTextAlignment.center
            rightAccView.font = UIFont.systemFont(ofSize: 15)
            guard let isConnect = self.isConnectionSuccess  else {
                cell.textLabel?.text = "??"
                return cell
            }
            yourCountTimeLabelRanking = 15
            if yourCountTimeLabelRanking! > indexPath.row + 1 {
                cell.textLabel?.text = "??"
                return cell
            }
            if yourCountTimeLabelRanking == indexPath.row + 1{
                cell.textLabel?.textColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
            }
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "合コン王"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[0]?.count ?? 00))人"
            case 1:
                cell.textLabel?.text = "合コンコンサルタント4年目"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[1]?.count ?? 00))人"
            case 2:
                cell.textLabel?.text = "合コンコンサルタント3年目"
                rightAccView.text =  "\(String(self.countTimeLabelDtoList[2]?.count ?? 00))人"
            case 3:
                cell.textLabel?.text = "合コンコンサルタント2年目"
                rightAccView.text =  "\(String(self.countTimeLabelDtoList[3]?.count ?? 00))人"
            case 4:
                cell.textLabel?.text = "合コンコンサルタント1年目"
                rightAccView.text =  "\(String(self.countTimeLabelDtoList[4]?.count ?? 00))人"
            case 5:
                cell.textLabel?.text = "飲み会コンサルタント3年目"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[5]?.count ?? 00))人"
            case 6:
                cell.textLabel?.text = "飲み会コンサルタント2年目"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[6]?.count ?? 00))人"
            case 7:
                cell.textLabel?.text = "飲み会コンサルタント1年目"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[7]?.count ?? 00))人"
            case 8:
                cell.textLabel?.text = "飲みサーの代表"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[8]?.count ?? 00))人"
            case 9:
                cell.textLabel?.text = "飲みサーの3年"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[9]?.count ?? 00))人"
            case 10:
                cell.textLabel?.text = "飲み会不可欠"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[10]?.count ?? 00))人"
            case 11:
                cell.textLabel?.text = "飲みサーの2年"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[11]?.count ?? 00))人"
            case 12:
                cell.textLabel?.text = "飲みサーの1年"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[12]?.count ?? 00))人"
            case 13:
                cell.textLabel?.text = "普通のサークルの代表"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[13]?.count ?? 00))人"
            case 14:
                cell.textLabel?.text = "合コンピンチヒッター"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[14]?.count ?? 00))人"
            case 15:
                cell.textLabel?.text = "普通のサークルの3年"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[15]?.count ?? 00))人"
            case 16:
                cell.textLabel?.text = "飲み会で最後まで生き残る方"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[16]?.count ?? 00))人"
            case 17:
                cell.textLabel?.text = "普通のサークルの2年"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[17]?.count ?? 00))人"
            case 18:
                cell.textLabel?.text = "クラスのお調子者"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[18]?.count ?? 00))人"
            case 19:
                cell.textLabel?.text = "たけちたろう"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[19]?.count ?? 00))人"
            default:
                cell.textLabel?.text = "soon coming"
                rightAccView.text = "\(String(self.countTimeLabelDtoList[19]?.count ?? 00))人"
            }
            cell.addSubview(rightAccView)
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
