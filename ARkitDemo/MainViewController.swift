//
//  MainViewController.swift
//  ARkitDemo
//
//  Created by imac-3570 on 2023/10/11.
//

import UIKit
import ARKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vARSCNView: ARSCNView!
    
    // MARK: - Variables
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addBox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        vARSCNView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vARSCNView.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        print("hi")
    }
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        // Float 1 = 1公尺，產生一個 寬：0.1、高：0.1、長：0.1 的
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)

        // 新增一個叫 boxNode 的節點，代表位置與一物件在3D空間的座標
        let boxNode = SCNNode()
        boxNode.geometry = box
        
        // 座標設定，這個位置和相機有關係，以正x軸：右邊、負x軸：左邊、正Y軸：上方、負Y軸：下方、正Z軸：往後、負Z軸：往前
        boxNode.position = SCNVector3(x, y, z)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        vARSCNView.scene = scene
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        vARSCNView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    // MARK: - IBAction
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: vARSCNView)
        let hitTestResults = vARSCNView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = vARSCNView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
    
}

// MARK: - Extension

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

// MARK: - Protocol

