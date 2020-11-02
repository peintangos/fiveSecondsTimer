//
//  Player1ViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/04.
//

import UIKit
import RealmSwift

let widthTimerSec = 100
let heightTimerSec = 100
let widthMessage = 250
let heightMessage = 100
let imageWidth = 100
let imageHeight = 100
class Player1ViewController: UIViewController, UITextFieldDelegate {
    var name:String?
//    var playerNumber:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.startButton = makeStartTimer()
        self.stopButton = makeStopTimer()
        self.view.addSubview(self.stopButton!)
        self.view.addSubview(self.startButton!)
        self.view.addSubview(makeTitle(name:"\(name ?? "ハリー")の挑戦です"))
        self.startButton!.addTarget(self, action: #selector(tapStart(_:)), for: UIControl.Event.touchUpInside)
        self.stopButton!.addTarget(self, action: #selector(tapStop(_:)), for: UIControl.Event.touchUpInside)
        makeColorLayer()
    }
    func makeColorLayer(){
        var layer = CAGradientLayer()
        layer.frame = self.view.frame
        layer.colors = [UIColor.init(red: 205 / 250, green: 156 / 250, blue: 242 / 250, alpha: 1).cgColor,UIColor.init(red: 246 / 255, green: 243 / 255, blue: 255 / 255, alpha: 1).cgColor]
        layer.locations = [0.1,0.7]
        layer.startPoint = CGPoint(x: 0.3, y: 0)
        layer.endPoint = CGPoint(x: 0.2, y: 1)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    
    var timerSec = UILabel()
    var timerMill = UILabel()
    var timerSecDouble:Double = 0.0
    var message = UILabel()
    var imageView = UIImageView()
    var isFirst:Bool = true
    var startButton:UIButton?
    var stopButton:UIButton?
    var startTime = Date()

    func saveResults(timerMill:UILabel,timerSecond:UILabel,timerSecDouble:Double){
        let realm = try! Realm()
//        登録したいのにエラーが出る、、
        let record = EachRecord.create(realm: realm)
        record.name = name ?? "player1"
        record.timerSecond = self.timerSec.text
        record.timerMill = self.timerMill.text
        record.timeDifference = self.calculate(second:timerSecDouble)
        record.orderAll = Int.random(in: 1..<100000)
        orderAllNew = record.orderAll
        try! realm.write{
            realm.add(record)
        }
    }
    func calculate(second:Double) -> Double{
        if second >= Double(timeNumberStatic) {
            return second - Double(timeNumberStatic)
        }
        return Double(timeNumberStatic) - second
    }
    
    func makeTimerSec(timersec:UILabel){
        timersec.text = "00"
        timersec.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2 - widthTimerSec, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
//        timerSec.backgroundColor = .orange
        timersec.textAlignment = NSTextAlignment.center
        timersec.font = UIFont.systemFont(ofSize: 40)
        timersec.textColor = .white
    }
    func makeTimerMill(timermill:UILabel){
        timermill.text = "00"
        timermill.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
        timermill.textAlignment = NSTextAlignment.center
//        timerMill.backgroundColor = .darkGray
        timermill.font = UIFont.systemFont(ofSize: 40)
        timermill.textColor = .white
        
    }
    
    func makeImageView(imageview:UIImageView){
        imageview.frame = CGRect(x: self.view.bounds.width/2 - 50, y: self.view.bounds.height/2 - 100 , width: 100, height: 100)
//        imageView.backgroundColor = .cyan
        imageview.isHidden = true
    }
    func makeMessage(messageNew:UILabel,imageView imageview:UIImageView){
        messageNew.text = "もう飲めないよ！！"
        messageNew.frame = CGRect(x: Int(UIScreen.main.bounds.width)/2 - widthMessage/2, y: Int(self.view.bounds.height)/2 , width: widthMessage, height: heightMessage)
//        message.backgroundColor = .brown
        messageNew.font = UIFont.boldSystemFont(ofSize: 20)
        messageNew.textAlignment = NSTextAlignment.center
        messageNew.textColor = .white
        messageNew.isHidden = true
        imageview.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
    }
    
    override func viewDidLayoutSubviews() {
        makeTimerSec(timersec: self.timerSec)
        makeTimerMill(timermill: self.timerMill)
        makeMessage(messageNew: self.message,imageView:self.imageView)
        makeImageView(imageview: self.imageView)
        isFirst = true
        self.view.addSubview(timerSec)
        self.view.addSubview(timerMill)
        self.view.addSubview(message)
        self.view.addSubview(imageView)
    }
    
    func addView(view:UIView){
        self.view.addSubview(view)
    }
        
    override func viewWillLayoutSubviews() {
        makeCircle(shapeLayer: self.shapeLayer)
        self.view.layer.addSublayer(self.shapeLayer)
    }

    
    //    Stopタイマーを作るメソッド
    func makeStopTimer() -> UIButton{
        var stopButton = UIButton()
        stopButton.frame = CGRect(x: self.view.bounds.width/2 + 50, y: self.view.bounds.height - 150 , width: 100, height: 100)
        stopButton.backgroundColor = UIColor.white
        stopButton.layer.cornerRadius = 50
        stopButton.isEnabled = false
        stopButton.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        stopButton.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        let image = UIImage(named: "del")
        image?.withTintColor((Setting.color.init(rawValue: colorNumberStatic + 1)?.getUIColor())!)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        stopButton.addSubview(imageView)
        stopButton.imageView?.contentMode = .scaleToFill
        stopButton.contentHorizontalAlignment = .fill
        stopButton.contentVerticalAlignment = .fill
        stopButton.alpha = 0.5
        return stopButton
    }
//    Startタイマーを作るメソッド
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height - 150 , width: 100, height: 100)
        startButton.backgroundColor = UIColor.white
        startButton.layer.cornerRadius = 50
        startButton.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        startButton.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        let imageView = UIImageView();
        let image = UIImage(named:"cheer")
        imageView.image = image
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.contentMode = .scaleToFill
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        startButton.addSubview(imageView)
        startButton.alpha = 1
        return startButton
    }
//    ワッカのアニメーションを動かす
    func makeCircle(shapeLayer shapelayer:CAShapeLayer){
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y) // 中心座標
        let radius = shapelayer.bounds.size.width / 3.0  // 半径
        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapelayer.path = path.cgPath

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
    
//    タイトルを作るメソッド
    func makeTitle(name:String) -> UILabel{
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 20)
        label.frame = CGRect(x: self.view.bounds.width/2, y: 100, width: 300, height: 70)
        label.textAlignment = NSTextAlignment.center
        label.center = CGPoint(x: myBoundSize.width/2, y:80)
        label.textColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1)
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.init(red: 215, green: 230, blue: 239, alpha: 1).cgColor
        label.layer.cornerRadius = 4.0
        return label
    }
