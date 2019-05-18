//
//  Dynamic.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    typealias Listner = (T?) -> Void
    var listner:Listner?
    
    func bind(listner:@escaping Listner) {
        self.listner = listner
    }
    
    func bindAndFire(listner:@escaping Listner) {
        self.listner = listner
        self.listner?(value)
    }
    
    var value: T? {
        didSet {
            self.listner?(value)
        }
    }
    
    init(v:T?) {
        self.value = v
    }
    
}
