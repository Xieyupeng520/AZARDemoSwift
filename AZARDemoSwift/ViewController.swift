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
    var lines = [Line]()
    
    var targetView = UIView(frame:CGRect(x:0, y:0, width:12, height:12))
    var tipLabel = UILabel()
    
    var resetButton = UIButton()
    var undoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        self.view.addSubview(targetView)
        targetView.layer.borderColor = UIColor.white.cgColor
        targetView.layer.borderWidth = 1
        targetView.layer.cornerRadius = 6
        targetView.alpha = 0
        
        tipLabel.text = "正在初始化...请稍等"
        tipLabel.textColor = UIColor.white
        tipLabel.sizeToFit()
        self.view.addSubview(tipLabel)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.sizeToFit()
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        self.view.addSubview(resetButton)
        resetButton.alpha = 0
        
        undoButton.setTitle("Undo", for: .normal)
        undoButton.sizeToFit()
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        self.view.addSubview(undoButton)
        undoButton.alpha = 0
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
    
    override func viewWillLayoutSubviews() { //旋转屏幕时
        targetView.center = self.view.center
        tipLabel.center = self.view.center
        resetButton.center = CGPoint(x:self.view.center.x/2, y:self.view.bounds.size.height - 64)
        undoButton.center = CGPoint(x:self.view.bounds.size.width*3/4, y:self.view.bounds.size.height - 64)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMeasuring{ //不在测量态点击，进入测量态
            vectorStart = SCNVector3Zero //reset
        } else { //在测量态点击，终止测量态
            if let line = curLine {
                line.endLine()
                lines.append(line)
                curLine = nil
            }
        }
        
        isMeasuring = !isMeasuring
    }
    
    @objc func reset() {
        self.resetInit()
        
        for line in lines {
            line.remove()
        }
        lines.removeAll()
    }
    
    @objc func undo() {
        if let line = curLine {
            line.remove()
            self.resetInit()
            return
        }
        if let line = lines.last {
            line.remove()
            lines.removeLast()
        }
    }
    
    func resetInit() {
        vectorStart = SCNVector3Zero //reset
        isMeasuring = false
        curLine = nil
    }
    
    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            //1.得到三维坐标
            let results = self.sceneView.hitTest(self.view.center, types: [.featurePoint]) //ARHitTestResult.ResultType.featurePoint
            guard let result = results.first else { //得不到说明初始化不成功
                return
            }
            //2.计算世界坐标
            let worldPosition = self.positionOfTranform(result.worldTransform)
            if self.vectorStart == worldPosition { //防止同一个地方无限重绘
                return
            }
            
            if self.tipLabel.alpha != 0 {
                self.tipLabel.text = "可以点击屏幕了！"
                UIView.animate(withDuration: 1.5, animations: {
                    self.tipLabel.alpha = 0
                    self.targetView.alpha = 1
                    self.undoButton.alpha = 1
                    self.resetButton.alpha = 1
                })
            }
            guard self.isMeasuring else {
                return
            }

            if self.vectorStart == SCNVector3Zero {
                self.vectorStart = worldPosition
                self.curLine = Line(startVector: self.vectorStart, inView: self.sceneView)
            }
            self.curLine?.lineTo(worldPosition)
        }
    }
    
    //将tranform(4x4矩阵)转换成SCNVector3
    func positionOfTranform(_ tranform:matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(tranform.columns.3.x,tranform.columns.3.y, tranform.columns.3.z)
    }
    
}
