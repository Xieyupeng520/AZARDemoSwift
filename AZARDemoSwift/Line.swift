//
//  Line.swift
//  AZARDemoSwift
//
//  Created by cocozzhang on 2017/11/25.
//  Copyright © 2017年 cocozzhang. All rights reserved.
//

import ARKit
class Line {
    var inView:ARSCNView
    
    var startNode:SCNNode
    var endNode:SCNNode
    
    var lineNode:SCNNode?
    
    var color = UIColor.white
    
    var text:SCNText
    var textNode:SCNNode
    
    init(startVector:SCNVector3, inView:ARSCNView) {
        self.inView = inView
        
        let dot = SCNSphere(radius:0.001)
        dot.firstMaterial?.diffuse.contents = UIColor.white
        
        startNode = SCNNode(geometry:dot)
        startNode.position = startVector
        endNode = SCNNode(geometry:dot)
        endNode.position = startVector
        
        inView.scene.rootNode.addChildNode(startNode)
        inView.scene.rootNode.addChildNode(endNode)
        
        color = UIColor(red: CGFloat(arc4random_uniform(255))/254.0, green: CGFloat(arc4random_uniform(255))/254.0, blue: CGFloat(arc4random_uniform(255))/254.0, alpha: 1)
        
        //距离文字
        text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize:7)
        text.firstMaterial?.diffuse.contents = color
        text.firstMaterial?.lightingModel = .constant
        text.firstMaterial?.isDoubleSided = true
//        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle
        
        let textWrapperNode = SCNNode(geometry: text) //为什么要有这么一层？
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0) // 对着自己(旋转180)
        textWrapperNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0)
        
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        let constraint = SCNLookAtConstraint(target: inView.pointOfView) //约束
        constraint.isGimbalLockEnabled = true
        textNode.constraints = [constraint]
        inView.scene.rootNode.addChildNode(textNode)
    }
    
    func lineTo(_ vector:SCNVector3) {
        lineNode?.removeFromParentNode()
        lineNode = self.lineFrom(from: startNode.position, to: vector)
        
        inView.scene.rootNode.addChildNode(lineNode!)
        
        endNode.position = vector

        text.string = calculateDistance(to: vector)
        textNode.position = vector
    }
    
    func endLine() { //距离文字移到正中间(动画)
        let startVector = startNode.position
        let endVector = endNode.position
        
        let move = CABasicAnimation(keyPath: "position")
        move.duration = 2.0
        move.toValue = SCNVector3((startVector.x+endVector.x)/2.0, (startVector.y+endVector.y)/2.0, (startVector.z+endVector.z)/2.0)
        textNode.addAnimation(move, forKey: "move text mode")
        
    }
    
    func lineFrom(from fromVector:SCNVector3, to toVector:SCNVector3) -> SCNNode {
        let indices : [UInt32] = [0,1]//indices：一组索引值，每个索引值都标识几何源中的一个顶点(连接顶点的顺序)
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        let source = SCNGeometrySource(vertices: [fromVector, toVector])
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        let node = SCNNode(geometry:geometry)
        return node
    }
    
    func calculateDistance(to vector:SCNVector3) -> String {
        return String(format:"%0.2f m", startNode.position.disatance(to: vector))
    }
    
    func remove() {
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
}
