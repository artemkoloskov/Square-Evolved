//
//  GameScene.swift
//  Square Evolved
//
//  Created by Artem Koloskov on 24/04/2019.
//  Copyright © 2019 Artem Koloskov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var protoSquare: ProtoSquare!
    
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    
    private let gameLayer = SKNode()
    private let cellsLayer = SKNode()
    private let padding: CGFloat = 10
    
    private var lastUpdateTime : TimeInterval = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    convenience init(size: CGSize, square: ProtoSquare) {
        self.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        protoSquare = square
        
        cellWidth = (CGFloat(size.width) - padding * 2) / CGFloat(protoSquare.bodyArray.columns)
        cellHeight = (CGFloat(size.height) - padding * 2) / CGFloat(protoSquare.bodyArray.rows)
        
        let background = SKSpriteNode(color: UIColor.white, size: size)
        background.zPosition = 1
        addChild(background)
        
        gameLayer.position = CGPoint(x: -size.width / 2.0, y: -size.height / 2.0)
        gameLayer.zPosition = 2
        addChild(gameLayer)
        
        cellsLayer.position = CGPoint( x: padding, y: padding)
        cellsLayer.zPosition = 3
        gameLayer.addChild(cellsLayer)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    func attachSpritesTo (square: ProtoSquare) -> Void {
        for i in 0..<square.bodyArray.rows {
            for j in 0..<square.bodyArray.columns {
                var sprite: SKSpriteNode
                
                if square.bodyArray[i,j]! {
                    sprite = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: cellWidth, height: cellHeight))
                    sprite.position = pointFor(column: i, row: j)
                    
                    cellsLayer.addChild(sprite)
                }
            }
        }
    }
    
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(row) * cellWidth + cellWidth / 2,
            y: CGFloat(column) * cellHeight + cellHeight / 2)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        protoSquare.evolveArray()
        
        cellsLayer.removeAllChildren()
        
        attachSpritesTo(square: protoSquare)
    }
}
