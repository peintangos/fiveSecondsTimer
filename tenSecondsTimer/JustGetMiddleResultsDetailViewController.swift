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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "名前:\(justGetMiddleResult!.name)\n解離:\(justGetMiddleResult!.difference)%\n日付:\( justGetMiddleResult!.date!)\nゴール:\(justGetMiddleResult!.goal)\nストローク:\(justGetMiddleResult!.end)"
        cell.textLabel?.numberOfLines = 0
        
//        var img = UIImage(named: "gold")
//        self.myImageView.image = img
//        myImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        cell.accessoryView = setImg(kairi: justGetMiddleResult!.difference)
        return cell
    }
    func setImg(kairi:Double) ->UIImageView{
        var uiImagevView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        var gold = UIImage(named: "gold")
        var diamond = UIImage(named:"diamond")
        var usual = UIImage(named: "tor")
        var kaizoku = UIImage(named: "kaizoku")
        var kubi = UIImage(named: "kubi")
        switch kairi {
        case 0.0 ... 5.0:
            uiImagevView.image = diamond
        case 5.0 ... 10.0:
            uiImagevView.image = gold
        case 10.0 ... 20.0:
            uiImagevView.image = kubi
        case 20.0 ... 100.0:
            uiImagevView.image = kaizoku
        default:
            uiImagevView.image = usual
        }
        return uiImagevView
    }
    
    var justGetMiddleResult:JustGetMiddleResult?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
