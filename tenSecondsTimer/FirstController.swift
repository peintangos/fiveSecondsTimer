//
//  FirstController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
import RealmSwift
let myBoundSize: CGSize = UIScreen.main.bounds.size
class FirstController: UIViewController, UITextFieldDelegate {
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = 2
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let center = CGPoint(x: 245, y: 180) // 中心座標
        let radius = self.shapeLayer.bounds.size.width / 3.0  // 半径
        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.shapeLayer.path = path.cgPath
        self.view.layer.addSublayer(self.shapeLayer)
        timerSecond.text = "00"
        timerMsec.text = "00"
        top.center = CGPoint(x: self.view.bounds.size.width/2.0  - 50, y: self.view.bounds.height/2.0 - 20)
        fire.center = CGPoint(x: self.view.bounds.size.width/2.0, y: self.view.bounds.height/2.0 - 100)
        top.text = "5秒で止めれるかな？"
        top.textColor = UIColor.gray
        top.frame.size = CGSize(width: 200, height: 20)
        top.isHidden = true
        fire.isHidden = true
        start.layer.cornerRadius = 40
        stop.layer.cornerRadius = 40
        stop.isEnabled = false
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.isFirst = true
        vibrated(view: fire)
        self.titleLabel.text = "FiveSecondsTimer"
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.frame = CGRect(x:40,y:20,width: 300,height: 70)
        self.titleLabel.center = CGPoint(x: myBoundSize.width/2, y:80)
        self.titleLabel.font = UIFont.systemFont(ofSize: 30)
        self.titleLabel.textColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1)
        self.titleLabel.layer.borderWidth = 2.0
        self.titleLabel.layer.borderColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1).cgColor
        self.titleLabel.layer.cornerRadius = 4.0
        self.view.addSubview(self.titleLabel)
        self.view.bringSubviewToFront(self.titleLabel)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 画面の中心になるようにする
        self.shapeLayer.position = CGPoint(x: myBoundSize.width/2, y: myBoundSize.height/2)
    }
    var timer : Timer!
    var startTime = Date()
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var fire: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var timerSecond: UILabel!
    @IBOutlet weak var timerMsec: UILabel!
    var titleLabel = UILabel()
    
    var isFirst: Bool = true
    var timeDifference: Int = 0
    let tenSeconds:Double = 5
    let hundredSeconds:Double = 100
    @IBAction func startTimer(_ sender: Any) {
        self.stop.isEnabled = true
        self.start.isEnabled = false
        startTime = Date()
        self.timerSecond.isHidden = true
        self.timerMsec.isHidden = true
        top.isHidden = false
        fire.isHidden = false
        
        // アニメーション開始
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
    func calculate(second:Double) -> Double{
        if second >= self.tenSeconds {
            return second - self.tenSeconds
        }
        return Double(5) - second
    }
    @IBAction func stopTimer(_ sender: Any) {
        self.stop.isEnabled = false
        self.start.isEnabled = true
        shapeLayer.removeAllAnimations()
//        shapeLayer.speed = 0
        let currentTime = Date().timeIntervalSince(startTime)
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        let secondDouble = (Double)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
        let msecDouble = (Double)((currentTime - floor(currentTime))*100)

        // %02d： ２桁表示、0で埋める
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)

        timerSecond.text = sSecond
        timerMsec.text = sMsec
        top.isHidden = true
        fire.isHidden = true
        self.timerSecond.isHidden = false
        self.timerMsec.isHidden = false
        let alert = UIAlertController(title:nil,message: nil,preferredStyle: .alert)
        alert.title = "記録は\(self.timerSecond.text!)秒\(self.timerMsec.text!)ミリでした!"
        alert.addAction(UIAlertAction(title: "記録を登録する!", style: .default, handler: {(action) -> Void in
            let alertInput = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alertInput.title = "名前を入れてね！"
            alertInput.addTextField { (textField) in
                textField.delegate = self
            }
            alertInput.addAction(UIAlertAction(title: "登録する", style: .default, handler: { (action) in
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
                self.tabBarController?.tabBar.items?[1].badgeValue = "New"
                self.tabBarController?.tabBar.items?[1].badgeColor = UIColor.orange
            }))
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
    func vibrated(vibrated:Bool, view: UIView) {
        if vibrated {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.15
            animation.fromValue = degreesToRadians(degrees: 3.0)
            animation.toValue = degreesToRadians(degrees: -3.0)
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            view.layer.add(animation, forKey: "VibrateAnimationKey")
        }
        else {
            view.layer.removeAnimation(forKey: "VibrateAnimationKey")
        }
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
