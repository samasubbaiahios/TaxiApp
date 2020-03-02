//
//  NSObject+Observable.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

extension NSObject {
    func observe<T>(for observables: [Observable<T>], with: @escaping (T) -> Void) {
        for observable in observables {
            observable.bind { (_, value)  in
                DispatchQueue.main.async {
                    with(value)
                }
            }
        }
    }
}