//    StoryBoardなら、簡単に書けるけどコードだけで書くとしたら少しめんどくさいね。
    @objc func tapStart(_ sender:UIButton){
        startTime = Date()
        startCircling(shapelayer: self.shapeLayer)
        changeButtonSetting(stopbutton: self.stopButton!,startbutton:self.startButton!,messageNew: self.message,imageview: self.imageView)
        noDisplay(timerSec: timerSec, timerMill: timerMill)
        vibrated(view: self.imageView)
        self.startButton?.alpha = 0.5
        self.stopButton?.alpha = 1.0
    }
    @objc func tapStop(_ sender:UIButton){

        count(starttime: self.startTime)
        stopCircling(self.shapeLayer)
        calculate(self.startTime)
        makeAlertController()
        stopBeer(imageView: self.imageView)
        display(timersec: self.timerSec, timermill: self.timerMill, messageNew: self.message)
    }
    func changeButtonSetting(stopbutton stopbutton:UIButton,startbutton :UIButton,messageNew:UILabel,imageview imageview:UIView){
        stopbutton.isEnabled = true
        messageNew.isHidden = false
        imageview.isHidden = false
        
    }
    func count(starttime:Date){
        let currentTime = Date().timeIntervalSince(starttime)
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        self.timerSecDouble = (Double)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
//        let msecDouble = (Double)((currentTime - floor(currentTime))*100)
        // %02d： ２桁表示、0で埋める
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)
            
        self.timerSec.text = sSecond
        self.timerMill.text = sMsec

    }
    func stopBeer(imageView imageview:UIView){
        imageview.isHidden = true
    }
    
//    }
    func noDisplay(timerSec timersec:UILabel, timerMill timermil:UILabel){
        timersec.isHidden = true
        timermil.isHidden = true
    }
    func display(timersec timersec:UILabel, timermill:UILabel, messageNew messageNew:UILabel){
        timersec.isHidden = false
        timermill.isHidden = false
        messageNew.isHidden = true
    }
//
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        layer.lineWidth = 2
        return layer
}()
    func startCircling(shapelayer:CAShapeLayer){
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
        shapelayer.add(anim, forKey: "circleAnim")
    }
    func stopCircling(_ layer:CALayer){
        layer.removeAllAnimations()
    }
    func calculate(_ time:Date){
        let currentTime = Date().timeIntervalSince(time)
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
//        その後この変数を使わないときは、このように書ける！
        _ = (Double)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
//        let msecDouble = (Double)((currentTime - floor(currentTime))*100)

        // %02d： ２桁表示、0で埋める
        //        その後この変数を使わないときは、このように書ける！
        _ = String(format:"%02d", second)
        //        その後この変数を使わないときは、このように書ける！
        _ = String(format:"%02d", msec)
//        記録をDBに書き込む
    }
    func isUserNameSaved() ->Bool{
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: "isNameSaved")
    }
    func makeAlertController(){
        if isSaved!{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let player2ViewController = storyBoard.instantiateViewController(withIdentifier: "Player2ViewController") as! Player2ViewController
            player2ViewController.name = "player2"
            self.saveResults(timerMill: self.timerMill, timerSecond: self.timerSec,timerSecDouble: self.timerSecDouble)
            self.present(player2ViewController, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "二人目の名前を入力してね", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.delegate = self
            }
            alert.addAction(UIAlertAction(title: "次へ", style: .default, handler:{ [self](action) -> Void in
                let player2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Player2ViewController") as! Player2ViewController
                player2ViewController.name = alert.textFields?[0].text!
                self.saveResults(timerMill: self.timerMill, timerSecond: self.timerSec,timerSecDouble: self.timerSecDouble)
                self.present(player2ViewController, animated: true, completion: nil)
            })
            
            )

            self.present(alert, animated: true, completion: nil)
            
        }

        
    }
}
