//
//  Toast.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2021/01/10.
//

import Foundation
import UIKit
class Toast {
    var snackBarView:UILabel!
    internal func show(parentView: UIView,text:String = "デフォルト引数が入っています！"){
        snackBarView = LabelWithLayoutAutoShrink(frame: CGRect(x: 0, y: parentView.frame.height - (parentView.frame.height / 15 + safeAreaBottomFirstView!), width: parentView.frame.width, height: parentView.frame.height / 15))
        snackBarView.text = text
        snackBarView.textAlignment = NSTextAlignment.center
        snackBarView.textColor = .white
        snackBarView.adjustsFontSizeToFitWidth = true
        snackBarView.minimumScaleFactor = 0.3
        snackBarView.backgroundColor = UIColor.black
        snackBarView.alpha = 0.7
        snackBarView.layer.cornerRadius = 20
        snackBarView.numberOfLines = 0
        snackBarView.clipsToBounds = true
        parentView.addSubview(snackBarView)
        UIView.animate(withDuration: 1, delay: 4.5, options: .curveEaseOut, animations: {
            self.snackBarView.alpha = 0.0
              }, completion: { _ in
                self.snackBarView.removeFromSuperview()
              })
    }
}
//extension Toast{
//    internal func makeBackGroundLayer(number:Int,snackLabel:UILabel){
//        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
//        layer!.frame = snackLabel.frame
//        snackLabel.layer.insertSublayer(layer!, at: 1)
//    }
//}

/**
 トースト内のラベルに対して余白を設定する
 */
class LabelWithLayoutAutoShrink:UILabel{
    var padding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: padding)
        super.drawText(in: newRect)
    }
}

//UIButtonもカスタムクラスを作りたかった
class ButtonWithLayoutAutoShrink:UIButton{
    override func draw(_ rect: CGRect) {
        super.draw(rect)
// 本当は以下のようにして、カスラムクラスを作りたかったが、実際にやってみても変更されないので個々のUILabelに設定しました。
//        self.titleEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 2)
    }
}
