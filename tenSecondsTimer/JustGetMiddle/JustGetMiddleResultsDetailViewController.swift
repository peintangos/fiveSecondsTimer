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

class JustGetMiddleResultsDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var row:Int?
    var section:Int?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "名前:\(justGetMiddleResult!.name)\n解離:\(justGetMiddleResult!.difference)%\n日付:\( justGetMiddleResult!.date!)\nゴール:\(justGetMiddleResult!.goal)\nストローク:\(justGetMiddleResult!.end)"
        cell.textLabel?.numberOfLines = 0
        
        if section! == 0{
            cell.accessoryView = setImg2(kairi: justGetMiddleResult!.difference,row:row!)
        }else {
            cell.accessoryView = setImg(kairi: justGetMiddleResult!.difference)
        }
        return cell
    }
    func setImg(kairi:Double) ->UIImageView{
        var uiImagevView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        var gold = UIImage(named: "gold")
        var diamond = UIImage(named:"diamond")
        var usual = UIImage(named: "tor")
        var kaizoku = UIImage(named: "kaizoku")
        var kubi = UIImage(named: "kubi")
        var dou = UIImage(named: "dou")
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
        var uiImagevView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        var gold = UIImage(named: "ichi")
        var diamond = UIImage(named:"ni")
        var usual = UIImage(named: "san")
        print(row)
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
        makeColorLayer(number: backgroundColorNumberStatic)
    }
    func makeColorLayer(number:Int){
        let layer = Setting.backgroundColor.init(rawValue: number)?.getGradationLayer()
        layer!.frame = self.view.frame
        self.view.layer.insertSublayer(layer!, at: 0)
    }
    let myImageView = UIImageView()
    var tableView:UITableView!
    override func viewWillAppear(_ animated: Bool) {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView)
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
