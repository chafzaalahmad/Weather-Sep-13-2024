//
//  Coordinator.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import Foundation

/// Types adopting the `Coordinator` protocol will used to start/manage view controllers navigations.
protocol Coordinator: AnyObject {
    /// it will start the flow or navigation.
    func start()
    
    /// it will hold the child coordinator of current coordinator.
    var child: Coordinator? { get set }
    
    /// it will hold the parent coordinator of current coordinator.
    var parent: Coordinator? { get set }
}

extension Coordinator {
    /// it will start the child coordinator.
    /// - Parameter coordinator: specify child coordinator.
    func startChild(_ coordinator: Coordinator) {
        child = coordinator
        child?.parent = self
        coordinator.start()
    }
    
    /// inform the parent coordinator that its child finished.
    func didFinishChild() {
        child = nil
        parent?.child = nil
    }
}
