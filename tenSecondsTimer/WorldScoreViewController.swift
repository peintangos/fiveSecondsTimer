//
//  WorldScoreViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/01.
//

import UIKit

class WorldScoreViewController: UIViewController {
   

    
    var segmentControl:UISegmentedControl?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let navBar = UINavigationBar()
        //xとyで位置を、widthとheightで幅と高さを指定する
        navBar.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top + 20, width: self.view.frame.width, height: 44)
        //ナビゲーションアイテムのタイトルを設定
        let navItem : UINavigationItem = UINavigationItem(title: "世界の記録")
        //ナビゲーションバー右のボタンを設定
        navItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.goBack))
        //ナビゲーションバーにアイテムを追加
        navBar.pushItem(navItem, animated: true)
        //Viewにナビゲーションバーを追加
        
        let items = ["秒あて","反射神経"]
        self.segmentControl = UISegmentedControl(items: items)
        self.segmentControl?.selectedSegmentIndex = 0
        self.segmentControl?.backgroundColor = UIColor.init(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        self.segmentControl?.rx.selectedSegmentIndex.subscribe(onNext:{ [self] index in
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
        navBar.addSubview(self.segmentControl!)
        self.view.addSubview(navBar)        
        self.view.addSubview(rt.view)
        self.view.addSubview(ts.view)
    }
    
    let rt = ResponseTimeViewController()
    let ts = TenSecondsTimeViewController()
    override func viewDidLayoutSubviews() {
        self.segmentControl?.translatesAutoresizingMaskIntoConstraints = false
        self.segmentControl?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.segmentControl?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20 + (self.navigationController?.navigationBar.frame.size.height ?? 14 / 2)).isActive = true
        self.segmentControl?.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
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
