//
//  FordFulkerson.swift
//  FordFulkerson
//
//  Created by Martin Pietrowski on 24.08.16.
//  Copyright © 2016 Martin Pietrowski. All rights reserved.
//

import Foundation


class FordFulkerson {
    init(vertices: [Vertice], edges: [Edge]) {
        fordFulkersonAlgorithm(vertices, edges: edges)
    }


    func fordFulkersonAlgorithm(_ vertices: [Vertice], edges: [Edge]) {
        var maxFlow = 0
//        var path = [Vertice]()
        var pathFlow = Int(INT_MAX)
        var freeFlow = 0
        var tmpEdge = Edge()
        
        print("++++++++++++++++++++++++++++++++")
        while let path = augmentingPath(vertices, edges: edges) {
            print("Path.count: ", path.count)
            pathFlow = Int(INT_MAX)
            for var i in 0..<path.count - 1 {
                print("i: ", i)
                tmpEdge = findEdge(path[i + 1], vertice2: path[i])!
                freeFlow = tmpEdge.getAvailableFlow()
                print("Freeflow: ", freeFlow)
                pathFlow = min(freeFlow, pathFlow)
                print("PathFlow: ", pathFlow)
            }
            
            for var i in 0..<path.count - 1 {
                tmpEdge = findEdge(path[i + 1], vertice2: path[i])!
                tmpEdge.setFlow(tmpEdge.getFlow() + pathFlow)
            }
            print("")
            print("#################################")
            print("")
        }
    }
    
    
    func augmentingPath(_ vertices: [Vertice], edges: [Edge]) -> [Vertice]? {
        var s = Vertice()
        var t = Vertice()
        var path = [Vertice]()
        var tmpVertice = Vertice()
//        var tmpEdge = Edge()
        
//        setAllVerticesToUnused(vertices)

        
        for vertice in vertices {
            if vertice.checkIfSource() {
                s = vertice
                break;
            }
        }
        
        for vertice in vertices {
            if vertice.checkIfSink() {
                t = vertice
                break;
            }
        }
        path.removeAll()
        
        print("Path.count: ", path.count)
        while path.count < 2 && path.count != 1{
            path.removeAll()
            path.append(t)
            path = scanEdges(path, s: s, t: t)
        }
        print("Path.count: ", path.count)

        
        setAllVerticesToUnused(vertices)
        setAllEdgesToUnused(edges)

        if path.count < 1 || path.last! != s {
            return nil
        } else {
            return path
        }
    }
    

    
    func scanEdges(_ path: [Vertice], s: Vertice, t: Vertice) -> [Vertice] {
        var tmpPath = path
        print("Vertice: ", path.last!.getLabel())
        
        while let edge = path.last!.getUnusedIncomingEdge() {
//        for edge in path.last!.getIncomingEdges() {
            print("Edge: ", edge.getFlow(), "/", edge.getCapacity())
            if edge.isUsed() {
                print("isUsed")
                break
            } else if edge.getFlow() < edge.getCapacity() {
                tmpPath.append(edge.getStartpoint())
//                edge.getStartpoint().setUsedStatus(true)
                edge.setUsedStatus(true)

                break
            } else if edge.getFlow() == edge.getCapacity() {
                edge.setUsedStatus(true)
            } else if tmpPath.last! != s && !path.last!.unusedEdges() {
                tmpPath.last!.setUsedStatus(true)
                tmpPath.removeLast()
            } else if tmpPath.last! != s && !path.last!.allIncommingNeighboursUsed() {
                tmpPath.last!.setUsedStatus(true)
                tmpPath.removeLast()
            }
        }
        

        
        while tmpPath.last! != s && !edgesUsed(tmpPath.last!) {
            tmpPath = scanEdges(tmpPath, s: s, t: t)
        }
        
        return tmpPath
        
    }
    
    func edgesUsed(_ vertice: Vertice) -> Bool {
        for edge in vertice.getIncomingEdges() {
            if !edge.isUsed() {
                return false
            }
        }
        return true
    }

    func findEdge(_ vertice1: Vertice, vertice2: Vertice) -> Edge? {
        print("vertice1: ", vertice1.getLabel())
        print("vertice2: ", vertice2.getLabel())
        
        for edge in vertice1.getOutgoingEdges() {
            print("Edge: ", edge.getCapacity())
            if edge.getEndpoint() == vertice2 {
                return edge
            }
        }
        
        for edge in vertice1.getIncomingEdges() {
            print("Edge: ", edge.getCapacity())
            if edge.getStartpoint() == vertice2 {
                return edge
            }
        }
        
        print("findEdge() returns nil")
        return nil
    }
    
    func setAllVerticesToUnused(_ vertices: [Vertice]) {
        for vertice in vertices {
            vertice.setUsedStatus(false)
        }
    }
    
