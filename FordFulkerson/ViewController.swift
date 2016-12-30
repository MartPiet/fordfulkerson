//
//  ViewController.swift
//  FordFulkerson
//
//  Created by Martin Pietrowski on 24.08.16.
//  Copyright © 2016 Martin Pietrowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var FFoneStepButton: UIButton!
    @IBOutlet weak var FFButton: UIButton!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var vertices = [Vertice]()
    var edges = [Edge]()
    var hasSelectedVertice = false
    var selectedVertice = Vertice()
    var labels = [UILabel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let tmpPoint = touch.location(in: self.view)
            if let tmpSelectedVertice = hasSelectedVertice(tmpPoint) {
                if hasSelectedVertice == false {
                    selectedVertice = tmpSelectedVertice
                    hasSelectedVertice = true
                } else if selectedVertice != tmpSelectedVertice {
                    drawEdge(tmpSelectedVertice)
                    hasSelectedVertice = false
                }
            } else {
                drawVertice(tmpPoint)
            }
        }
    }
    
    
    func drawVertice(_ point: CGPoint) {
        vertices.append(Vertice(inputX: Int(point.x), inputY: Int(point.y)))
        let verticeRadius = vertices.last!.getRadius()
        vertices.last!.setLabel(String(vertices.count))
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        // 2
        context?.addEllipse(in: CGRect(x: Int(point.x) - verticeRadius, y: Int(point.y) - verticeRadius, width: verticeRadius * 2, height: verticeRadius * 2))
        
        // 3
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    
    func drawEdge(_ endVertice: Vertice) {
        edges.append(Edge())
        var offset = calculatePositionOffset(angleOfTwoVertices(selectedVertice, point2: endVertice))
        offset = getOffsetDirected(offset.first!, offset: offset.last!)
        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))

        
        context?.move(to: CGPoint(x: CGFloat(selectedVertice.getX() + offset.first!), y: CGFloat(selectedVertice.getY() + (offset.last!))))
        context?.addLine(to: CGPoint(x: CGFloat(endVertice.getX() - offset.first!), y: CGFloat(endVertice.getY() - (offset.last!))))

        context?.setStrokeColor(UIColor.black.cgColor)
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        drawEndpointOfEdge(endVertice, offset: offset)
        
        edges.last!.setStartpoint(selectedVertice)
        edges.last!.setEndpoint(endVertice)
        edges.last!.setCapacity(Int(arc4random_uniform(9) + 1))
        selectedVertice.addOutgoingEdge(edges.last!)
        endVertice.addIncomingEdge(edges.last!)
        setLabelForEdge(edges.last!)
        
    }
    
    func drawEndpointOfEdge(_ vertice: Vertice, offset: [Int]) {        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.addEllipse(in: CGRect(x: CGFloat(vertice.getX() - offset.first!), y: CGFloat(vertice.getY() - offset.last!), width: 5, height: 5))
        context?.setLineWidth(brushWidth)
        context?.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
    
    func hasSelectedVertice(_ tmpPoint: CGPoint) -> Vertice? {
        for vertice in vertices {
            if vertice.isInRange(Int(tmpPoint.x), inputY: Int(tmpPoint.y)) {
                return vertice
            }
        }
        return nil
    }
    
    func angleOfTwoVertices(_ point1: Vertice, point2: Vertice) -> Double {
        let point1X = point1.getX()
        let point1Y = point1.getY()
        
        let point2X = point2.getX()
        let point2Y = point2.getY()
        
        let offset = whereIsPoint2FromPoint1(point1, point2: point2)
        
        print("point1X: ", point1X)
        print("point1Y: ", point1Y)
        print("point2X: ", point2X)
        print("point2Y: ", point2Y)
        
        print(pow(Double(point1X), 2.0))
        print(pow(Double(point1Y), 2.0))
        print(pow(Double(point2X), 2.0))
        print(pow(Double(point2Y), 2.0))
        
        let absPoint1 = sqrt(pow(Double(point1X), 2.0) + pow(Double(point1Y), 2.0))
        let absPoint2 = sqrt(pow(Double(point2X), 2.0) + pow(Double(point2Y), 2.0))

        let scalar = point1X * point2X + point1Y * point2Y
        
        print("Scalar: ", scalar)
        print("Double(scalar)", Double(scalar))
        print("absPoint1: ", absPoint1)
        print("absPoint2: ", absPoint2)
        let sum = Double(scalar) / (absPoint1 * absPoint2)
        
        print("Sum: ", sum)
        if sum < 1 && sum > -1 {
        print("cosh(sum): ", (acos(sum) * 180 / M_PI) + offset)
        }
        return ((acos(sum) * 180 / M_PI) + offset)
    }
    
    func whereIsPoint2FromPoint1(_ point1: Vertice, point2: Vertice) -> Double {
        let point1X = point1.getX()
        let point1Y = point1.getY()
        
        let point2X = point2.getX()
        let point2Y = point2.getY()
        
        
        let differenceX = point1X - point2X
        let differenceY = point1Y - point2Y
        
        if abs(differenceX) > abs(differenceY) {
            if differenceX < 0 {
                return 90
            } else {
                return 270
            }
        } else {
            if differenceY < 0 {
                return 0
            } else {
                return 180
            }
        }
    }
    
    func calculatePositionOffset(_ angle: Double) -> [Int] {
        var tmpAngle = angle
        var offset = 0
        var direction = 0
        
        while tmpAngle > 90 && direction < 3 {
            print("tmpAngle: ", tmpAngle)
            tmpAngle -= 90
            direction += 1
        }
  
        if tmpAngle == 0 {
            offset = 15
        } else {
            tmpAngle = abs(tmpAngle)
            while tmpAngle > 0 {
                tmpAngle -= 6
                offset += 1
            }
        }
        print("Offset: ", offset)
        print("Direction: ", direction)
        
        return [direction, offset]
    }
    
    func getOffsetDirected(_ direction: Int, offset: Int) -> [Int] {
        switch  direction {
        case 0:
            return [-offset, 15 - offset]
        case 1:
            return [15 - offset, offset]
        case 2:
            return [-offset, offset - 15]
        case 3:
            return [offset - 15, -offset]
        default:
            return [0, 0]
        }
    }
    
    func getCenterOfEdge(_ edge: Edge) -> [Double]{
        let startpoint = edge.getStartpoint()
        let endpoint = edge.getEndpoint()
        
        print("Startpoint: ", startpoint.getX(), ", ", startpoint.getY())
        print("Endpoint: ", endpoint.getX(), ", ", endpoint.getY())
        
        let startpointX = startpoint.getX()
        let startpointY = startpoint.getY()
        
        let endpointX = endpoint.getX()
        let endpointY = endpoint.getY()
        
        let centerpoint = [Double(startpointX + endpointX) / 2, Double(startpointY + endpointY) / 2]
    
        return centerpoint
    }
    
    func setLabelForEdge(_ edge: Edge) {
        let angle = angleOfTwoVertices(edge.getStartpoint(), point2: edge.getEndpoint())
        let offset = calculatePositionOffset(angle)
        let centerpoint = getCenterOfEdge(edge)
        var x = centerpoint.first!, y = centerpoint.last!
        
        switch  offset.first! {
        case 0:
            x -= 10
            y -= 10
        case 1:
            x += 5
            y -= 15
        case 2:
            x -= 15
//            y -= 25
        case 3:
            x += 5
            y += 15
        default:
            print("Fehler bei Labeloffset!")
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        label.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        label.textAlignment = NSTextAlignment.center
        label.text = String(edge.getFlow()) + "/" + String(edge.getCapacity())
        
        labels.append(label)

        self.view.addSubview(label)
    }

    
    
    func reloadLabels() {
        var i = 0
        for edge in edges {
            labels[i].text = String(edge.getFlow()) + "/" + String(edge.getCapacity())
            print(labels[i].text)
            i += 1
        }
    }

    func reloadLabel(_ index: Int) {
        let tmpEdge = edges[index]
        let newLabelText = String(tmpEdge.getFlow()) + ", " + String(tmpEdge.getCapacity())
        labels[index].text = newLabelText
    }
    
    func setLabelForVerticeIfNecessary() {
        //code
    }
    
    
    @IBAction func FFButton(_ sender: AnyObject) {
        print("Labels: ", labels.count, "/ Edges: ", edges.count)
        let ff = FordFulkerson(vertices: vertices, edges: edges)
        reloadLabels()
        
    }

}


