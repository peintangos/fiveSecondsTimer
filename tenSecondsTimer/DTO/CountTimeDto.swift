//
//  CountTimeDto.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/03.
//

import Foundation
struct CountTimeDto:Codable{
    var id:Int
    var deviceNumber:String
    var createdAt:String
    var name:String
    var timeDifference:Double
}
