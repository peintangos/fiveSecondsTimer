//
//  WorldScoreViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/01.
//

import UIKit
import RxCocoa
import RxSwift

var safeAreaTopT:CGFloat?
class WorldScoreViewController: UIViewController {
    var segmentControl:UISegmentedControl!
    var navBar:UINavigationBar!
    var myView:UIView!
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navBar = UINavigationBar()
//        navBar.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44)
        //xとyで位置を、widthとheightで幅と高さを指定する
//        下記のコードは、この状態でプリントアウトしても、0が表示された。
//        print(self.view.safeAreaInsets.top)
//        //        20はiOS11用につけただけなので、後で対策を考える。
//        let height = self.view.safeAreaInsets.top + 20
//        let height = self.view.safeAreaInsets.top + 44
        
        //        20はiOS11用につけただけなので、後で対策を考える。本当は、24ではなく44
//        navBar.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: 24)
        //ナビゲーションアイテムのタイトルを設定
        let navItem : UINavigationItem = UINavigationItem(title: "世界の記録")
        //ナビゲーションバー右のボタンを設定
        navItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goBack))
        
        //ナビゲーションバーにアイテムを追加
        navBar.pushItem(navItem, animated: true)
        //Viewにナビゲーションバーを追加(ナビゲーションバーの高さを）
//        let segmentHeight = height + 44
        self.myView = UIView()
//        self.view.addSubview(myView)
//        self.makeColorLayer(number: backgroundColorNumberStatic, viewT:myView)
        let items = ["秒あて","反射神経"]
        self.segmentControl = UISegmentedControl(items: items)
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
                print("エラー")
            }
        }).disposed(by: dispose)
//        self.view.addSubview(myView)
        self.view.addSubview(self.segmentControl!)
        self.view.addSubview(navBar)
        self.view.addSubview(rt.view)
        self.view.addSubview(ts.view)
//        self.makeColorLayer(number: backgroundColorNumberStatic, viewT: self.contentView!)
        
//        セーフエリアの色がナビゲーションの色と異なるため、Viewを追加
//        let view = UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
////        以下がデフォルトのナビゲーションエリアの色らしい
//        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0  )
//        self.view.addSubview(view)
    }
    override func viewDidLayoutSubviews(){
        self.navBar.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44)
        myView.frame = CGRect(x: 0, y: 44 + self.view.safeAreaInsets.top, width: self.view.frame.width, height: 80)
        self.segmentControl.frame.size = CGSize(width: 350, height: 30)
        self.segmentControl.center.x = self.view.center.x
        self.segmentControl.center.y = safeAreaTop + 44 + self.myView.bounds.height / 2
        if safeAreaTopT == nil {
            safeAreaTopT = safeAreaTop
        }
        
        
    }
    let dispose = DisposeBag()
    var safeAreaTop:CGFloat{
        if #available(iOS 11, *){
            return self.view.safeAreaInsets.top
        }else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        navBar.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44)
//        myView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top + 44, width: self.view.frame.width, height: 100)
//    }
    func makeColorLayer(number:Int,viewT:UIView){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = CGRect(x: 0, y: 0, width: viewT.frame.width, height: viewT.frame.height)
        viewT.layer.insertSublayer(layer!, at: 1)
    }

    let rt = ResponseTimeViewController()
    let ts = TenSecondsTimeViewController()
    
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
