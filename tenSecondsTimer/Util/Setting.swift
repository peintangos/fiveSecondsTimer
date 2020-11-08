//
//  SettingEnum.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/10/18.
//

/**
 設定画面のEnum
 */

import Foundation
import UIKit

enum Setting:CaseIterable{
    enum backgroundColor:Int,CaseIterable{
        case rainbow = 0
        case purpleblue = 1
        case purple = 2
        case orangpurple = 3
        func getGradationLayer() ->CAGradientLayer{
            let layer = CAGradientLayer()
            switch self {
            case .rainbow:
            layer.colors = [UIColor.init(red: 130 / 250, green: 250 / 250, blue: 176 / 250, alpha: 1).cgColor,UIColor.init(red: 143 / 255, green: 211 / 255, blue: 244 / 255, alpha: 1).cgColor]
            layer.locations = [0.1,0.7]
            layer.startPoint = CGPoint(x: 0.3, y: 0)
            layer.endPoint = CGPoint(x: 0.2, y: 1)
            case .purpleblue:
            layer.colors = [UIColor.init(red: 213 / 250, green: 126 / 250, blue: 235 / 250, alpha: 1).cgColor,UIColor.init(red: 142 / 255, green: 197 / 255, blue: 252 / 255, alpha: 1).cgColor]
            layer.locations = [0.1,0.7]
            layer.startPoint = CGPoint(x: 0.3, y: 0)
            layer.endPoint = CGPoint(x: 0.2, y: 1)
            case .purple:
            layer.colors = [UIColor.init(red: 205 / 250, green: 156 / 250, blue: 242 / 250, alpha: 1).cgColor,UIColor.init(red: 246 / 255, green: 243 / 255, blue: 255 / 255, alpha: 1).cgColor]
            layer.locations = [0.1,0.7]
            layer.startPoint = CGPoint(x: 0.3, y: 0)
            layer.endPoint = CGPoint(x: 0.2, y: 1)
            case .orangpurple:
            layer.colors = [UIColor.init(red: 252 / 250, green: 203 / 250, blue: 144 / 250, alpha: 1).cgColor,UIColor.init(red: 213 / 255, green: 126 / 255, blue: 235 / 255, alpha: 1).cgColor]
            layer.locations = [0.1,0.7]
            layer.startPoint = CGPoint(x: 0.3, y: 0)
            layer.endPoint = CGPoint(x: 0.2, y: 1)
            }
            return layer
        }
        func getName() ->String{
            switch self {
            case .rainbow:
                return "rainbow"
            case .purpleblue:
                return "purpleblue"
            case .purple:
                return "purple"
            case .orangpurple:
                return "orangepurple"
            }
        }
    }
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
        case cooktail = 2
        case cunbeer = 3
        case bansyaku = 4
        case shampan = 5
        
        func getName()->String{
            switch self {
            case .beer:
                return "beer"
            case .cooktail:
                return "cooktail"
            case .cunbeer:
                return "cunbeer"
            case .bansyaku:
                return "bansyaku"
            case .shampan:
                return "shampan"
            }
        }
    }
    enum fontSize:Int,CaseIterable{
    case small = 1
    case medium = 2
    case large = 3
        func getSize()->Int{
            switch self{
            case .small:
                return 8
            case .medium:
                return 15
            case .large:
                return 20
            }
        }
        func getName() ->String{
            switch self{
            case .small:
                return "small"
            case .medium:
                return "medium"
            case .large:
                return "large"
            }
        }
    }

    enum color:Int,CaseIterable{
        case black = 1
        case blue = 2
        case brown = 3
        case cyan = 4
        case darkGray = 5
        case gray = 6
        case lightGray = 7
        case green = 8
        case magenta = 9
        case orange = 10
        case purple = 11
        case red = 12
        case clear = 13
        case yellow = 14
    
        func getUIColor() -> UIColor{
            switch self {
            case .black:
                return UIColor.black
            case .blue:
                return UIColor.blue
            case .brown:
                return UIColor.brown
            case .cyan:
                return UIColor.cyan
            case .darkGray:
                return UIColor.darkGray
            case .gray:
                return UIColor.gray
            case .lightGray:
                return UIColor.lightGray
            case .green:
                return .green
            case .magenta:
                return .magenta
            case .orange:
                return .orange
            case .purple:
                return .purple
            case .red:
                return .red
            case .clear:
                return .clear
            case.yellow:
                return .yellow
            }
        }
    }
}
