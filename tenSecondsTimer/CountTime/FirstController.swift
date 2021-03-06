//
//  FirstController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

/**
 一人用のViewです
 */
import UIKit
import RealmSwift
import Alamofire
import RxCocoa
import RxSwift
//　　画面サイズの定数
let myBoundSize: CGSize = UIScreen.main.bounds.size
var recordIdStatic:Int?
class FirstController: UIViewController, UITextFieldDelegate {
    func makeTimerSec(timersec:UILabel){
        timersec.text = "00"
        timersec.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2 - widthTimerSec, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
        timersec.textAlignment = NSTextAlignment.center
        timersec.font = UIFont.systemFont(ofSize: 40)
        timersec.textColor = .white
        timersec.center.y = self.view.center.y
        timersec.center.x = self.view.center.x - 40
//        秒を表示してたが、ルールがわからないかなと思ったので、説明文に変更
        timersec.isHidden = true
        self.view.addSubview(timersec)
    }
    
    func makeTimerMill(timermill:UILabel){
        timermill.text = "00"
        timermill.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
        timermill.textAlignment = NSTextAlignment.center
        timermill.font = UIFont.systemFont(ofSize: 40)
        timermill.textColor = .white
        timermill.center.y = self.view.center.y
        timermill.center.x = self.view.center.x + 40
//        秒を表示してたが、ルールがわからないかなと思ったので、説明文に変更
        timermill.isHidden = true
        self.view.addSubview(timermill)
    }
    
