//
//  WorldScoreViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/01.
//

import UIKit

class WorldScoreViewController: UIViewController {
    var segmentControl:UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let navBar = UINavigationBar()
        //xとyで位置を、widthとheightで幅と高さを指定する
        let height = self.view.safeAreaInsets.top + 20
        navBar.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: 44)
        //ナビゲーションアイテムのタイトルを設定
        let navItem : UINavigationItem = UINavigationItem(title: "世界の記録")
        //ナビゲーションバー右のボタンを設定
        navItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goBack))
        
        //ナビゲーションバーにアイテムを追加
        navBar.pushItem(navItem, animated: true)
        //Viewにナビゲーションバーを追加(ナビゲーションバーの高さを）
        let segmentHeight = height + 44
        var myView = UIView(frame: CGRect(x: 0, y: segmentHeight, width: self.view.frame.width, height: 100))
        self.view.addSubview(myView)
        self.makeColorLayer(number: backgroundColorNumberStatic, viewT:myView)
        let items = ["秒あて","反射神経"]
        self.segmentControl = UISegmentedControl(items: items)
        self.segmentControl.frame = CGRect(x: 0, y: 80, width: 200, height: 30)
//        SegmentedControlのテキストカラーの設定の仕方謎...
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for:.normal)
        self.segmentControl.center = myView.center
        self.segmentControl.selectedSegmentTintColor = UIColor.init(red: 65 / 255, green: 184 / 255, blue: 131 / 255, alpha: 1)
        self.segmentControl.backgroundColor = UIColor.init(red: 53 / 255, green: 74 / 255, blue: 93 / 255, alpha: 1)
        segmentControl.tintColor = .white
        self.segmentControl.selectedSegmentIndex = 0
        self.segmentControl.rx.selectedSegmentIndex.subscribe(onNext:{ [self] index in
//            どうしようかな悩み中。
            switch index {
            case 0:
                self.view.bringSubviewToFront(ts.view)
            case 1:
                self.view.bringSubviewToFront(rt.view)
            default:
                print("")
            }
        })
        self.view.addSubview(self.segmentControl!)
        self.view.addSubview(navBar)        
        self.view.addSubview(rt.view)
        self.view.addSubview(ts.view)
    }
    func makeColorLayer(number:Int,viewT:UIView){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = CGRect(x: 0, y: 0, width: viewT.frame.width, height: viewT.frame.height)
        viewT.layer.insertSublayer(layer!, at: 1)
    }

    let rt = ResponseTimeViewController()
    let ts = TenSecondsTimeViewController()
//    override func viewDidLayoutSubviews() {
//        self.segmentControl?.translatesAutoresizingMaskIntoConstraints = false
//        self.segmentControl?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
//        self.segmentControl?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20 + (self.navigationController?.navigationBar.frame.size.height ?? 14 / 2)).isActive = true
//        self.segmentControl?.widthAnchor.constraint(equalToConstant: 120).isActive = true
//    }
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
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
