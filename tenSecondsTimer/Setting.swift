//
//  SettingEnum.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/18.
//

import Foundation

enum Setting:CaseIterable{
    enum time :Int,CaseIterable{
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
        case ten = 10
    }
    enum icon :Int,CaseIterable{
        case beer = 1
        case fire = 2
        func getName()->String{
            switch self {
            case .beer:
                return "beer"
            case .fire:
                return "fire"
            }
        }
    }
    enum color:Int,CaseIterable{
        case gray = 1
        case blue = 2
        case orange = 3
        func getName() ->String{
            switch self {
            case .gray:
                return "gray"
            case .blue:
                return "blue"
            case .orange:
                return "orange"
            }
        }
    }
}
