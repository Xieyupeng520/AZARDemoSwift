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
    
    init(startVector:SCNVector3, inView:ARSCNView) {
        self.startVector = startVector
        self.inView = inView
        
        let dot = SCNSphere(radius:0.01)
        dot.firstMaterial?.diffuse.contents = UIColor.white
        
        startNode = SCNNode(geometry:dot)
        startNode.position = startVector
        
        inView.scene.rootNode.addChildNode(startNode)
    }
}
