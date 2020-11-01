//
//  JustGetMiddleResult.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/24.
//

/**
 ちょうど真ん中を狙うのテーブルです
 */
import Foundation
import RealmSwift

class JustGetMiddleResult:Object{
    @objc dynamic var name = "デフォルト"
    @objc dynamic var dateNoMold = Date()
    @objc dynamic var date:String?
    @objc dynamic var goal:Double = 0.0
    @objc dynamic var end:Double = 0.0
    @objc dynamic var difference:Double = 0.0
}
