//
//  Foo.swift
//  Test
//
//  Created by Sergey Kolupaev on 11/11/15.
//  Copyright © 2015 Sergey Kolupaev. All rights reserved.
//

import Foundation

class Foo: NSObject {
    var aa: Int = 0
    
    override init() {
        super.init()
    }
}

class Bar: NSObject {
    var ss: Foo?
    
    func ee() {
        print(ss!.aa)
    }
}