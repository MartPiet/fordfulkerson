//
//  Edge.swift
//  FordFulkerson
//
//  Created by Martin Pietrowski on 24.08.16.
//  Copyright © 2016 Martin Pietrowski. All rights reserved.
//

import Foundation

class Edge {
    fileprivate var startpoint = Vertice()
    fileprivate var endpoint = Vertice()
    fileprivate var flow = 0
    fileprivate var capacity = 0
    fileprivate var used = false
    
    func getStartpoint() -> Vertice {
        return startpoint
    }
    
    func getEndpoint() -> Vertice {
        return endpoint
    }
    
    func getFlow() -> Int {
        return flow
    }
    
    func getCapacity() -> Int {
        return capacity
    }
    
    func setStartpoint(_ newStartpoint: Vertice) {
        startpoint = newStartpoint
    }
    
    func setEndpoint(_ newEndpoint: Vertice) {
        endpoint = newEndpoint
    }
    
    func setFlow(_ newFlow: Int) {
        flow = newFlow
    }
    
    func setCapacity(_ newCapacity: Int) {
        capacity = newCapacity
    }
    
    func getAvailableFlow() -> Int {
        return capacity - flow
    }
    
    func compareEdges(_ comparingEdge: Edge) -> Bool{
        if startpoint.getLabel() == comparingEdge.startpoint.getLabel() && endpoint.getLabel() == comparingEdge.endpoint.getLabel() {
            return true
        } else {
            return false
        }
    }
    
    func setUsedStatus(_ input: Bool) {
        used = input
    }
    
    func isUsed() -> Bool {
        return used
    }
    
}




