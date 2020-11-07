//
//  LoginViewModel.swift
//  tenSecondsTimer
//
//  Created by 松尾淳平 on 2020/11/07.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel{
    let userNamePublishSubject = PublishSubject<String>()
    let passwordPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool>{
        return Observable.combineLatest(userNamePublishSubject.asObservable().startWith(""), passwordPublishSubject.asObservable().startWith("")).map { userName, password in
            return !userName.isEmpty && password.count >= 5
        }
    }
}
