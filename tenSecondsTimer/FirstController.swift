//
//  FirstController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
import RealmSwift

//　　画面サイズの定数
let myBoundSize: CGSize = UIScreen.main.bounds.size
class FirstController: UIViewController, UITextFieldDelegate {
    func makeTimerSec(timersec:UILabel){
        timersec.text = "00"
        timersec.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2 - widthTimerSec, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
//        timerSec.backgroundColor = .orange
        timersec.textAlignment = NSTextAlignment.center
        timersec.font = UIFont.systemFont(ofSize: 40)
        timersec.textColor = .white
        self.view.addSubview(timersec)
    }
    
    func makeTimerMill(timermill:UILabel){
        timermill.text = "00"
        timermill.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
        timermill.textAlignment = NSTextAlignment.center
        //        timerMill.backgroundColor = .darkGray
        timermill.font = UIFont.systemFont(ofSize: 40)
        timermill.textColor = .white
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
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = 2
        return layer
}()
    let widthTimerSec = 100
    let heightTimerSec = 100

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewWillAppear(_ animated: Bool) {
//        //        円形のサークルの座標を決定し、アニメーションが始まる位置と終わる位置を決定。viewに追加
//
//        //        self.view.boundsにアクセスできるタイミングがここなので、ここで初期化している
//        shapeLayer.frame = CGRect(x: 0, y: 0, width:Double(self.view.bounds.width), height: Double(self.view.bounds.height))
//        let hankei = self.shapeLayer.bounds.size.width / 2.5
////        中心座標が、少し下目なので、半径/4くらいだけ上にずらす。
//        let center = CGPoint(x: self.view.center.x, y: self.view.center.y - hankei/4) // 中心座標
//        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
//        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
//        let path = UIBezierPath(arcCenter: center, radius: hankei, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//        self.shapeLayer.path = path.cgPath
////        self.shapeLayer.backgroundColor = UIColor.orange.cgColor
////        self.view.backgroundColor = UIColor.green
                self.view.layer.addSublayer(self.shapeLayer)
                
                timerSecond.text = "00"
                timerMsec.text = "00"
        //        円形のサークル内のメッセージを作成
        top.frame.size = CGSize(width: 200, height: 20)
        top.center = CGPoint(x: 230, y: 230)
        top.text = "5秒で止めれるかな？"
        top.textColor = UIColor.gray
        top.isHidden = true

        //        スタートボタンを円形に
                start.layer.cornerRadius = 40

        //        ストップボタンを円形に
                stop.layer.cornerRadius = 40
                stop.isEnabled = false

        //        炎アイコンを中心に設定し、メラメラするように設定
                fire.center = CGPoint(x: self.view.bounds.size.width/2.0, y: self.view.bounds.height/2.0)
                fire.isHidden = true
                vibrated(view: fire)

                print(Realm.Configuration.defaultConfiguration.fileURL!)
                
                self.isFirst = true
                
        //        タイトルラベルを作成し、追加
                self.titleLabel.text = "5SecondsTimer"
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
    func setTitle(label:UILabel){
        
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        makeTimerSec(timersec: self.timerSecond)
        makeTimerMill(timermill: self.timerMsec)
        makeCircle(shapeLayer: self.shapeLayer)
        
    }
    
    
    var timer : Timer!
    var startTime = Date()
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var fire: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var start: UIButton!
    var timerSecond = UILabel()
    var timerMsec = UILabel()
//    タイトルのみソースコードで設定
    var titleLabel = UILabel()
//    連続して2回目以降計測しようとするとメラメラが止まってしまうことへの対策
    var isFirst: Bool = true
    var timeDifference: Int = 0
    let tenSeconds:Double = 5
    let hundredSeconds:Double = 100
    @IBAction func startTimer(_ sender: Any) {
//        ボタンの表示/非表示、Enable/Disableを制御
        self.stop.isEnabled = true
        self.start.isEnabled = false
        self.timerSecond.isHidden = true
        self.timerMsec.isHidden = true
        fire.isHidden = false
        top.isHidden = false
//        計測開始
        startTime = Date()
        
//         アニメーション開始
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
//    5秒からの差分を計算するメソッド
    func calculate(second:Double) -> Double{
        if second >= self.tenSeconds {
            return second - self.tenSeconds
        }
        return Double(5) - second
    }
    
    @IBAction func stopTimer(_ sender: Any) {
//        Disable/Enableを制御
        self.stop.isEnabled = false
        self.start.isEnabled = true
//        表示/非表示の制御
        self.top.isHidden = true
        self.fire.isHidden = true
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
            alertInput.addAction(UIAlertAction(title: "登録する", style: .default, handler: { (action) in
//                DBに登録
                let realm = try! Realm()
                let record = Record()
                record.date = Date()
                record.name = alertInput.textFields?[0].text!
                record.timerSecond = self.timerSecond.text!
                record.timerMsec = self.timerMsec.text!
                record.result = self.timerSecond.text! + self.timerMsec.text!
                record.timeDifference = self.calculate(second: secondDouble)
                try! realm.write{
                    realm.add(record)
                }
//                登録した場合のみ、バッチをつける
                self.tabBarController?.tabBar.items?[1].badgeValue = "New"
                self.tabBarController?.tabBar.items?[1].badgeColor = UIColor.orange
            }))
//            セカンドコントローラをアップデートする（これ必要かわからん）
            let secondController = SecondController()
            secondController.update()
            
            self.present(alertInput, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "記録を見にいく!", style: .default, handler: {(action) -> Void in
//            なんかわからないけど、ググったら出てきた笑
//            タブを切り替える方法ぽい
            let UINavigationController = self.tabBarController?.viewControllers?[1];
            self.tabBarController?.selectedViewController = UINavigationController;
        }))
        alert.addAction(UIAlertAction(title: "もう一回挑戦する!", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
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
