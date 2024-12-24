//
//  Event.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 24/12/24.
//
import Foundation


public protocol Event{
    /// Unique, immutable identifier of this component type.
    static var signature: EventSignature { get }

    /// Unique, immutable identifier of this component type.
    var signature: EventSignature { get }
}



public struct EventSignature {
    private let _id: Identifier
    
    public var id : Identifier{
        return _id
    }
    
    @usableFromInline init(_ eventType: (some Event).Type) {
         _id = ObjectIdentifier(eventType).hashValue
    }
}


extension EventSignature : Hashable {}
extension EventSignature : Equatable {}
extension EventSignature: CustomStringConvertible {
    public var description: String { "\(id)" }
}

