//
//  JustGetMiddleViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/17.
//

import UIKit

class JustGetMiddleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeStartStop(button:self.startStop)
        self.view.addSubview(self.startStop)
        self.startStop.addTarget(self, action: #selector(tapStart), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = 2
        return layer
}()
    var startStop = UIButton()
    func makeCircle(shapeLayer shapelayer:CAShapeLayer){
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100) // 中心座標
        let radius = shapelayer.bounds.size.width / 3.0  // 半径
        let startAngle = CGFloat(Double.pi*1.5)  // 開始点(真上)
        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)  // 終了点(開始点から一周)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapelayer.path = path.cgPath

    }
    func makeStartStop(button:UIButton){
        button.setTitle("スタート", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 150)
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 30
    }
    override func viewWillLayoutSubviews() {
        makeCircle(shapeLayer: self.shapeLayer)
        self.view.layer.addSublayer(self.shapeLayer)
    }
    var isFirst:Bool?
    @objc func tapStart(){
        if let first = isFirst {
            if first {
                makeCircle(shapeLayer: self.shapeLayer)
                startCircling(shapelayer: self.shapeLayer)
            }else {
                stopCircling(self.shapeLayer)
                self.startStop.setTitle("Start", for: .normal)
                isFirst = true
            }
        }else{
            self.startStop.setTitle("Stop", for: .normal)
            startCircling(shapelayer: self.shapeLayer)
            isFirst = false
        }
        
    }
    func stopCircling(_ layer:CALayer){
        layer.removeAllAnimations()
    }
    func startCircling(shapelayer:CAShapeLayer){
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        let randomInt = Int.random(in: 1...8)
        switch randomInt {
        case 1:
            anim.duration = 1
        case 2:
            anim.duration = 0.9
        case 3:
            anim.duration = 1
        case 4:
            anim.duration = 0.7
        case 5:
            anim.duration = 2
        case 6:
            anim.duration = 0.5
        case 7:
            anim.duration = 3
        case 8:
            anim.duration = 0.3
        default:
            anim.duration = 1.0
            
        }
        anim.fromValue = 0.0
        anim.toValue = 1.0
        shapelayer.add(anim, forKey: "circleAnim")
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
