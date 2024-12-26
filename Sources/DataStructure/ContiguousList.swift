//
//  ContiguousList.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 26/12/24.
//


public enum PointerError : Error {
    case invalidPointer
    case outOfBounds
}

public struct ContiguousList <T: ~Copyable>: ~Copyable{

    
    private var _element: UnsafeMutableBufferPointer<T?>
    private var _capacity: Int
    private var _count: Int
    
    public var count: Int { _count }
    
    init(capacity: Int = 2) {
        _capacity = capacity
        _element = .allocate(capacity: capacity)
        _count = 0
    }
    
    deinit {
        _element.deallocate()
        
    }
}

// MARK: methods that mutating list
extension ContiguousList where T: ~Copyable{
    public mutating func append(_ element: consuming T) {
        resize()
        _element[_count] = consume element
        _count += 1
    }
    
    
    public mutating func pop() throws(PointerError) -> T? {
        guard let baseAddress = _element.baseAddress else {
            throw .outOfBounds
        }
        
        let lastElement = baseAddress.advanced(by: _count - 1).pointee.take()
        _count -= 1
        
        return lastElement
        
    }
    
    public mutating func removeAt(index: Int) throws(PointerError) -> T?{
        guard let baseAddress = _element.baseAddress, index < _count else {
            throw .outOfBounds
        }
        
        let movedElement = baseAddress.advanced(by: index).pointee.take()
        if index == _count - 1 {
            _count -= 1
            return movedElement
        }
        
        
        let lastElement = baseAddress.advanced(by: _count - 1).pointee.take()
        _element[index] = lastElement
        
        _count -= 1
        return movedElement
    }
    
    
    private mutating func resize() {
        if _count == _capacity {
            let newCapacity = _capacity * 2
            let newBuffer = UnsafeMutableBufferPointer<T?>.allocate(capacity: newCapacity)
            
            for i in 0..<_count {
                newBuffer[i] =  _element.baseAddress!.advanced(by: i).move()
            }
            
            _element.deallocate()
            _element = newBuffer
            _capacity = newCapacity
        }
    }
    
    public func getElementMutate(at index: Int) throws(PointerError) -> UnsafeMutablePointer<T?>  {
        guard let baseAddress = _element.baseAddress,  index < _element.count else {
            throw .outOfBounds
        }
        return UnsafeMutablePointer(baseAddress.advanced(by: index))
    
    }
    
}

protocol Positionable: ~Copyable {
    var x: Int { get }
    var y: Int { get }
}

extension ContiguousList where T : Positionable {
    func printList(){
        for i in 0..<count {
            if let element = UnsafePointer(_element.baseAddress!.advanced(by: i)).pointee{
                let str = "Pos \(element.x) \(element.y)"
                print(str)
            }else {
                print("nil")
            }
            
            
        }
    }
}


// MARK: methods that no mutating list
extension ContiguousList where T: ~Copyable {
    public typealias ReturnType = UnsafePointer<T?>
    
    public func getElement(at index: Int) throws(PointerError) -> ReturnType  {
        guard let baseAddress = _element.baseAddress,  index < _element.count else {
            throw .outOfBounds
        }
        
       return UnsafePointer(baseAddress.advanced(by: index))
    
    }
    
    public subscript (index: Int) ->  ReturnType {
        get {
            try! getElement(at: index)
        }
    }
}


