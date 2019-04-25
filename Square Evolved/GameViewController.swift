//
//  GameViewController.swift
//  Square Evolved
//
//  Created by Artem Koloskov on 24/04/2019.
//  Copyright © 2019 Artem Koloskov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let dimension = 50
    let cycles = 500
    let delay = 20.0
    var sceneNode: GameScene?
    var protoSquare: ProtoSquare?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        protoSquare = ProtoSquare(dimension: dimension, cycles: cycles, delay: delay)
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            sceneNode = scene.rootNode as! GameScene?
            
            if sceneNode != nil {
                // Copy gameplay related content over to the scene
                sceneNode!.entities = scene.entities
                sceneNode!.graphs = scene.graphs
                sceneNode!.protoSquare = protoSquare
                sceneNode!.cellWidth = CGFloat((Double(sceneNode!.size.width) - 10 * 2) / Double(protoSquare!.squareDimension))
                sceneNode!.cellHeight = sceneNode!.cellWidth
                
                // Set the scale mode to scale to fit the window
                sceneNode!.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
                
                beginGame()
            }
        }
    }
    
    private func beginGame() {
        sceneNode!.attachSpritesTo(square: protoSquare!)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
