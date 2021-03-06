//
//  JustGetMiddleViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/17.
//

import RealmSwift
import UIKit
import Alamofire

var justGetMiddleIdStatic:Int?
class JustGetMiddleViewController: UIViewController,UITextFieldDelegate {
    var imageView = UIImageView()
    func makeImageView(imageview:UIImageView){
        imageview.frame = CGRect(x: self.view.bounds.width/2 - 50, y: self.view.bounds.height/2 - 100 , width: 100, height: 100)
//        アイコンが円の中心になるように、プロパティを上書きする
        imageview.center.x = self.view.center.x
        imageview.center.y = self.view.center.y - 100
        imageview.image = UIImage(named: (Setting.icon.init(rawValue: iconNumberStatic)?.getName())!)
        imageview.isHidden = true
    }
    var isFirst:Bool = true
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
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(Double.pi) / 180.0
      }
    
    override func viewWillLayoutSubviews() {
        isFirst = true
    }
    var isOn:Bool?
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
//        makeStartStop(button:self.startStop)
        self.view.addSubview(self.startStop)
//        self.startStop.addTarget(self, action: #selector(tapStart), for: UIControl.Event.touchUpInside)
        makeReset(resetButton: self.resetButton)
        self.view.addSubview(resetButton)
        self.resetButton.addTarget(self, action: #selector(resetData), for: UIControl.Event.touchUpInside)
        
        makeCircle(shapeLayer: self.shapeLayer)
        self.view.layer.addSublayer(self.shapeLayer)
        makeIngicatorCircle(shapeLayer: self.shapeLayerIngicator)
        self.view.layer.addSublayer(self.shapeLayerIngicator)
        makeImageView(imageview: self.imageView)
        self.view.addSubview(imageView)
        
        makeMessage()
        makeMessagefirst()
        // Do any additional setup after loading the view.
        makeColorLayer(number: backgroundColorNumberStatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Toast().show(parentView: (self.view)!, text: "丸いボタンをタップしてみよう！\nゲージが進んだら、ちょうどでタップして止めてね！")
            }
    }
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        return layer
}()
    let shapeLayerIngicator: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Setting.color(rawValue: colorNumberStatic)!.getUIColor().cgColor
        layer.lineWidth = 2
        return layer
}()
    var isFirst2:Bool?
    override func viewDidAppear(_ animated: Bool) {
        isFirst2 = true
    }
    var startStop = UIButton()
    var resetButton = UIButton()
    @objc func resetData(){
        if (isFirst2!){
            startCircling(shapelayer: self.shapeLayer)
            vibrated(view: self.imageView)
            isFirst2 = false
            self.message.isHidden = false
            self.imageView.isHidden = false
            self.messageFirst.isHidden = true
        }else {
//            CountTimeと同じようにするとすれば、stopCirclingを使うべきだが、今回はストップボタンを押したタイミングで、インジケータが止まって欲しい。
//            stopCirclingでは、インジケータが1まで行ってしまうので、挙動としてあまり良くない。まあ多分アニメーションを作り直せば良いと思うが、よくわかっていないので、このままにする。
            pauseAnimation(layer: self.shapeLayer)
            let stroke = self.shapeLayer.presentation()?.strokeEnd
            let alert = UIAlertController(title: "結果発表", message: "名前を入れてね！", preferredStyle: .alert)
            alert.addTextField { (textFiled) in
                textFiled.delegate = self
            }
            alert.addAction(UIAlertAction(title: "結果を見に行く!", style: .default, handler: { [self] (action) in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(identifier: "JustGetMiddleResultsViewController") as? JustGetMiddleResultsViewController
                viewController?.modalPresentationStyle = .fullScreen
//                後でメソッド化すること
                let realm = try! Realm()
                let record = JustGetMiddleResult()
                justGetMiddleIdStatic = record.id
                record.name = alert.textFields![0].text!
                record.date = moldTime(date: record.dateNoMold)
                let diff = self.calcTime2(goal: goalUse!, end: stroke!)
                record.difference = diff
                record.end = Double(stroke!)
                record.goal = Double(self.goalUse!)
                try! realm.write{
                    realm.add(record)
                }
                self.saveData(date: Date(), timeDifference: diff)
                self.present(viewController!, animated: true, completion: nil);
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
            "difference":timeDifference]
        Alamofire.request("http://springbootawscounttimerecords-env.eba-mvju5xjx.ap-northeast-1.elasticbeanstalk.com/justgetmiddle/list",method: .post,parameters: paramters,encoding: JSONEncoding.default,headers: nil).responseString{(response) in
        }
    }
    
    var message:UILabel!
    var messageFirst:UILabel!
    func makeMessage(){
        self.message = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.message.center.x = self.view.center.x
        self.message.center.y = self.view.center.y
        self.message.font = UIFont.systemFont(ofSize: 20)
        self.message.textAlignment = NSTextAlignment.center
        self.message.text = "今日は飲むぞ〜！!"
        self.message.textColor = .white
        self.message.isHidden = true
        self.view.addSubview(self.message)
    }
    func makeMessagefirst(){
        self.messageFirst = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: 200))
        self.messageFirst.center.x = self.view.center.x
        self.messageFirst.center.y = self.view.center.y - 100
        self.messageFirst.textAlignment = NSTextAlignment.center
        self.messageFirst.textColor = .white
        self.messageFirst.text = "インジケータが進むよ！\nちょうどのところで止めて、反射神経を確かめよう！"
//        改行するには、numberOfLines = 0にする必要があるらしい。なんか、tableViewでもnumberOfLinesを見たきたする
        self.messageFirst.numberOfLines = 0
        self.view.addSubview(self.messageFirst)
    }
    
    func moldTime(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: date)
    }
    func calcTime(goal:CGFloat,end:CGFloat) -> String{
        if goal >= end {
            return String(roundTime(time: Double(goal - end) * 100))
        }else {
            return String(roundTime(time:Double(end - goal) * 100))
        }
    }
    func calcTime2(goal:CGFloat,end:CGFloat) -> Double{
        if goal >= end {
            return roundTime(time: Double(goal - end) * 100)
        }else {
            return
                roundTime(time:Double(end - goal) * 100)
        }
    }
    func roundTime(time:Double) -> Double{
        return round(time * 100000) / 100000
    }

    func makeAutoLayout(startStop:UIButton,resetButton:UIButton){
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func makeCircle(shapeLayer shapelayer:CAShapeLayer){
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100) // 中心座標
        let radius = shapelayer.bounds.size.width / 3.0  // 半径
        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapelayer.path = path.cgPath
    }
    var goal:Double?
