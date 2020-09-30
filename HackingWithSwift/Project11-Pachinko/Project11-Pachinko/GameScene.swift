//
//  GameScene.swift
//  Project11-Pachinko
//
//  Created by Alexander Karaatanasov on 9.05.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Vars
    
    var scoreLabel: SKLabelNode!
    
    var editLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        // making the balls bounce of the edges of the screen
        setupView()
        
        // adding the background image
        addBackground()
        
        // adding edit label
        addEditLabel()
        
        // adding score label
        addScoreLabel()
        
        // adding bouncers
        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 256, y: 0))
        addBouncer(at: CGPoint(x: 512, y: 0))
        addBouncer(at: CGPoint(x: 768, y: 0))
        addBouncer(at: CGPoint(x: 1024, y: 0))
        
        // adding slots
        addSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        addSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        addSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        addSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { // getting the first touch
            let location = touch.location(in: self) // getting the location of the touch
            let objects = nodes(at: location) // getting all the objects at that location
            
            // checing if what we clicked is the edit label
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    // adding a box
                    addBox(at: location)
                } else {
                    // adding a ball
                    addBall(at: location)
                }
            }
        }
    }
    
    // MARK: - UI methods
    
    private func setupView() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    private func addEditLabel() {
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
    }
    
    private func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
    }
    
    private func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    private func addSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    private func addBox(at location: CGPoint) {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
    }
    
    private func addBall(at location: CGPoint) {
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.restitution = 0.4
//        ball.position = location
        ball.position = CGPoint(x: location.x, y: 768)
        ball.name = "ball"
        addChild(ball)
    }
    
    // MARK: - Private
    
    private func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    private func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
}

// MARK: - SKPhysics Contact Delegate

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
