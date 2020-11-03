//
//  CountTimeViewModel.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/03.
//

import Foundation
import RxCocoa
import RxSwift

class CountTimeViewModel{
    private let items = BehaviorRelay<[CountTimeDto]>(value:[])
    var itemObservalble:Observable<[CountTimeDto]>{
        return items.asObservable()
    }
}