    func setAllEdgesToUnused(_ edges: [Edge]) {
        for edge in edges {
            edge.setUsedStatus(false)
        }
    }
}


    
//    func fordFulkersonAlgorithm(vertices: [Vertice], edges: [Edge]) {
//        var i = 0
//        
//        for edge in edges {
//            edge.setFlow(0)
//        }
//        
//        for vertice in vertices {
//            vertice.setUsed(false)
//        }
//        
//        while !areAllVerticesUsed(vertices) {
//            var w: [Edge] = [Edge]()
//            var tmpVertice = vertices[i]
//            var tmpPossibleFlow = 0
//            for edge in tmpVertice.getOutgoingEdges() {
//                w.append(edge)
//                if !edge.getEndpoint().isUsed() && edge.getFlow() < edge.getCapacity() {
//                    tmpPossibleFlow = min(edge.getFlow() - edge.getCapacity(), tmpVertice.getD())
//                }
//            }
//            
//            
//            
//            i += 1
//        }
//        
//        
//    }
//    
//    
//    func areAllVerticesUsed(vertices: [Vertice]) -> Bool{
//        for vertice in vertices {
//            if !vertice.isUsed() {
//                return false
//            }
//        }
//        return true
//    }
    
//    func fordFulkersonAlgorithm(vertices: [Vertice], edges: [Edge]) -> Int {
////(int graph[V][V], int s, int t)
//        var u: Int, v: Int;
//        
//        var rGraphVertices = vertices
//        var rGraphEdges = edges
////        var path = [Edge]()
//        var maxFlow = 0
//        var s = Vertice()
//        var t = Vertice()
//        
//        for vertice in vertices {
//            if vertice.checkIfSource() {
//                s = vertice
//                break;
//            }
//        }
//        
//        for vertice in vertices {
//            if vertice.checkIfSink() {
//                t = vertice
//                break;
//            }
//        }
//        
//        print("S: ", s.getX())
//        print("T: ", t.getX())
//        
//        for edge in rGraphEdges {
//            let tmpCapacity = edge.getCapacity()
//            edge.setCapacity(edge.getFlow())
//            edge.setFlow(tmpCapacity)
//        }
//        
////        path = augmentingPath(rGraphVertices, s: s, t: t)!
//        
//        while let path = augmentingPath(rGraphVertices, s: s, t: t) {
//            print("1")
//            var pathFlow = INT_MAX
//            var tmpVertice = t
//            var i = path.count - 1
//            print("s: ", s.getX(), ", ", s.getY())
//
//            while tmpVertice != s {
//                print("tmpVertice: ", tmpVertice.getX(), ", ", tmpVertice.getY())
//
//                print("2")
//                pathFlow = min(pathFlow, Int32(path.last!.getCapacity()))
//                tmpVertice = path[i].getStartpoint()
//                i -= 1
//            }
//            
//            tmpVertice = t
//            i = path.count - 1
//            
//
//            while tmpVertice != s {
//                print("3")
//                path[i].setCapacity(path[i].getCapacity() + Int(pathFlow))
//                path[i].setFlow(path[i].getFlow() - Int(pathFlow))
//                tmpVertice = path[i].getStartpoint()
//                i -= 1
//            }
//            
//            maxFlow += Int(pathFlow)
//        }
//    
//        return maxFlow
//        
//    }
//    
//    func augmentingPath(rGraph: [Vertice], s: Vertice, t: Vertice) -> [Edge]? {
////        var q: [Vertice]
//        var path: [Edge] = [Edge]()
//        
////        q.append(s)
//        s.setUsed(true)
//        
//        var tmpEdges = t.getIncomingEdges()
//        var tmpEdge = tmpEdges[0]
//        
//        path
//        while tmpEdge.getStartpoint() != s {
//            print("4")
//            print("TmpEdge: ", tmpEdge.getFlow(), "/ ", tmpEdge.getCapacity())
//            if tmpEdge.getFlow() > tmpEdge.getCapacity() {
//                path.append(tmpEdge)
//                for edge in tmpEdge.getStartpoint().getIncomingEdges() {
//                    if tmpEdge.getFlow() > tmpEdge.getCapacity() {
//                        tmpEdge = edge
//                        break
//                    }
//                }
//            } else {
//                for edge in tmpEdge.getStartpoint().getIncomingEdges() {
//                    if tmpEdge.getFlow() > tmpEdge.getCapacity() {
//                        tmpEdge = edge
//                        break
//                    } else {
//                        tmpEdge = s.getOutgoingEdges().first!
//                    }
//                }
//            }
//        }
//        
//        return path
//    }
//
//}



// bool bfs(int rGraph[V][V], int s, int t, int parent[])
// {
// // Create a visited array and mark all vertices as not visited
// bool visited[V];
// memset(visited, 0, sizeof(visited));
// 
// // Create a queue, enqueue source vertex and mark source vertex
// // as visited
// queue <int> q;
// q.push(s);
// visited[s] = true;
// parent[s] = -1;
// 
// // Standard BFS Loop
// while (!q.empty())
// {
// int u = q.front();
// q.pop();
// 
// for (int v=0; v<V; v++)
// {
// if (visited[v]==false && rGraph[u][v] > 0)
// {
// q.push(v);
// parent[v] = u;
// visited[v] = true;
// }
// }
// }
// 
// // If we reached sink in BFS starting from source, then return
// // true, else false
// return (visited[t] == true);
// }