//    0 - 1 の間に正規化（Double.piとかめんどくさかったので。）
    var goalUse:CGFloat?
    func makeIngicatorCircle(shapeLayer shapelayer:CAShapeLayer){
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100) // 中心座標
        let radius = shapelayer.bounds.size.width / 3.3  // 半径
        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
        goal = Double.random(in: 0.0..<2.0)
        let endAngle = startAngle +  CGFloat((goal!)) * CGFloat(Double.pi)  // 終了点(開始点から一周)
        goalUse = (endAngle - startAngle) / CGFloat(2 * Double.pi)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapelayer.path = path.cgPath
    }
    func makeReset(resetButton:UIButton){
//        resetButton.frame = CGRect(x:0,y:0,width:300, height: 300)
        resetButton.backgroundColor = .clear
        resetButton.setTitleColor(Setting.color(rawValue: colorNumberStatic)!.getUIColor(), for: .normal)
        resetButton.tintColor = Setting.color(rawValue: colorNumberStatic)!.getUIColor()
        resetButton.layer.borderColor = Setting.color(rawValue: colorNumberStatic)!.getUIColor().cgColor
        resetButton.layer.borderWidth = CGFloat(buttonWidthNumberStatic)
        resetButton.layer.borderColor = Setting.color.init(rawValue: buttonColorNumberStatic)?.getUIColor().cgColor
        resetButton.layer.cornerRadius = 50
        resetButton.backgroundColor = .white
        let imageView = UIImageView();
        let image = UIImage(named:"cheer")
        imageView.image = image
//        UIButtonの真ん中に配置したい。下の固定値はたまたまうまくいっただけで汎用性がない
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
        resetButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        resetButton.addSubview(imageView)
    }
    override func viewDidLayoutSubviews() {
        makeAutoLayout(startStop: self.startStop, resetButton: self.resetButton)
    }
    func stopCircling(_ layer:CALayer){
        layer.removeAllAnimations()
    }
    func startCircling(shapelayer:CAShapeLayer){
        shapelayer.strokeColor = Setting.color(rawValue: colorNumberStatic)!.getUIColor().cgColor
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        let randomInt = Int.random(in: 1...8)
        switch randomInt {
        case 1:
            anim.duration = 0.5
        case 2:
            anim.duration = 0.6
        case 3:
            anim.duration = 0.7
        case 4:
            anim.duration = 0.8
        case 5:
            anim.duration = 0.9
        case 6:
            anim.duration = 1.0
        case 7:
            anim.duration = 1.1
        case 8:
            anim.duration = 1.2
        default:
            anim.duration = 1.3
        }
        anim.fromValue = 0.0
        anim.toValue = 1.0
        shapelayer.add(anim, forKey: "circleAnim")
//        isOn = true
    }
    func pauseAnimation(layer:CAShapeLayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeAnimation(layer:CAShapeLayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
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