    func makeCircle(shapeLayer shapelayer:CAShapeLayer){
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y) // 中心座標
//        下の数字は目分量。最悪です
        let radius = shapelayer.bounds.size.width / 3.2  // 半径
        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapelayer.path = path.cgPath
    }
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        layer.lineWidth = 2
        return layer
}()
    let widthTimerSec = 100
    let heightTimerSec = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        makeStart(startX: self.start2)
        makeStop(stopX: self.stop2)
        self.start2.addTarget(self, action: #selector(go), for: .touchUpInside)
        self.stop2.addTarget(self, action: #selector(back), for: .touchUpInside)
        makeExplanation()
        makeColorLayer(number: backgroundColorNumberStatic)
    }
    var explanation:UILabel!
    func makeExplanation(){
        self.explanation = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        self.explanation.center.x = self.view.center.x
        self.explanation.center.y = self.view.center.y - 10
        self.explanation.textColor = .white
        self.explanation.textAlignment = NSTextAlignment.center
        self.explanation.text = "\(timeNumberStatic)秒間ストップウォッチだよ！\nインジケータに惑わされないように注意してね！"
        self.explanation.numberOfLines = 0
        self.view.addSubview(self.explanation)
    }
    @objc func go(){
        self.stop2.isEnabled = true
        self.start2.isEnabled = false
        self.timerSecond.isHidden = true
        self.timerMsec.isHidden = true
        fire.isHidden = false
        top.isHidden = false
        self.start2.alpha = 0.5
        self.stop2.alpha = 1.0
        self.explanation.isHidden = true
//                計測開始
        startTime = Date()
//                 アニメーション開始
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        let randomInt = Int.random(in: 1..<5)
        switch randomInt {
        case 1:
            anim.duration = 1.0
        case 2:
            anim.duration = 5.0
        case 3:
            anim.duration = 10.0
        case 4:
            anim.duration = 20
        default:
            anim.duration = 1.0
            
        }
        anim.fromValue = 0.0
        anim.toValue = 1.0
        shapeLayer.add(anim, forKey: "circleAnim")
    }
    @objc func back(){
        //        Disable/Enableを制御
                self.stop2.isEnabled = false
                self.start2.isEnabled = true
        //        表示/非表示の制御
                self.top.isHidden = true
                self.fire.isHidden = true
        
//        止めるボタンを押した瞬間は、記録が出るようにする。（その後、名前を登録した後は、explanationと被ってしまうので、そのままにする）
                self.timerSecond.isHidden = false
                self.timerMsec.isHidden = false
                
        //        円形のサークルが、ストップボタンを押すと止まるように設定（.speed = 0 とすると、2回目こうやるときに動かなくなってしまったので、こちらを使用）
                shapeLayer.removeAllAnimations()

                let currentTime = Date().timeIntervalSince(startTime)
        
                // currentTime/60 の余り
                let second = (Int)(fmod(currentTime, 60))
                let secondDouble = (Double)(fmod(currentTime, 60))
                // floor 切り捨て、小数点以下を取り出して *100
                let msec = (Int)((currentTime - floor(currentTime))*100)
        //        let msecDouble = (Double)((currentTime - floor(currentTime))*100)

                // %02d： ２桁表示、0で埋める
                let sSecond = String(format:"%02d", second)
                let sMsec = String(format:"%02d", msec)

                timerSecond.text = sSecond
                timerMsec.text = sMsec
                
        //        アラートの作成
                let alert = UIAlertController(title:nil,message: nil,preferredStyle: .alert)
                alert.title = "記録は\(self.timerSecond.text!)秒\(self.timerMsec.text!)ミリでした!"
                alert.addAction(UIAlertAction(title: "記録を登録する!", style: .default, handler: {(action) -> Void in
                    let alertInput = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    alertInput.title = "名前を入れてね！"
                    alertInput.addTextField { (textField) in
                        textField.delegate = self
                    }
                    alertInput.addAction(UIAlertAction(title: "登録する", style: .default, handler: { [self] (action) in
        //                DBに登録
                        let realm = try! Realm()
                        let record = Record()
                        record.date = Date()
                        record.mokuhyo = timeNumberStatic
                        record.name = alertInput.textFields?[0].text!
                        record.timerSecond = self.timerSecond.text!
                        record.timerMsec = self.timerMsec.text!
                        record.result = self.timerSecond.text! + self.timerMsec.text!
                        recordIdStatic = record.id
                        let timeDiffrenceTemporary = self.calculate(second: secondDouble)
                        record.timeDifference = timeDiffrenceTemporary
                        try! realm.write{
                            realm.add(record)
                        }
                        self.timerSecond.isHidden = true
                        self.timerMsec.isHidden = true
                        
//                        AFを用いて、サーバーにデータを登録する
                        self.saveData(date: Date(), timeDifference: timeDiffrenceTemporary)

        //                登録した場合のみ、バッチをつける
                        self.tabBarController?.tabBar.items?[1].badgeValue = "New"
                        self.tabBarController?.tabBar.items?[1].badgeColor = UIColor.orange
                        
                        self.start2.alpha = 1
                        self.stop2.alpha = 0.5
                        self.explanation.isHidden = false
                    }))
        //            セカンドコントローラをアップデートする（これ必要かわからん）
                    let secondController = SecondController()
                    secondController.update()
                    
                    self.present(alertInput, animated: true, completion: nil)
                }))
//        タブを切り替える方法を学ぶために、書いたコードなので、メモしたら消す
//                alert.addAction(UIAlertAction(title: "記録を見にいく!", style: .default, handler: {(action) -> Void in
//        //            なんかわからないけど、ググったら出てきた笑
//        //            タブを切り替える方法ぽい
//
//                    let UINavigationController = self.tabBarController?.viewControllers?[1];
//                    self.tabBarController?.selectedViewController = UINavigationController;
//                    self.start2.alpha = 1
//                    self.stop2.alpha = 0.5
//                    self.explanation.isHidden = false
//                }))
        alert.addAction(UIAlertAction(title: "もう一回挑戦する!", style: .default, handler: { (action) in
            self.start2.alpha = 1
            self.stop2.alpha = 0.5
        }))
                self.present(alert, animated: true, completion: nil)
    }

    func saveData(date:Date,timeDifference:Double){
        let uuid = UserDefaults.standard.string(forKey: "UUID")
//        /日付のフォーマットを指定する。
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
//        日付をStringに変換する
        let sDate = format.string(from: date)
        let paramters:[String:Any] = [
            "deviceNumber":uuid!,
            "createdAt":sDate,
            "name":name,
            "timeDifference":timeDifference]
        Alamofire.request("http://springbootawscounttimerecords-env.eba-mvju5xjx.ap-northeast-1.elasticbeanstalk.com/countTime/list",method: .post,parameters: paramters,encoding: JSONEncoding.default,headers: nil).responseString{(response) in
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.view.layer.addSublayer(self.shapeLayer)
                
        timerSecond.text = "00"
        timerMsec.text = "00"
//                円形のサークル内のメッセージを作成
        top.frame.size = CGSize(width: 200, height: 20)
        top.center = self.view.center
        top.center.x = self.view.center.x
        top.center.y = self.view.center.y + 100
        top.text = "\(timeNumberStatic)秒って意外と長いぞ〜"
        top.textAlignment = NSTextAlignment.center
        top.textColor = UIColor.white
        top.isHidden = true

        //        炎アイコンを中心に設定し、メラメラするように設定
        fire.center = CGPoint(x: self.view.bounds.size.width/2.0, y: self.view.bounds.height/2.0)
        fire.image = UIImage(named:(Setting.icon(rawValue: iconNumberStatic)?.getName())!)
        fire.isHidden = true
        vibrated(view: fire)
        self.isFirst = true
                
        //        タイトルラベルを作成し、追加
        self.titleLabel.text = "\(timeNumberStatic) Seconds Timer"
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.frame = CGRect(x:40,y:20,width: 300,height: 70)
        self.titleLabel.center = CGPoint(x: myBoundSize.width/2, y:80)
        self.titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.titleLabel.textColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1)
        self.titleLabel.layer.borderWidth = 2.0
        self.titleLabel.layer.borderColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1).cgColor
        self.titleLabel.layer.cornerRadius = 4.0
        self.view.addSubview(self.titleLabel)
        self.view.bringSubviewToFront(self.titleLabel)
    }
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeTimerSec(timersec: self.timerSecond)
        makeTimerMill(timermill: self.timerMsec)
        makeCircle(shapeLayer: self.shapeLayer)
        makeAutoLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showToast()
        }
    }
    func makeStart(startX: UIButton){
        let imagView = UIImageView(image: UIImage(named: "cheer")!)
        imagView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        startX.addSubview(imagView)
        startX.isEnabled = true
        startX.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        startX.backgroundColor = .white
        startX.alpha = 1.0
        startX.layer.borderWidth = 1.0
        startX.layer.cornerRadius = 50
        self.view.addSubview(startX)
    }
    func makeStop(stopX:UIButton){
        let imagView = UIImageView(image: UIImage(named: "del")!)
        imagView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        stopX.layer.cornerRadius = 50
        stopX.isEnabled = false
        stopX.alpha = 0.5
        stopX.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        stopX.backgroundColor = .white
        stopX.layer.borderWidth = 1.0
        stopX.addSubview(imagView)
        self.view.addSubview(stopX)
    }
    func makeAutoLayout(){
        let tabHeight = tabBarController?.tabBar.frame.size.height
        self.stop2.translatesAutoresizingMaskIntoConstraints = false
        self.start2.translatesAutoresizingMaskIntoConstraints = false
        self.start2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        self.start2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10 - tabHeight! ).isActive = true
        self.start2.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        self.start2.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        self.stop2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        self.stop2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10 - tabHeight!).isActive = true
        self.stop2.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
        self.stop2.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
    }
    
    
    var timer : Timer!
    var startTime = Date()
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var fire: UIImageView!
    var stop2 = UIButton()
    var start2 = UIButton()
    var timerSecond = UILabel()
    var timerMsec = UILabel()
