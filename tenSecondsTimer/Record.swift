//
//  Record.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/09/27.
//

import Foundation
import RealmSwift

class Record: Object{
    @objc dynamic var name: String?
    @objc dynamic var date: Date?
    @objc dynamic var timerSecond: String?
    @objc dynamic var timerMsec: String?
    @objc dynamic var result:String?
    @objc dynamic var timeDifference:Double = 0
}
