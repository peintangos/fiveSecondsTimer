//
//  JustGetMiddleResultsObject.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/02.
//

import Foundation
import RealmSwift
class JustGetMiddleResultsObject:Object{
    @objc dynamic var name = "Example 太郎"
//    対戦で一意になるID(ランキングで取り出すときに、このIDを使用する
    @objc dynamic var numberForAGame = 0
    @objc dynamic var dateNoMold = Date()
    @objc dynamic var date:String?
    @objc dynamic var goal:Double = 0.0
    @objc dynamic var end:Double = 0.0
    @objc dynamic var difference:Double = 0.0
}
