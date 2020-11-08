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
//    private にしてカプセル化したいが、どのように返せば良いかわからない。（Observerを返したいが、返せない）
     let userNamePublishSubject = PublishSubject<String>()
     let passwordPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool>{
        return Observable.combineLatest(userNamePublishSubject.asObservable().startWith(""), passwordPublishSubject.asObservable().startWith("")).map { userName, password in
            return !userName.isEmpty && password.count >= 5
        }
    }
    
//    ネットでは、上記で書いていたが、下記の方がスッキリしているよね
    private let userNameBehaviorSubject = BehaviorSubject<String>(value: "")
    private let passwordBehaviorSubject = BehaviorSubject<String>(value: "")
    var userNameBehaviorSubjectAcesss:BehaviorSubject<String>{
        return userNameBehaviorSubject
    }
    var passwordBehaviorSubjectAccess:BehaviorSubject<String>{
        return passwordBehaviorSubject
    }
    func isValidNew() -> Observable<Bool>{
        return Observable.combineLatest(userNameBehaviorSubject.asObservable(), passwordBehaviorSubject.asObservable()).map {
            username, password in
            return !username.isEmpty && password.count >= 5
        }
    }
}
