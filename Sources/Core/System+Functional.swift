//
//  System+Functional.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//


@available(macOS 14.0, *)
public final class SystemFunction<each P: SystemParams> : SystemExecutable{
    public typealias Param = (repeat each P) -> ()
    
    private let _execute: Param
    public unowned let _world: World
    init(execute: @escaping Param, world: World) {
        _execute = execute
        _world = world
    }
    
    public override func run() {
        _execute(repeat (each P).getParam(_world)!)
    }
}

public enum SystemFunctionExecution {
    case start
    case update
    case dispose
}
