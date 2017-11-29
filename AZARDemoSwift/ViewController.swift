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
    
    var curLine:Line?
    
    var targetView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        targetView.center = self.view.center
        self.view.addSubview(targetView)
        targetView.layer.borderColor = UIColor.white.cgColor
        targetView.layer.borderWidth = 2
        targetView.layer.cornerRadius = 5
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMeasuring{
            if curLine != nil {
                curLine = nil
                vectorStart = SCNVector3Zero
            }
        }
        
        isMeasuring = !isMeasuring
    }
    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard isMeasuring else {
            return
        }
        //1.得到三维坐标
        let results = sceneView.hitTest(self.view.center, types: [.featurePoint]) //ARHitTestResult.ResultType.featurePoint
        guard let result = results.first else {
            return
        }
        let worldPosition = self.positionOfTranform(result.worldTransform)
        if vectorStart == worldPosition {
            return
        }
        if vectorStart == SCNVector3Zero {
            vectorStart = worldPosition
            curLine = Line(startVector: vectorStart, inView: sceneView)
        }
        curLine?.lineTo(worldPosition)
    }
    
    //将tranform(4x4矩阵)转换成SCNVector3
    func positionOfTranform(_ tranform:matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(tranform.columns.3.x,tranform.columns.3.y, tranform.columns.3.z)
    }
}
