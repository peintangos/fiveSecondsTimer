//
//  SettingViewModel.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2021/01/10.
//

import Foundation
import RxSwift
class SettingViewModel{
    private let numberCountViewModel = BehaviorSubject<Int>(value: 5)
    private let nameOmitVieModel = BehaviorSubject<Bool>(value: true)
    private let iconViewModel = BehaviorSubject<Int>(value: 1)
    private let circleColorViewModel = BehaviorSubject<Int>(value: 3)
    private let buttonColorViewModel = BehaviorSubject<Int>(value: 3)
    private let buttonSizeViewModel = BehaviorSubject<Int>(value: 2)
    private let buttonBorderColorViewModel = BehaviorSubject<Int>(value: 5)
    private let buttonBorderWidthViewModel = BehaviorSubject<Int>(value: 1)
    private let backGroundColorViewModel = BehaviorSubject<Int>(value: 0)
    private let nomikaiModeViewModel = BehaviorSubject<Bool>(value: true)
    private let kizunaRuleViewModel = BehaviorSubject<Int>(value: 1)
    private let ousamaRuleViewModel = BehaviorSubject<Int>(value:1)
    
    func isSectionZeroChanged() -> Observable<Bool>{
        return Observable.combineLatest(numberCountViewModel.asObservable(), nameOmitVieModel.asObservable()).map { numberCountViewModel, nameOmitVieModel  in
            numberCountViewModel == 5 && nameOmitVieModel == true
        }
    }
    func isSectionOneChaned() -> Observable<Bool>{
        return Observable.combineLatest(iconViewModel.asObservable(), circleColorViewModel.asObservable(), buttonColorViewModel.asObservable(), buttonSizeViewModel.asObservable(), buttonBorderColorViewModel.asObservable(), buttonBorderWidthViewModel.asObservable(), backGroundColorViewModel.asObservable()).map { (iconViewModel,circleColorViewModel,buttonColorViewModel,buttonSizeViewModel,buttonBorderColorViewModel,buttonBorderWidthViewModel,backGroundColorViewModel) in
            iconViewModel == 1 && circleColorViewModel == 3 && buttonColorViewModel == 3 && buttonSizeViewModel == 3 && buttonBorderColorViewModel == 2 && buttonBorderColorViewModel == 5 && buttonBorderWidthViewModel == 1 && backGroundColorViewModel == 0
        }
    }
    func isSectionSecondChaned() -> Observable<Bool>{
        return Observable.combineLatest(nomikaiModeViewModel.asObservable(), kizunaRuleViewModel.asObservable(), ousamaRuleViewModel.asObservable()).map { (nomikaiModeViewModel,kizunaRuleViewModel,ousamaRuleViewModel) in
            nomikaiModeViewModel == true && kizunaRuleViewModel == 1 && ousamaRuleViewModel == 1
        }
    }

}
