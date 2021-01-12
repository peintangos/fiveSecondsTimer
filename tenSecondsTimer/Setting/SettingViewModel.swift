//
//  SettingViewModel.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2021/01/10.
//

import Foundation
import RxSwift
import RxCocoa
class SettingViewModel{
    let numberCountViewModel = BehaviorRelay<Int>(value: 5)
    let nameOmitVieModel = BehaviorRelay<Bool>(value: false)
    let iconViewModel = BehaviorRelay<Int>(value: 1)
    let circleColorViewModel = BehaviorRelay<Int>(value: 3)
    let buttonTextColorViewModel = BehaviorRelay<Int>(value: 3)
    let buttonSizeViewModel = BehaviorRelay<Int>(value: 2)
    let buttonBorderColorViewModel = BehaviorRelay<Int>(value: 5)
    let buttonBorderWidthViewModel = BehaviorRelay<Int>(value: 1)
    let backGroundColorViewModel = BehaviorRelay<Int>(value: 0)
    let nomikaiModeViewModel = BehaviorRelay<Int>(value: 1)
    let kizunaRuleViewModel = BehaviorRelay<Int>(value: 1)
    let ousamaRuleViewModel = BehaviorRelay<Int>(value: 1)
    
    func isSectionZeroChanged() -> Observable<Bool>{
        return Observable.combineLatest(numberCountViewModel.asObservable(), nameOmitVieModel.asObservable()).map { numberCountViewModel, nameOmitVieModel  in
            numberCountViewModel == 5 && nameOmitVieModel == false
        }
    }
    func isSectionOneChaned() -> Observable<Bool>{
        return Observable.combineLatest(iconViewModel.asObservable(), circleColorViewModel.asObservable(), buttonTextColorViewModel.asObservable(), buttonSizeViewModel.asObservable(), buttonBorderColorViewModel.asObservable(), buttonBorderWidthViewModel.asObservable(), backGroundColorViewModel.asObservable()).map { icon,circle,buttonTextColor,buttonSize,buttonBorderColor,buttonBorderWidth,backGroundColor in
            icon == 1 && circle == 3 && buttonTextColor == 3 && buttonSize == 2 && buttonBorderColor == 5 && buttonBorderWidth == 1 && backGroundColor == 0
        }
    }
    func isSectionSecondChaned() -> Observable<Bool>{
        return Observable.combineLatest(nomikaiModeViewModel.asObservable(), kizunaRuleViewModel.asObservable(), ousamaRuleViewModel.asObservable()).map { (nomikaiModeViewModel,kizunaRuleViewModel,ousamaRuleViewModel) in
            nomikaiModeViewModel == 1 && kizunaRuleViewModel == 1 && ousamaRuleViewModel == 1
        }
    }
    func changed() -> Observable<Bool>{
        return Observable.combineLatest(isSectionZeroChanged(), isSectionOneChaned(), isSectionSecondChaned()).map { (zero, one, second) in
            zero && one && second
        }
    }
    func changedNew() -> Observable<Bool>{
        return Observable.combineLatest(isSectionZeroChanged(), isSectionSecondChaned()).map { (zero, one) in
            zero && one
        }
    }
//    例
    func isCountChanged() -> Observable<Bool>{
        return numberCountViewModel.asObservable().map { (number) in
            number == 5
        }
    }

    func acceptCountViewModel(number:Int){
        numberCountViewModel.accept(number)
    }
    func acceptnameOmitVieModel(bool:Bool){
        nameOmitVieModel.accept(bool)
    }
    func acceptIconViewModel(number:Int){
        iconViewModel.accept(number)
    }
    func acceptCircleColorViewModel(number:Int){
        circleColorViewModel.accept(number)
    }
    func acceptButtonColorViewModel(number:Int){
        buttonTextColorViewModel.accept(number)
    }
    func acceptButtonSizeViewModel(number:Int){
        buttonSizeViewModel.accept(number)
    }
    func acceptButtonBorderColorViewModel(number:Int){
        buttonBorderColorViewModel.accept(number)
    }
    func acceptButtonBorderWidthViewModel(number:Int){
        buttonBorderWidthViewModel.accept(number)
    }
    func acceptBackGroundColorViewModel(number:Int){
        backGroundColorViewModel.accept(number)
    }
    func acceptNomikaiModeViewModel(number:Int){
        nomikaiModeViewModel.accept(number)
    }
    func acceptKizunaRuleViewModel(number:Int){
        kizunaRuleViewModel.accept(number)
    }
    func acceptOusamaRuleViewModel(number:Int){
        ousamaRuleViewModel.accept(number)
    }

}
