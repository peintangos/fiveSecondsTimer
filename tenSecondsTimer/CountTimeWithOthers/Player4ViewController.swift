//
//  Player4ViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/18.
//

import UIKit
import RealmSwift

class Player4ViewController: UIViewController, UITextFieldDelegate {
    var name:String?
//    var playerNumber:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startButton = UIButton()
        self.stopButton = UIButton()
        self.view.addSubview(self.stopButton!)
        self.view.addSubview(self.startButton!)
        makeColorLayer(number: backgroundColorNumberStatic)
        player1.makeMessagefirst(view:self.view)
    }
    var messageFirst:UILabel!
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
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
        layer.strokeColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor().cgColor
        layer.lineWidth = 2
        return layer
}()
    var player1 = Player1ViewController()
    override func viewDidLayoutSubviews() {
        player1.makeStartTimer(button:self.startButton!, viewSelf: self.view)
        player1.makeStopTimer(button:self.stopButton!,viewSelf: self.view)
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
        self.view.addSubview(self.stopButton!)
        self.view.addSubview(self.startButton!)
        self.view.addSubview(player1.makeTitle(name:"\(name!)の挑戦です"))
        self.startButton!.addTarget(self, action: #selector(tapStart(_:)), for: UIControl.Event.touchUpInside)
        self.stopButton!.addTarget(self, action: #selector(tapStop(_:)), for: UIControl.Event.touchUpInside)
    }
    @objc func tapStart(_ sender:UIButton){
        startTime = Date()
        player1.startCircling(shapelayer:self.shapeLayer)
        player1.changeButtonSetting(stopbutton: self.stopButton!,startbutton: self.startButton!, messageNew: self.message, imageview: self.imageView)
        player1.noDisplay(timerSec:self.timerSec, timerMill:self.timerMill)
        player1.vibrated(view: self.imageView)
        self.startButton?.alpha = 0.5
        self.stopButton?.alpha = 1
    }
    @objc func tapStop(_ sender:UIButton){
        count(starttime: self.startTime)
        player1.stopCircling(self.shapeLayer)
        player1.calculate(self.startTime)
//        player1.makeAlertController()
        player1.stopBeer(imageView:self.imageView)
        player1.display(timersec: self.timerSec, timermill: self.timerMill, messageNew: self.message)
        calc(startTime: self.startTime)
        saveResults4(timerMill: self.timerMill, timerSecond: self.timerSec, timerSecDouble: self.timserSecDouble!)
        if ( playerNumberAll == 4){
            let result = self.storyboard?.instantiateViewController(withIdentifier: "ResultsPlayWithOthers") as!ResultsPlayWithOthersViewController
            result.modalPresentationStyle = .fullScreen
//            result.playerNumber = self.playerNumber
            self.present(result, animated: true, completion: nil)
        }else{
            self.goNext(playerNumber: playerNumberAll!)
        }
    }
    func goNext(playerNumber:Int){
        if isSaved!{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyBoard.instantiateViewController(withIdentifier: "Player5ViewController") as! Player5ViewController
            nextView.name = "player5"
            nextView.modalPresentationStyle = .fullScreen
            self.present(nextView, animated: true, completion: nil)
            
        }else {
            let nav = UIAlertController(title: "五人目の名前を入力してね", message:nil, preferredStyle: .alert)
            nav.addTextField(configurationHandler: {(textField) in
                textField.delegate = self
            })
            nav.addAction(UIAlertAction(title: "次へ", style: UIAlertAction.Style.default, handler: {(action) in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyBoard.instantiateViewController(withIdentifier: "Player5ViewController") as! Player5ViewController
                nextView.name = nav.textFields?[0].text!
                nextView.modalPresentationStyle = .fullScreen
                self.present(nextView, animated: true, completion: nil)
            }))
            self.present(nav, animated: true, completion: nil)
        }
    }
    func count(starttime:Date){
        let currentTime = Date().timeIntervalSince(starttime)
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        self.timserSecDouble = (Double)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
//        let msecDouble = (Double)((currentTime - floor(currentTime))*100)
        // %02d： ２桁表示、0で埋める
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)
            
        self.timerSec.text = sSecond
        self.timerMill.text = sMsec
    }
    
        override func viewWillLayoutSubviews() {
            player1.makeCircle(shapeLayer: self.shapeLayer)
            self.view.layer.addSublayer(self.shapeLayer)
        }
        func calc(startTime:Date){
            let currentTime = Date().timeIntervalSince(startTime)
            self.timserSecDouble = (Double)(fmod(currentTime, 60))
        }
        func saveResults4(timerMill:UILabel,timerSecond:UILabel,timerSecDouble:Double){
            let realm = try! Realm()
    //        登録したいのにエラーが出る、、
            let record = EachRecord.create(realm: realm)
            record.name = name!
            record.timerSecond = timerSecond.text!
            record.timerMill = timerMill.text!
            record.orderNum = 2
            record.timeDifference = player1.calculate(second:timerSecDouble)
            record.orderAll = orderAllNew!
            try! realm.write{
                realm.add(record)
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
