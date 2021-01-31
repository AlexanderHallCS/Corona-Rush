//
//  ViewController.swift
//  EchoAR-iOS-SceneKit
//
//  Copyright © echoAR, Inc. 2018-2020.
//
//  Use subject to the Terms of Service available at https://www.echoar.xyz/terms,
//  or another agreement between echoAR, Inc. and you, your company or other organization.
//
//  Unless expressly provided otherwise, the software provided under these Terms of Service
//  is made available strictly on an “AS IS” BASIS WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.
//  Please review the Terms of Service for details on these and other terms and conditions.
//
//  Created by Alexander Kutner.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var coronaLeftLabel: UILabel!
    
    var e:EchoAR!;
    
    //var childrenNodes: [SCNNode] = []
    
    var seconds = 30.0
    var inGameTimer = Timer()
    
    var coronaCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        //let scene = SCNScene(named: "art.scnassets/River otter.usdz")!
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        let e = EchoAR();
        let scene = SCNScene()
        e.loadAllNodes(){ (nodes) in
            for node in nodes{
                //node.name = "\(coronaCounter)"
                //childrenNodes.append(node)
                scene.rootNode.addChildNode(node);
                coronaCounter += 1
            }
        }
        
        startTimer()
        coronaLeftLabel.text = "Coronaviruses Left: \(coronaCounter)"
        
        // Set the scene to the view
        sceneView.scene=scene;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    /*func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    } */
    
    private func startTimer() {
        let attributes: [NSAttributedString.Key:Any] = [.strokeColor: #colorLiteral(red: 0.1665180378, green: 1, blue: 0.2744433064, alpha: 1), .foregroundColor: #colorLiteral(red: 0.02326852587, green: 0.5836131899, blue: 0.01616205207, alpha: 1), .strokeWidth: -4.0]
        timerLabel.attributedText = NSAttributedString(string: "\(Int(seconds))", attributes: attributes)
        inGameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            if self.seconds > -1.0 {
                if Double(String(String(self.seconds).split(separator: ".")[1].first!))! == 0.0 {
                    self.timerLabel.attributedText = NSAttributedString(string: "\(Int(self.seconds))", attributes: attributes)
                }
                self.seconds -= 0.1
            } else {
                self.timerLabel.attributedText = NSAttributedString(string: "0", attributes: attributes)
                self.inGameTimer.invalidate()
                // game over
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let viewTouchLocation:CGPoint = touch.location(in: sceneView)
        guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
            return
        }
        result.node.removeFromParentNode()
        coronaCounter -= 1
        coronaLeftLabel.text = "Coronaviruses Left: \(coronaCounter)"
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
