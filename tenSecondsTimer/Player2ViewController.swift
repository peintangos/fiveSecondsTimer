//
//  Player2ViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/04.
//

import UIKit
import RealmSwift

class Player2ViewController: UIViewController {
    var name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var timerSec = UILabel()
    var timserSecDouble:Double?
    var timerMill = UILabel()
    var message = UILabel()
    var imageView = UIImageView()
    var isFirst:Bool = true
    var startButton:UIButton?
    var stopButton:UIButton?
    var startTime = Date()
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = 2
        return layer
}()
    var player1 = Player1ViewController()
    override func viewDidLayoutSubviews() {
        player1.makeTimerSec(timersec: self.timerSec)
        player1.makeTimerMill(timermill: self.timerMill)
        player1.makeMessage(messageNew: self.message, imageView:self.imageView)
        player1.makeImageView(imageview: self.imageView)
        isFirst = true
        self.view.addSubview(timerSec)
        self.view.addSubview(timerMill)
        self.view.addSubview(message)
        self.view.addSubview(imageView)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.startButton = player1.makeStartTimer()
        self.stopButton = player1.makeStopTimer()
        self.view.addSubview(self.stopButton!)
        self.view.addSubview(self.startButton!)
        self.view.addSubview(player1.makeTitle(name:"\(name!)の挑戦です"))
        self.startButton!.addTarget(self, action: #selector(tapStart(_:)), for: UIControl.Event.touchUpInside)
        self.stopButton!.addTarget(self, action: #selector(tapStop(_:)), for: UIControl.Event.touchUpInside)
    }
    @objc func tapStart(_ sender:UIButton){
        print("33")
        startTime = Date()
        player1.startCircling(shapelayer:self.shapeLayer)
        player1.changeButtonSetting(stopbutton: self.stopButton!,startbutton: self.startButton!, messageNew: self.message, imageview: self.imageView)
        player1.noDisplay(timerSec:self.timerSec, timerMill:self.timerMill)
        player1.vibrated(view: self.imageView)
    }
    @objc func tapStop(_ sender:UIButton){
        player1.countTime(startTime: self.startTime, timerSec: self.timerSec, timerMill: self.timerMill)
        player1.stopCircling(self.shapeLayer)
        player1.calculate(self.startTime)
        player1.makeAlertController()
        player1.stopBeer(imageView:self.imageView)
        player1.display(timersec: self.timerSec, timermill: self.timerMill, messageNew: self.message)
        calc(startTime: self.startTime)
        saveResults(timerMill: self.timerMill, timerSecond: self.timerSec, timerSecDouble: self.timserSecDouble!)
//        コードのみで画面遷移をする方法（ググった。）
        let player2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsPlayWithOthers") as!ResultsPlayWithOthersViewController
        self.present(player2ViewController, animated: true, completion: nil)
        
        print("結果発表に移3")
    }
    
    override func viewWillLayoutSubviews() {
        player1.makeCircle(shapeLayer: self.shapeLayer)
        self.view.layer.addSublayer(self.shapeLayer)
    }
    func calc(startTime:Date){
        var currentTime = Date().timeIntervalSince(startTime)
        self.timserSecDouble = (Double)(fmod(currentTime, 60))
    }
    func saveResults(timerMill:UILabel,timerSecond:UILabel,timerSecDouble:Double){
        let realm = try! Realm()
//        登録したいのにエラーが出る、、
        let record = EachRecord.create(realm: realm)
        record.name = name!
        record.timerSecond = timerSecond.text!
        record.timerMill = timerMill.text!
        record.orderNum = 2
        record.timeDifference = player1.calculate(second:timerSecDouble)
        record.orderAll = orderAllNew!
        print("player2のorderAll\(record.orderAll)")
        try! realm.write{
            realm.add(record)
        }
    }

//    こいつもplayer1のメソッドで追加しようとすると、表示されない。同じインスタンスであれば共有しようとするからではないかという仮説
//    しかい、ボタンそのものは表示できてる
//    func makeCircle(){
//        let center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2 - 50) // 中心座標
//        let radius = shapeLayer.bounds.size.width / 3.0  // 半径
//        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
//        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
//        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//        shapeLayer.path = path.cgPath
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