//    タイトルのみソースコードで設定
    var titleLabel = UILabel()
//    連続して2回目以降計測しようとするとメラメラが止まってしまうことへの対策
    var isFirst: Bool = true
    var timeDifference: Int = 0
    let tenSeconds:Double = Double(timeNumberStatic)
    let hundredSeconds:Double = 100
//    timeNumberStatic秒からの差分を計算するメソッド
    func calculate(second:Double) -> Double{
        if second >= self.tenSeconds {
            return second - self.tenSeconds
        }
        return Double(timeNumberStatic) - second
    }
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(Double.pi) / 180.0
      }
    func vibrated(view: UIView) {
        if isFirst{
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.15
            animation.fromValue = degreesToRadians(degrees: 5.0)
            animation.toValue = degreesToRadians(degrees: -5.0)
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            view.layer.add(animation, forKey: "VibrateAnimationKey")
            self.isFirst = false
        }
        return
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

extension FirstController {
    func showToast(){
//        self.viewではなく、self.tabBarController.viewであることに注意
//        selfの子にtabBarContrllerがあり、その上にスナックバーを表示させたいため。
        Toast().show(parentView: (self.tabBarController?.view)!, text: "左下にある丸いボタンをタップしてみよう！\n\(timeNumberStatic)秒たったら、右下のボタンをタップして止めてね！")
    }
}
