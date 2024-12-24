//
//  File.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//

public protocol PluginBuilder {
    func build(_ world: World)
}


extension World {
    public func buildPlugins() {
        plugins.forEach { $0.build(self)}
    }
}
