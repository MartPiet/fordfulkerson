//
//  Vertice.swift
//  FordFulkerson
//
//  Created by Martin Pietrowski on 24.08.16.
//  Copyright © 2016 Martin Pietrowski. All rights reserved.
//

import Foundation

func !=(left: Vertice, right: Vertice) -> Bool {
    if(left.getX() == right.getX() && left.getY() == right.getY()) {
        return false
    }
    return true
}

func ==(left: Vertice, right: Vertice) -> Bool {
    if(left.getX() == right.getX() && left.getY() == right.getY()) {
        return true
    }
    return false
}

class Vertice {
    fileprivate var x = 0, y = 0
    fileprivate var radius = 15
    fileprivate var label = String()
    fileprivate var incomingEdges = [Edge]()
    fileprivate var outgoingEdges = [Edge]()
    fileprivate var used = false
    fileprivate var d = FP_INFINITE

    init(){
        
    }
    
    init(inputX: Int, inputY: Int) {
        x = inputX
        y = inputY
    }
    
    func getX() -> Int {
        return x
    }
    
    func getY() -> Int {
        return y
    }
    
    func getRadius() -> Int {
        return radius
    }
    
    func getLabel() -> String {
        return label
    }
    
    func getIncomingEdges() -> [Edge] {
        return incomingEdges
    }
    
    func getUnusedIncomingEdge() -> Edge? {
        for edge in incomingEdges {
            if !edge.isUsed() {
                return edge
            }
        }
        return nil
    }
    
    func getOutgoingEdges() -> [Edge] {
        return outgoingEdges
    }
    
    
    func setX(_ newX: Int) {
        x = newX
    }
    
    func setY(_ newY: Int) {
        y = newY
    }
    
    func setLabel(_ newLabel: String) {
        label = newLabel
    }
    
    func addIncomingEdge(_ newEdge: Edge) {
        incomingEdges.append(newEdge)
    }
    
    func removeIncomingEdge(_ oldEdge: Edge) {
        for var i in 0..<incomingEdges.count {
            if incomingEdges[i].compareEdges(oldEdge) {
                incomingEdges.remove(at: i)
            }
        }
    }
    
    func freeIncomingEdges() -> Bool {
        for edge in incomingEdges {
            if edge.getFlow() < edge.getCapacity() {
                return true
            }
        }
        return false
    }
    
    
    func allIncommingNeighboursUsed() -> Bool {
        for edge in incomingEdges {
            if edge.getStartpoint().isUsed() != true {
                return true
            }
        }
        return false
    }
    
    func addOutgoingEdge(_ newEdge: Edge) {
        outgoingEdges.append(newEdge)
    }
    
    func removeOutgoingEdge(_ oldEdge: Edge) {
        for var i in 0..<outgoingEdges.count {
            if outgoingEdges[i].compareEdges(oldEdge) {
                outgoingEdges.remove(at: i)
            }
        }
    }
    
    func isUsed() -> Bool {
        return used
    }
    
    func setUsedStatus(_ value: Bool) {
        used = value
    }
    
    func unusedEdges() -> Bool {
        for edge in incomingEdges {
            if !edge.isUsed() {
                return true
            }
        }
        return false
    }
    
    func getD() -> Int {
        return Int(d)
    }
    
    func setD(_ newD: Int) {
        d = Int32(newD)
    }
    
    func isInRange(_ inputX: Int, inputY: Int) -> Bool {
        if abs(x - inputX) <= radius && abs(y - inputY) <= radius {
            return true
        }
        
        return false
    }
    
    func checkIfSource() -> Bool {
        return incomingEdges.count == 0
    }
    
    func checkIfSink() -> Bool {
        return outgoingEdges.count == 0
    }
    
}









