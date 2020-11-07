//
//  CountTimeViewModel.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/03.
//

import Foundation
import RxCocoa
import RxSwift

struct CountTimeViewModel{
    private var items:Observable<[CountTimeDto]>
    var itemObservalble:Observable<[CountTimeDto]>{
        return items
    }
    init(itemsList:[CountTimeDto]){
        self.items = Observable<[CountTimeDto]>.just(itemsList)
    }
}
