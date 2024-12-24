//
//  File.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 22/12/24.
//

import Foundation



class Entity: Component {
    private let _id: Int
    private var _location: Int
    
    init(id: Int, location: Int) {
        self._id = id
        self._location = location
    }
    
    var id: Int {
        _id
    }
    
    
    var location: Int {
        set {
            _location = newValue
        }
        get {
            _location
        }
    }
}


extension Entity: CustomStringConvertible {
    var description: String {
        "Entity: \(id) \(location)"
    }
}
