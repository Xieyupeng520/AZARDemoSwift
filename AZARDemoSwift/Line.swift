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
    
    var startVector:SCNVector3
    var startNode:SCNNode
    var endNode:SCNNode
    
    var lineNode:SCNNode?
    
    var color = UIColor.white
    
    init(startVector:SCNVector3, inView:ARSCNView) {
        self.startVector = startVector
        self.inView = inView
        
        let dot = SCNSphere(radius:0.001)
        dot.firstMaterial?.diffuse.contents = UIColor.white
        
        startNode = SCNNode(geometry:dot)
        startNode.position = startVector
        endNode = SCNNode(geometry:dot)
        endNode.position = startVector
        
        inView.scene.rootNode.addChildNode(startNode)
        inView.scene.rootNode.addChildNode(endNode)
    }
    
    func lineTo(_ vector:SCNVector3) {
        lineNode?.removeFromParentNode()
        lineNode = self.lineFrom(from: startVector, to: vector)
        
        inView.scene.rootNode.addChildNode(lineNode!)
        
        endNode.position = vector
    }
    
    func lineFrom(from fromVector:SCNVector3, to toVector:SCNVector3) -> SCNNode {
        let indices : [UInt32] = [0,1]//indices：一组索引值，每个索引值都标识几何源中的一个顶点(连接顶点的顺序)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        let source = SCNGeometrySource(vertices: [fromVector, toVector])
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        let node = SCNNode(geometry:geometry)
        return node
    }
}
