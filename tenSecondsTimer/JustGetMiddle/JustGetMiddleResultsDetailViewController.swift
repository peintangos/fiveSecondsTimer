//
//  JustGetMiddleResultsDetailViewController.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/24.
//

/**
 ちょうど、ぴったしを狙う画面のviewで
 */
import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class JustGetMiddleResultsDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var row:Int?
    var section:Int?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "名前:\(justGetMiddleResult!.name)\nポイント：\(justGetMiddleResult!.difference)%\n日付:\( justGetMiddleResult!.date!)\nゴール:\(justGetMiddleResult!.goal)\nストローク:\(justGetMiddleResult!.end)"
        cell.textLabel?.numberOfLines = 0
        
        if section! == 0{
            cell.accessoryView = setImg2(kairi: justGetMiddleResult!.difference,row:row!)
        }else {
            cell.accessoryView = setImg(kairi: justGetMiddleResult!.difference)
        }
        return cell
    }
    func setImg(kairi:Double) ->UIImageView{
        let uiImagevView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let gold = UIImage(named: "gold")
        let diamond = UIImage(named:"diamond")
        let usual = UIImage(named: "tor")
        let kaizoku = UIImage(named: "kaizoku")
        let kubi = UIImage(named: "kubi")
        let dou = UIImage(named: "dou")
        switch kairi {
        case 0.0 ... 0.05:
            uiImagevView.image = diamond
        case 0.05 ... 0.1:
            uiImagevView.image = gold
        case 0.1 ... 0.3:
            uiImagevView.image = dou
        case 0.3 ... 1.0:
            uiImagevView.image = kubi
        case 1.0 ... 100.0:
            uiImagevView.image = kaizoku
        default:
            uiImagevView.image = usual
        }
        return uiImagevView
    }
    func setImg2(kairi:Double,row:Int) ->UIImageView{
        let uiImagevView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let gold = UIImage(named: "ichi")
        let diamond = UIImage(named:"ni")
        let usual = UIImage(named: "san")
        switch row {
        case 0:
            uiImagevView.image = gold
        case 1:
            uiImagevView.image = diamond
        case 2:
            uiImagevView.image = usual
        default:
            uiImagevView.image = usual
        }
        return uiImagevView
    }
    
    var justGetMiddleResult:JustGetMiddleResult?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        makeColorLayer(view:self.view,number: backgroundColorNumberStatic)
        self.stopButton = makeStartTimer()
        self.view.addSubview(self.stopButton!)
        self.stopButton?.rx.tap.subscribe({ (action) in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: dispose)
    }
    let dispose = DisposeBag()
    func makeStartTimer() -> UIButton{
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height - 180 - safeAreaBottomFirstView! , width: 100, height: 100)
        startButton.backgroundColor = UIColor.white
        startButton.layer.cornerRadius = 50
        let image = UIImage(named: "back")
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        imageView.tintColor = Setting.color.init(rawValue: colorNumberStatic)?.getUIColor()
//　　本当は、以下のようにしたかったができなくなったので、無理やり数字で合わせた
//        imageView.center = stopButton.center
        startButton.addSubview(imageView)
        startButton.imageView?.contentMode = .scaleAspectFit
        startButton.contentHorizontalAlignment = .fill
        startButton.contentVerticalAlignment = .fill
        return startButton
    }
    var stopButton:UIButton?
    func makeColorLayer(view:UIView,number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        view.layer.insertSublayer(layer!, at: 0)
    }
    let myImageView = UIImageView()
    var tableView:UITableView!

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
