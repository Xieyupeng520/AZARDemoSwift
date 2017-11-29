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
}
