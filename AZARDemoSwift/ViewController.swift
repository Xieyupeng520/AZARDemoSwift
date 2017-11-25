//
//  ViewController.swift
//  AZARDemoSwift
//
//  Created by cocozzhang on 2017/11/25.
//  Copyright © 2017年 cocozzhang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var vectorStart = SCNVector3()
    var vertorEnd = SCNVector3()
    var isMeasuring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//

//
//        //添加一个地球到当前场景
//        let sphere = SCNSphere(radius: 0.1) //球体
//        let material = SCNMaterial() //渲染器
//        material.diffuse.contents =  UIImage(named: "earth-diffuse.jpg") //平铺
////        material.multiply.contents = UIImage(named: "earth-diffuse.jpg")
//        material.emission.contents = UIImage(named: "earth-emissive-mini") //夜光
//        material.specular.contents = UIImage(named: "earth-specular-mini") //镜面
//        sphere.materials = [material] //渲染到球体上
//        let sphereNode = SCNNode(geometry:sphere)
//        sphereNode.position = SCNVector3(0,-0.5,-0.5)
//        scene.rootNode.addChildNode(sphereNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    //将tranform(4x4矩阵)转换成SCNVector3
    func positionOfTranform(_ tranform:matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(tranform.columns.3.x,tranform.columns.3.y, tranform.columns.3.z)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMeasuring = !isMeasuring
    }
    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let sphere = SCNSphere(radius: 0.1) //球体 //单位：米
        let material = SCNMaterial() //渲染器
        material.diffuse.contents =  UIImage(named: "earth-diffuse.jpg") //平铺
        //        material.multiply.contents = UIImage(named: "earth-diffuse.jpg")
        material.emission.contents = UIImage(named: "earth-emissive-mini") //夜光
        material.specular.contents = UIImage(named: "earth-specular-mini") //镜面
        sphere.materials = [material] //渲染到球体上
        let sphereNode = SCNNode(geometry:sphere)
        sceneView.scene.rootNode.addChildNode(sphereNode)
        return sphereNode
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard isMeasuring else {
            return
        }
        //1.得到三维坐标
        let results = sceneView.hitTest(self.view.center, types: [.featurePoint]) //ARHitTestResult.ResultType.featurePoint
        guard let result = results.first else {
            return
        }
        if vectorStart == self.positionOfTranform(result.worldTransform) {
            return
        }
//        if vectorStart == SCNVector3Zero {
            vectorStart = self.positionOfTranform(result.worldTransform)
//        }
        Line(startVector: vectorStart, inView: sceneView)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
