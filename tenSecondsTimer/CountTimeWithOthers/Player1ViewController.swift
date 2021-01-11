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
//        self.startButton = makeStartTimer()
        self.modalPresentationStyle = .fullScreen
        self.startButton = UIButton()
//        self.stopButton = makeStopTimer()
        self.stopButton = UIButton()
        self.view.addSubview(self.stopButton!)
        self.view.addSubview(self.startButton!)
        makeMessagefirst(view:self.view)
        self.view.addSubview(makeTitle(name:"\(name ?? "ハリー")の挑戦です"))
        self.startButton!.addTarget(self, action: #selector(tapStart(_:)), for: UIControl.Event.touchUpInside)
        self.stopButton!.addTarget(self, action: #selector(tapStop(_:)), for: UIControl.Event.touchUpInside)
        makeColorLayer(number: backgroundColorNumberStatic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Toast().show(parentView: (self.view)!, text: "左下にある丸いボタンをタップしてみよう！\n\(timeNumberStatic)秒たったら、右下のボタンをタップして止めてね！")
                }
    }
    var messageFirst:UILabel!
    func makeMessagefirst(view:UIView){
        self.messageFirst = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        self.messageFirst.center.x = self.view.center.x
        self.messageFirst.center.y = self.view.center.y - 30
        self.messageFirst.textAlignment = NSTextAlignment.center
        self.messageFirst.textColor = .white
        self.messageFirst.font = UIFont.systemFont(ofSize: 20)
        self.messageFirst.text = "\(timeNumberStatic)秒間ストップウォッチだよ！\nインジケータに惑わされないように注意しよう！"
//        改行するには、numberOfLines = 0にする必要があるらしい。なんか、tableViewでもnumberOfLinesを見たきたする
        self.messageFirst.numberOfLines = 0
        view.addSubview(self.messageFirst)
    }
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
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
        timersec.center.y = self.view.center.y - 30
        timersec.center.x = self.view.center.x - 40
        timersec.isHidden = true
    }
    func makeTimerMill(timermill:UILabel){
        timermill.text = "00"
        timermill.frame = CGRect(x: Int(UIScreen.main.bounds.size.width)/2, y: Int(self.view.bounds.height)/2 - heightTimerSec/2, width: widthTimerSec, height: heightTimerSec)
        timermill.textAlignment = NSTextAlignment.center
//        timerMill.backgroundColor = .darkGray
        timermill.font = UIFont.systemFont(ofSize: 40)
        timermill.textColor = .white
        timermill.center.y = self.view.center.y - 30
        timermill.center.x = self.view.center.x + 40
        timermill.isHidden = true
    }
    
    func makeImageView(imageview:UIImageView){
        imageview.frame = CGRect(x: self.view.bounds.width/2 - 50, y: self.view.bounds.height/2 - 100 , width: 100, height: 100)
//        imageView.backgroundColor = .cyan
        imageview.isHidden = true
    }
    
    func makeMessage(){
        self.message = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.message.center.x = self.view.center.x
        self.message.center.y = self.view.center.y
        self.message.font = UIFont.systemFont(ofSize: 20)
        self.message.textAlignment = NSTextAlignment.center
        self.message.text = "今日は飲むぞ〜！!"
        self.message.textColor = .white
        self.view.addSubview(self.message)
    }

    func makeMessage(messageNew:UILabel,imageView imageview:UIImageView){
        messageNew.text = "今日は飲むぞ〜！!"
        messageNew.frame = CGRect(x: Int(UIScreen.main.bounds.width)/2 - widthMessage/2, y: Int(self.view.bounds.height)/2 , width: widthMessage, height: heightMessage)
//        message.backgroundColor = .brown
        messageNew.font = UIFont.boldSystemFont(ofSize: 20)
        messageNew.textAlignment = NSTextAlignment.center
        messageNew.textColor = .white
        messageNew.isHidden = true
        imageview.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
    }
    
    override func viewDidLayoutSubviews() {
        makeStartTimer(button:self.startButton!,viewSelf:self.view)
        makeStopTimer(button:self.stopButton!,viewSelf: self.view)
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
    func makeStopTimer(button:UIButton,viewSelf:UIView){
//        セーフエリア対策色々やってみたけど、なんかモーダルだと0になるし（didLayoutSubViewで撮ったっとしても）
//        固定値で間を開けるしかない気がする
//        print(viewSelf.safeAreaInsets.bottom)
        button.frame = CGRect(x: self.view.bounds.width/2 + 50, y: self.view.bounds.height - 170 - safeAreaTopFirstView!, width: 100, height: 100)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 50
        button.isEnabled = false
        button.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        button.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        let image = UIImage(named: "del")
        image?.withTintColor((Setting.color.init(rawValue: colorNumberStatic + 1)?.getUIColor())!)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        button.addSubview(imageView)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.alpha = 0.5
    }
//    Startタイマーを作るメソッド
    func makeStartTimer(button:UIButton,viewSelf:UIView){
        print(viewSelf.safeAreaInsets.top)
        button.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height - 170 - safeAreaTopFirstView!, width: 100, height: 100)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 50
        button.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        button.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        let imageView = UIImageView();
        let image = UIImage(named:"cheer")
        imageView.image = image
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.contentMode = .scaleToFill
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        button.addSubview(imageView)
        button.alpha = 1
    }
//    ワッカのアニメーションを動かす
    func makeCircle(shapeLayer shapelayer:CAShapeLayer){
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y - 30) // 中心座標
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
        label.frame = CGRect(x: self.view.bounds.width/2, y: 10, width: 300, height: 70)
        label.textAlignment = NSTextAlignment.center
        label.center = CGPoint(x: myBoundSize.width/2, y:60 + safeAreaTopFirstView!)
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
        self.messageFirst.isHidden = true
    }
    @objc func tapStop(_ sender:UIButton){

        count(starttime: self.startTime)
        stopCircling(self.shapeLayer)
        calculate(self.startTime)
        makeAlertController()
        stopBeer(imageView: self.imageView)
        display(timersec: self.timerSec, timermill: self.timerMill, messageNew: self.message)
    }
    func changeButtonSetting(stopbutton:UIButton,startbutton :UIButton,messageNew:UILabel,imageview:UIView){
        stopbutton.isEnabled = true
        messageNew.isHidden = false
        imageview.isHidden = false
        messageFirst.isHidden = true
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
    func display(timersec timersec:UILabel, timermill:UILabel, messageNew:UILabel){
//        timersec.isHidden = false
//        timermill.isHidden = false
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
            anim.duration = 2.0
        case 3:
            anim.duration = 3.0
        case 4:
            anim.duration = 4
        default:
            anim.duration = 5
            
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
        if isSaved{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let player2ViewController = storyBoard.instantiateViewController(withIdentifier: "Player2ViewController") as! Player2ViewController
            player2ViewController.name = "player2"
            player2ViewController.modalPresentationStyle = .fullScreen
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
