//
//  GameViewController.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/11/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var collisionBallRacket : UICollisionBehavior!
    var dynamicAnimator : UIDynamicAnimator!
    var viewRacket = Racket(frame: CGRect(x: 1, y: 1, width:1, height: 1))
    var gameBall = Ball(frame: CGRect(x: 1, y: 1, width:1, height: 1))
    var ballItemBehavior = UIDynamicItemBehavior()
    var brickItemBehavior = UIDynamicItemBehavior()
    var collisionDelegate: UICollisionBehaviorDelegate?
    var lastLocation = CGPoint(x: 0, y: 0)
    var racketBehavior = UIDynamicItemBehavior()
    var push = UIPushBehavior()
    var animator : UIDynamicAnimator!
    var arrayBricks = [Brick]()
    var arrayObstacles = [Satellite]()
    var obstacleItemBehavior = UIDynamicItemBehavior()
    let alertController = UIAlertController(title: "You lose!", message: "Congratulations. You lost the game and now earth and the entire universe have been destroyed.", preferredStyle: .actionSheet)
    var ballVelocityOnPause = CGPoint(x:0,y:0)
    let defaults = UserDefaults.standard
    @IBOutlet weak var labelPoints: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelPuntos: UILabel!
    @IBAction func buttonPause(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named:"pause"){
            print("1")
           ballVelocityOnPause = ballItemBehavior.linearVelocity(for: gameBall)
            ballItemBehavior.addLinearVelocity(CGPoint(x: -ballVelocityOnPause.x, y: -ballVelocityOnPause.y), for: gameBall)
            
            sender.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            viewRacket.isUserInteractionEnabled = false
            return
            
        }else if sender.currentImage == UIImage(named: "play"){
            ballItemBehavior.addLinearVelocity(CGPoint(x: ballVelocityOnPause.x, y: ballVelocityOnPause.y), for: gameBall)
           
            viewRacket.isUserInteractionEnabled = true
            sender.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            return
        }
        
    }
    var newRecord = [String:[String]]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        labelTotal.minimumScaleFactor = 0.3
        labelTotal.adjustsFontSizeToFitWidth = true
        labelPuntos.minimumScaleFactor = 0.3
        labelPuntos.adjustsFontSizeToFitWidth = true
        
        assignbackground()
        MusicPlayer.shared.startBackgroundMusic(musicToPlay: "gameMusic")
        MusicPlayer.shared.audioPlayer?.prepareToPlay()
        MusicPlayer.shared.audioPlayer?.play()
        var viewRacketWidth = 0
        var viewRacketHeight = 0
        if self.view.bounds.maxY/2 > 250{
            viewRacketWidth = 250
            viewRacketHeight = 90
        }else{
            viewRacketWidth = Int(self.view.bounds.maxY/2)
            viewRacketHeight = 50
        }
        viewRacket = Racket(frame: CGRect(x : Int(self.view.bounds.maxX/2 - self.view.bounds.maxY/4), y : Int(self.view.bounds.maxY-60), width: viewRacketWidth, height: viewRacketHeight))
        gameBall = Ball(frame: CGRect(x:self.view.bounds.midX, y: self.view.bounds.maxY - 130, width:40, height:30))
        self.dynamicAnimator = UIDynamicAnimator(referenceView : self.view)
        self.animator = UIDynamicAnimator(referenceView : self.view)
        
        self.collisionBallRacket = UICollisionBehavior()
        self.collision = UICollisionBehavior()
        self.view.addSubview(gameBall)
        //viewRacket.backgroundColor = UIColor(white:1,alpha:0.3);
        self.view.addSubview(viewRacket);
        viewRacket.isUserInteractionEnabled = true
        
        let gradient = CAGradientLayer()
        gradient.frame = viewRacket.bounds
        let gradientColorFinal = UIColor(red: 0/255, green: 134/255, blue: 244/255, alpha: 1.0)
        let gradientColorInitial = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1.0).cgColor
        
        gradient.colors = [gradientColorInitial, gradientColorFinal]
        //viewRacket.layer.insertSublayer(gradient, at: 0)
        borderCollision()
        ballRacketCollision()
        viewRacket.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: #selector(self.detectPan(_:))))
        
        brickItemBehavior.density = 100000
        
        ballItemBehavior.resistance = 0
        ballItemBehavior.friction = 0
        ballItemBehavior.elasticity = 1.0
        ballItemBehavior.allowsRotation = false
        
        ballItemBehavior.addItem(gameBall)
        push = UIPushBehavior(items: [gameBall], mode: .instantaneous)
        racketBehavior.density = 100000
        racketBehavior.addItem(viewRacket)
        
        dynamicAnimator.addBehavior(racketBehavior)
        dynamicAnimator.addBehavior(ballItemBehavior)
        dynamicAnimator.addBehavior(brickItemBehavior)
        dynamicAnimator.addBehavior(obstacleItemBehavior)
        obstacleItemBehavior.density = 100000
        
        alertController.addAction(UIAlertAction(title:"OK", style: .default, handler:  { action in self.performSegue(withIdentifier: "showScoreboard", sender: self) }))
        
        self.initializeBall()
        drawBricks()
   
    }
    override func viewWillDisappear(_ animated: Bool) {
        //MusicPlayer.shared.stopBackgroundMusic()
    }
    func ballRacketCollision(){
        self.collisionBallRacket.collisionMode = .everything
        self.dynamicAnimator.addBehavior(self.collisionBallRacket)
        self.collisionBallRacket.addItem(gameBall)
        collisionBallRacket.collisionDelegate = self
        self.collisionBallRacket.addItem(viewRacket)
    }
    func drawBricks(){
        let maxX = self.view.bounds.maxX
        let maxY = self.view.bounds.maxY - self.view.bounds.maxY/4
        let brickSizeX = 50
        let brickSizeY = 50
        
        
        let offsetX = maxX/20
        let spacingX = maxX/50
        let numCols = (maxX - 2 * offsetX)/(spacingX + CGFloat(brickSizeX))
        
        
        let offsetY = (maxY/20)
        let spacingY = maxY/40
        let numRows = (maxY - 2 * offsetY)/(spacingY + CGFloat(brickSizeY))
        
        
        
        var totalSpacingX : CGFloat = 0
        var totalSpacingY : CGFloat = 0
        
        
        for countRows in 0...Int(numRows/2){
            if countRows == 0{
                totalSpacingY += offsetY
            }else{
                totalSpacingY += (offsetY + 50)
            }
            for countCols in 0...Int(numCols-1){
                if countCols == 0{
                    totalSpacingX = offsetX
                }

                let brick = Brick(frame: CGRect(x : Int(totalSpacingX), y : Int(totalSpacingY), width: brickSizeX, height: brickSizeY))
                totalSpacingX += CGFloat(brickSizeX)
                totalSpacingX += CGFloat(spacingX)
                self.view.addSubview(brick)
                arrayBricks.append(brick)
                self.collision.addItem(brick)
                brickItemBehavior.addItem(brick)
            }
            totalSpacingX = 0
        }
        
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if item.isEqual(gameBall){
            ballAnimation()
            MusicPlayer.shared.startHitMusic(hitEffect: "hitWall")
        }
      
        if item.isEqual(gameBall) && identifier.debugDescription == "Optional(bottom)"{
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            
            self.present(alertController, animated: true, completion: nil)
           // self.present(alertController, animated: true, completion: nil)
            
            let formatter = DateFormatter()
            let score = Int(labelPoints.text!)!
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let stringDate = formatter.string(from: Date())
            var highestRecordID = 0
            var oldScoreRecords = [String:[String]]()
            if UserDefaults.standard.value(forKey: "recordScores") != nil {
                oldScoreRecords = UserDefaults.standard.value(forKey: "recordScores") as! [String : [String]]
                for (id, _) in oldScoreRecords  {
                    if Int(id)! > highestRecordID{
                        highestRecordID = Int(id)!
                    }
                }
                highestRecordID += 1
            }
            let stringHighestRecordID = String(highestRecordID)
            let recordInfo : [String] = [String(score), stringDate]
            oldScoreRecords[stringHighestRecordID] = recordInfo
            
            defaults.set(oldScoreRecords, forKey: "recordScores")
            self.collision.removeItem(gameBall)
                
        }

    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if (item1.isEqual(gameBall) && item2.isEqual(viewRacket)) || (item1.isEqual(viewRacket) && item2.isEqual(gameBall)) {
            ballAnimation()
        }
        if (item1.isEqual(gameBall) && item2.isKind(of: Brick.self)) || (item1.isKind(of: Brick.self) && item2.isEqual(gameBall)){
            let brick : Brick
            if item1.isKind(of: Brick.self){
                brick = item1 as! Brick
            }else{
                brick = item2 as! Brick
            }
            if let index = arrayBricks.firstIndex(of: brick){
                arrayBricks.remove(at: index)
                brick.removeFromSuperview()
            }
            self.collision.removeItem(brick)
            var totalPoints = Int(labelPoints.text!)!
            totalPoints += 1
            labelPoints.text = String(totalPoints)
            if totalPoints%10 == 0{
                drawObstacle()
            }
            
        }
        if (item1.isEqual(gameBall) && item2.isEqual(viewRacket)) || (item1.isEqual(viewRacket) && item2.isEqual(gameBall)) {
            var totalPoints = Int(labelPoints.text!)!
            totalPoints += 1
            labelPoints.text = String(totalPoints)
            if totalPoints%10 == 0{
                drawObstacle()
            }
            MusicPlayer.shared.startHitMusic(hitEffect: "hitRacket")
            let asteroidIndex = Int.random(in: 1...4)
            gameBall.image = UIImage(named: "asteroid\(asteroidIndex)")
        }
        ballAnimation()
    }
    func drawObstacle(){
        let obstacleCategory = Int.random(in: 1...3)
        var positionX : Int = 0
        var positionY : Int = 0
        var intersects = true
        let maxX = self.view.bounds.maxX
        let maxY = (self.view.bounds.maxY*2)/3
        var obstacleSize = 0
        var obstacleName = ""
        var obstacleRectangle : CGRect
        switch obstacleCategory{
            case 1:
                obstacleSize = 70
                obstacleName = "satellite3"
            case 2:
                obstacleSize = 100
                obstacleName = "satellite2"
            case 3:
                obstacleSize = 125
                obstacleName = "satellite1"
            default:
                obstacleSize = 100
                obstacleName = "satellite3"
        }
       
        repeat{
            intersects = false
            positionX = Int.random(in:1...Int(maxX)-obstacleSize)
            positionY = Int.random(in:1...Int(maxY)-50)
            obstacleRectangle = CGRect(x : positionX, y : positionY, width: obstacleSize, height: 50)
            for brick in arrayBricks{
                if obstacleRectangle.intersects(brick.frame){
                    intersects = true
                }
            }
            for obstacle in arrayObstacles{
                if obstacleRectangle.intersects(obstacle.frame){
                    intersects = true
                }
            }
        }while intersects
        
        let satellite = Satellite(frame: obstacleRectangle, imageName : obstacleName)
        self.view.addSubview(satellite)
        arrayObstacles.append(satellite)
        obstacleItemBehavior.addItem(satellite)
        self.collision.addItem(satellite)
        
    }
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        
        switch recognizer.state{
            case .began:
                lastLocation = viewRacket.center
            case .changed:
                let translation  = recognizer.translation(in: viewRacket.superview)
                if (lastLocation.x + translation.x) < (self.view.bounds.maxX + 0.3 * viewRacket.bounds.maxX)
                    && (lastLocation.x + translation.x) > (self.view.bounds.minX - 0.3 * viewRacket.bounds.maxX){
                    viewRacket.center = CGPoint(x: lastLocation.x + translation.x, y: viewRacket.center.y)
                    self.dynamicAnimator.updateItem(usingCurrentState: viewRacket)
                }
            default:
                let translation  = recognizer.translation(in: viewRacket.superview)
                if (lastLocation.x + translation.x) < (self.view.bounds.maxX + 0.3 * viewRacket.bounds.maxX)
                    && (lastLocation.x + translation.x) > (self.view.bounds.minX - 0.3 * viewRacket.bounds.maxX){
                    viewRacket.center = CGPoint(x: lastLocation.x + translation.x, y: viewRacket.center.y)
                }
            
        }
    }


    func borderCollision(){
        
        self.collision.addBoundary(withIdentifier: NSString("left"), from: CGPoint(x: 0, y: 0), to: CGPoint(x: 50, y: self.view.bounds.maxY + 50))
        self.collision.addBoundary(withIdentifier: NSString("right"), from: CGPoint(x: self.view.bounds.maxX, y: 0), to: CGPoint(x: self.view.bounds.maxX, y: self.view.bounds.maxY + 50))
        self.collision.addBoundary(withIdentifier: NSString("bottom"), from: CGPoint(x: -50, y: self.view.bounds.maxY), to: CGPoint(x: self.view.bounds.maxX + 50, y: self.view.bounds.maxY))
        self.collision.addBoundary(withIdentifier: NSString("top"), from: CGPoint(x: 0, y: 0), to: CGPoint(x: self.view.bounds.maxX, y: 0))
        self.collision.collisionMode = .everything
        self.dynamicAnimator.addBehavior(self.collision)
        self.collision.addItem(gameBall)
        collision.collisionDelegate = self
    }
    
    
    
    func assignbackground(){
        let background = UIImage(named: "background_game")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    func initializeBall() {
        dynamicAnimator?.addBehavior(pushForPosition(position: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY)))
    }
    
    func pushForPosition(position: CGPoint) -> UIPushBehavior {
        // This game is rigged, we can add user controls by using the `position` param
        push.angle = 1.5708
        push.magnitude = 0.02
        return push
    }
    
    func ballAnimation(){
        let linearVelocity = ballItemBehavior.linearVelocity(for: gameBall)
        if linearVelocity.x < 0{
            ballItemBehavior.addLinearVelocity(CGPoint(x: -350-linearVelocity.x,y:0), for: gameBall)
        }else if linearVelocity.x > 0{
            ballItemBehavior.addLinearVelocity(CGPoint(x: 350-linearVelocity.x,y:0), for: gameBall)
        }
        if linearVelocity.y < 0{
            ballItemBehavior.addLinearVelocity(CGPoint(x: 0,y:-350-linearVelocity.y), for: gameBall)
        }else if linearVelocity.y > 0{
            ballItemBehavior.addLinearVelocity(CGPoint(x: 0,y:350-linearVelocity.y), for: gameBall)
        }
   
        self.push.active = false;
        let multiplyingFactor = Int.random(in: -1 ... 1)
        let radians = atan2f(Float(gameBall.transform.b), Float(gameBall.transform.a));
        let currentAngle = Double(radians) * (180 / Double.pi);
        let oppositeAngle = CGFloat((currentAngle + Double.pi).truncatingRemainder(dividingBy: (2 * Double.pi)))
        let lower = oppositeAngle - CGFloat.degreeToRadian(degree: 12)
        let upper = oppositeAngle + CGFloat.degreeToRadian(degree: 12)
        push.angle = CGFloat.randomRadian(lower: lower, upper) * CGFloat(multiplyingFactor)
        self.push.active = true;
    }

}

private extension CGFloat {
    static func randomRadian(lower: CGFloat = 0, _ upper: CGFloat = CGFloat(2 * Double.pi)) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
    static func degreeToRadian(degree: Double) -> CGFloat {
        return CGFloat((degree * Double.pi)/180)
    }
}
