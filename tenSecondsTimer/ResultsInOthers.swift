//
//  ResultsInOthers.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/10.
//

import Foundation
import RealmSwift

class ResultsInOthers:Object{
    @objc dynamic var firstScore:Double = 0
    @objc dynamic var secondScore:Double = 0
    @objc dynamic var first:String?
    @objc dynamic var second:String?
    static func create(first:String,second:String,firstSecore:Double,secondScore:Double) -> ResultsInOthers {
        let resultsInOthers: ResultsInOthers = ResultsInOthers()
        resultsInOthers.first = first
        resultsInOthers.second = second
        resultsInOthers.firstScore = firstSecore
        resultsInOthers.secondScore = secondScore
        return resultsInOthers
    }
    
}
