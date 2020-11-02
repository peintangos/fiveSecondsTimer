//
//  EachRecord.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/10.
//

/**
 　数人対戦用の結果テーブルです（ランキング以外）
 */

import Foundation
import RealmSwift

class EachRecord:Object{
    @objc dynamic var name: String?
    @objc dynamic var date = Date()
    @objc dynamic var timerSecond: String?
    @objc dynamic var timerMill: String?
    @objc dynamic var result:String?
    @objc dynamic var timeDifference:Double = 0
    //    通し番号
    @objc dynamic var orderInAGame:Int = 1
//　同じ組の中で区別するための番号
    @objc dynamic var orderNum:Int = 1
//    組み番号
    @objc dynamic var orderAll:Int = 1
    override static func primaryKey() -> String? {
        return "orderInAGame"
    }

    // ID を increment して返す
    static func newID(realm: Realm) -> Int {
        if let eachRecord = realm.objects(EachRecord.self).sorted(byKeyPath: "orderInAGame").last {
            return eachRecord.orderInAGame + 1
        } else {
            return 1
        }
    }

    // increment された ID を持つ新規 Person インスタンスを返す
    static func create(realm: Realm) -> EachRecord {
        let eachRecord: EachRecord = EachRecord()
        eachRecord.orderInAGame = newID(realm: realm)
        return eachRecord
    }
    
}


