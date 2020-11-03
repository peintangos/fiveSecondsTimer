//
//  FirstLauchingViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/03.
//

import UIKit
import RxSwift
import RxCocoa

class FirstLauchingViewController: UIViewController {
    let dispose = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        backButton.setTitle("押してね", for: .normal)
        backButton.setTitleColor(UIColor.red, for:.normal)
        backButton.rx.tap.subscribe{
            (action) in
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            var vc = storyBoard.instantiateViewController(identifier: "ViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: dispose)
        self.view.addSubview(backButton)
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
