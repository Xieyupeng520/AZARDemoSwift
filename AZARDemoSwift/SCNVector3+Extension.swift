//
//  SCNVector3+Extension.swift
//  AZARDemoSwift
//
//  Created by cocozzhang on 2017/11/25.
//  Copyright © 2017年 cocozzhang. All rights reserved.
//

import ARKit

extension SCNVector3: Equatable {
    
    public static func == (lhs:SCNVector3, rhs:SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
    
    func disatance(to vector:SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        
        return sqrt(pow(distanceX,2)+pow(distanceY,2)+pow(distanceZ, 2))
    }
}
