//
//  MyTabBarController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/03.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UITabBar.appearance().tintColor = UIColor.orange
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        タブを切り替えた時に、データを更新する。これがないと追加したデータが更新されなかった。
//        titleは、アトリビュートインスペクタ
        if item.title == "records"{
            item.badgeValue = nil
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
