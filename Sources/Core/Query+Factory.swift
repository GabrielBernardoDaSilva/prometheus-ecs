//
//  File.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 22/12/24.
//

import Foundation


public protocol QueryFactory{
    associatedtype Components
    associatedtype ComponentTypes
    
    init()

    static func components(archetype: Archetype, entityId: Int) -> Components
    
    static func getComponentsSignature() ->[ComponentSignature]
    
}


public protocol QueryExcludeFactory {
    init()
    
    static func getExcludedSignatures() -> [ComponentSignature]
}
