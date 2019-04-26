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
    
    let dimension = 125
    let width = 150
    let height = 300
    let cycles = 1000
    let delay = 20.0
    var scene: GameScene!
    @IBOutlet weak var rerunButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    @IBAction func rerunButtonPressed(_ sender: Any) {
        setup()
    }
    
    private func setup() {
        let skView = view as! SKView
        
        let protoSquare = ProtoSquare(width: width, height: height, cycles: cycles, delay: delay)
        scene = GameScene(size: skView.bounds.size, square: protoSquare)
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        rerunButton.isHidden = false
        
        beginGame()
        
        //view.screenGrab()?.writeToFile(fileName: "newBody.png")
    }
    
    private func beginGame() {
        scene.attachSpritesTo(square: scene.protoSquare!)
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

extension UIView {
    func screenGrab() -> UIImage? {
        // Uncomment this (and comment out the next statement) for retina screen capture
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        //UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImage {
    func writeToFile(fileName:String) {
        let jpegData = self.pngData()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
        
        do {
            try jpegData?.write(to: fileURL, options: .atomic)
        } catch {
            print(error)
        }
    }
}
