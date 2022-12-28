//
//  Rx+Observable.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import RxSwift

public extension Observable where Element: Any {
    
    func startLoading(loadingSubject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            loadingSubject.onNext(true)
        })
    }
    
    func stopLoading(loadingSubject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            loadingSubject.onNext(false)
        })
    }
    
}

