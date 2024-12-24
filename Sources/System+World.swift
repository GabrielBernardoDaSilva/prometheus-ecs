//
//  System+World.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
    public func addSystem(_ system: System) {
        systems.append(system)
    }
    
    private func startSystems() {
        systems.forEach{$0.start()}
    }
    
    private func updateSystems() {
        systems.forEach{$0.update()}
    }
    
    private func disposeSystems() {
        systems.forEach{$0.dispose()}
    }
    
    public func executeSystems() {
        isRunning = true
        
        startSystems()
        while isRunning {
            updateSystems()
        }
        disposeSystems()
    }
    
    public func singleExecuteSystems() {
        startSystems()
        updateSystems()
        disposeSystems()
    }
}


extension World {
    func addSystemFunction<P>(_ systemFunction: @escaping (P) -> ()) where P: SystemParams {
        let f = SystemFunction<P>(execute: systemFunction, world: self)
        f.run()
    }
}
