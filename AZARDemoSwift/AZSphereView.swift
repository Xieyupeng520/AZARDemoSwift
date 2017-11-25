//
//  Created by cocozzhang on 2017/11/25.
//  Copyright © 2017年 cocozzhang. All rights reserved.
//

import Foundation
import ARKit

class AZSphereView : UIView, ARSCNViewDelegate {
    var sceneView: ARSCNView = ARSCNView()
    var session: ARSession = ARSession()
    let configuration = ARWorldTrackingConfiguration()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        sceneView.frame = self.bounds
        self.addSubview(sceneView)
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
        sceneView.session = session
        
        //添加一个地球到当前场景
        let sphere = SCNSphere(radius: 0.1) //球体 //单位：米
        let material = SCNMaterial() //渲染器
        material.diffuse.contents =  UIImage(named: "earth-diffuse.jpg") //平铺
        //        material.multiply.contents = UIImage(named: "earth-diffuse.jpg")
        material.emission.contents = UIImage(named: "earth-emissive-mini") //夜光
        material.specular.contents = UIImage(named: "earth-specular-mini") //镜面
        sphere.materials = [material] //渲染到球体上
        let sphereNode = SCNNode(geometry:sphere)
        sphereNode.position = SCNVector3(0,-0.5,-0.5)
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    func start() {
        sceneView.session.run(configuration)
    }
    
    func pause() {
        sceneView.session.pause()
    }
}
