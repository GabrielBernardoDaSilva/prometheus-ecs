//
//  System.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//
protocol SystemBase {
    var world: World { get }
}

public class SystemExecutable {
    open func run(){}
}

public class System: SystemBase {

    private let _world: World
    var world: World {
        _world
    }
    
    
    init(world: World) {
        _world = world
    }
    
    open func start() {}
    open func update() {}
    open func dispose() {}
}

class SystemFunction<P: SystemParams> : SystemExecutable{
    
    private let _execute: (P) -> ()
    public unowned let _world: World
    init(execute: @escaping (P) -> (), world: World) {
        _execute = execute
        _world = world
    }
    
    override func run() {
        _execute(P.getParam(_world)!)
    }
    
    
}
