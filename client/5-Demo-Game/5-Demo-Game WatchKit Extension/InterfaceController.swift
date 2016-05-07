//
//  InterfaceController.swift
//  5-Demo-Game WatchKit Extension
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    @IBOutlet var scroller: WKInterfacePicker!

    @IBOutlet var spacer: WKInterfaceGroup!
    @IBOutlet var enemySpacer: WKInterfaceGroup!
    
    @IBOutlet var paddle: WKInterfaceButton!
    @IBOutlet var enemyPaddle: WKInterfaceButton!
    
    @IBOutlet var ball: WKInterfaceButton!
    @IBOutlet var verticalBallSpacer: WKInterfaceGroup!
    @IBOutlet var horizontalBallSpacer: WKInterfaceGroup!
    

    let paddleHeight: CGFloat = 30
    let ballHeight: CGFloat = 10

    let canvasBounds = (top : 0 as CGFloat, left : 0 as CGFloat, bottom : 162 as CGFloat, right : 130 as CGFloat)
    
    var enemyPlayerWaiting: Bool = false
    
    var playerTurn = Player.A
    var score = [Player.A: 0, Player.B: 0]
    
    var paddlePosition: CGFloat = 0
    var enemyPaddlePosition: CGFloat = 0
    var ballPosition = (x : 0 as CGFloat, y: 0 as CGFloat)
    
    @IBAction func didScrollDigitalCrown(value: Int) {
        //set paddle position to 1-100% of available space
        paddlePosition = (CGFloat(value)/100)*(canvasBounds.bottom - paddleHeight)
        spacer.setHeight(paddlePosition)
        
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        //allows for scrolling paddle, 1-100% scrolled
        var pickerItems: [WKPickerItem] = []
        for _ in 1...100 {
            pickerItems.append(WKPickerItem())
        }
        scroller.setItems(pickerItems)
        
        //start round with random ball direction
        startGame()
    }
    
    func startGame() {
        delay(1) {
            self.resetBoard()
            self.score = [Player.A : 0, Player.B : 0]
            self.startRound(CGFloat.random(min: 1, max: 3))
        }
    }
    //reset board state between rounds
    func resetBoard() {
        //reset all positions and locations to 0 (except user paddle position)
        enemyPlayerWaiting = false
        ballPosition = (x: 0, y: 0)
        enemyPaddlePosition = 0
        
        horizontalBallSpacer.setRelativeWidth(0, withAdjustment: 0)
        verticalBallSpacer.setRelativeHeight(0, withAdjustment: 0)
        enemySpacer.setRelativeHeight(0, withAdjustment: 0)
    }
    //starts a round of pong
    func startRound(slope : CGFloat = 3) {
        enemyPlayerWaiting = true //enemy always goes first, so wait
        startEnemyPlayer()        //move enemy around in the meantime
        
        //move the ball at passed slope
        moveBallAtSlope(slope) {
            //get slope ball should be returned at if it was hit
            if let slope = self.wasBallHit() {
                //move ball at new slope
                self.startRound(slope)
            }
            //ball was missed, start new round or gameover
            else {
                self.handleLoss()
            }
        }
    }
    //not-very-smart enemy player; shuffles around center when waiting
    func startEnemyPlayer() {
        delay(0) {
            //first enemy paddle move to center
            let paddleAtCenter = (self.canvasBounds.bottom/2) - self.paddleHeight/2
            self.animateWithDuration(1, animations: {
                self.enemySpacer.setHeight(self.enemyPaddlePosition)
            }) {
                //enemy is moved to center
                self.enemyPaddlePosition = paddleAtCenter
                
                enum Direction {
                    case Up, Down
                }
                
                //helper for shuffling it around the center
                func shuffle(direction : Direction) {
                    if self.enemyPlayerWaiting { //only continue while we're supposed to be waiting, else exit immediately
                        //pick a random destination, either up or down
                        let destination = direction == Direction.Up
                            ? paddleAtCenter - CGFloat.random(min: -10, max: 50)
                            : paddleAtCenter + CGFloat.random(min: -10, max: 50)
                        
                        //pick a random speed
                        let time = Double.random(min: 0.5, max: 1.5)
                        
                        //move to random destination at random speed
                        self.animateWithDuration(time, animations: {
                            self.enemySpacer.setHeight(destination)
                        }) {
                            //update our tracker
                            self.enemyPaddlePosition = destination
                            
                            //shuffle in opposite direction
                            if direction == Direction.Up {
                                shuffle(Direction.Down)
                            } else {
                                shuffle(Direction.Up)
                            }
                        }
                    } else {
                        return
                    }
                }
                
                //begin shuffle
                shuffle(Direction.Up)
            }
        }
    }
    //move ball at slope; recurses until board crossed
    func moveBallAtSlope(slope : CGFloat, completion: (() -> Void)?) {
        //calculate next point
        var nextX = playerTurn == Player.A ? canvasBounds.right : canvasBounds.left
        var nextY = ballPosition.y - slope*(ballPosition.x - nextX)
        
        //guard against boundaries
        if nextY > canvasBounds.bottom || nextY < canvasBounds.top {
            nextY = nextY > canvasBounds.bottom ? canvasBounds.bottom : canvasBounds.top
            nextX = (slope*ballPosition.x - (ballPosition.y - nextY))/slope
        }
        
        //calculate distance and speed
        let pointA = CGPointMake(nextX, nextY)
        let pointB = CGPointMake(ballPosition.x, ballPosition.y)
        let duration = NSTimeInterval(distance(pointA, pointB: pointB)/100)
        
        //if we're headed towards the enemy goal, start to move enemy
        if playerTurn == Player.B && (nextX == canvasBounds.right || nextX ==  canvasBounds.left) {
            enemyPlayerWaiting = false
            moveEnemyToGoal(nextY, time: duration)
        }
        
        //move the ball to our new point
        animateWithDuration(duration, animations: { () -> Void in
            self.horizontalBallSpacer.setWidth(nextX)
            self.verticalBallSpacer.setHeight(nextY)
        }) {
            //update the ball location
            self.ballPosition = (x: nextX, y: nextY)
            
            //if we've reached the other side, switch players and complete
            if nextX == self.canvasBounds.right || nextX ==  self.canvasBounds.left {
                self.playerTurn = self.playerTurn == Player.A ? Player.B : Player.A
                
                guard completion != nil else {
                    return
                }
                
                //completion handler
                completion?()
            }
                
                //else keep moving ball
            else {
                self.moveBallAtSlope(-slope, completion: completion)
            }
        }
        
    }
    //determines if ball was hit; returns angle to fire back if yes, nil if no
    func wasBallHit() -> CGFloat? {
        //Player B just went, check if they hit
        let paddleCenter = playerTurn == Player.B
            ? paddlePosition + paddleHeight/2
            : enemyPaddlePosition + paddleHeight/2
        let ballCenter   = ballPosition.y + ballHeight/2
        let offset       = ballCenter - paddleCenter
        
        //ball did not hit, return nil
        if abs(offset) > 25 {
            return nil
        }
            //HIT! return proper slope
        else {
            return playerTurn == Player.B ? -(offset/25 * 6) : (offset/25 * 6)
        }
    }
    //what we do when ball was not hit by player
    func handleLoss() {
        //play sound, reset the board
        WKInterfaceDevice().playHaptic(WKHapticType.Failure)
        //player A wins!
        if score[Player.A] == 4 && playerTurn == Player.B {
            //present an alert, ask user to play again
            presentAlertControllerWithTitle("Wow!", message: "AI Wins!", preferredStyle: WKAlertControllerStyle.ActionSheet, actions: [WKAlertAction(title: "Play Again", style: WKAlertActionStyle.Default, handler: startGame)])
        }
        //player B wins!
        else if score[Player.B] == 4 && playerTurn == Player.A {
            //present an alert, ask user to play again
            presentAlertControllerWithTitle("Cogratulations!", message: "You win!", preferredStyle: WKAlertControllerStyle.ActionSheet, actions: [WKAlertAction(title: "Play Again", style: WKAlertActionStyle.Default, handler: startGame)])
        }
        //no one wins yet, start new round
        else {
            if playerTurn == Player.A {
                //update score, show user interstitial alert
                score[Player.B] = score[Player.B]! + 1
                presentControllerWithName("AlertController", context: ["delegate" : self, "text" : "Win!\n\(score[Player.A]!)-\(score[Player.B]!)", "positive" : true])
            } else {
                //update score, show user interstitial alert
                score[Player.A] = score[Player.A]! + 1
                presentControllerWithName("AlertController", context: ["delegate" : self, "text" : "Fail!\n\(score[Player.A]!)-\(score[Player.B]!)", "positive" : false])
            }
        }
    }
    //calculates distance from pointA to pointB
    func distance(pointA : CGPoint, pointB : CGPoint) -> CGFloat {
        return sqrt(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2))
    }
    //moves enemy paddle towards the goal spot, limited by speed of ball
    func moveEnemyToGoal(destination : CGFloat, time : NSTimeInterval) {
        let pointA = CGPointMake(destination, 0)
        let pointB = CGPointMake(enemyPaddlePosition, 0)
        let duration = NSTimeInterval(distance(pointA, pointB: pointB)/100) //limits to speed of ball
        
        //animate to new point
        animateWithDuration(duration, animations: {
            self.enemySpacer.setHeight(destination)
        }) {
            //update our position after animation
            self.enemyPaddlePosition = destination
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    override func didDeactivate() {
        super.didDeactivate()
    }
}

extension WKInterfaceController {
    func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, completion: (() -> Void)?) {
        animateWithDuration(duration, animations: animations)
        let completionDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(completionDelay, dispatch_get_main_queue()) {
            completion?()
        }
    }
}

extension InterfaceController: AlertControllerDelegate {
    //called when alert dismisses, starts new round after 1s delay
    func alertControllerWillDismiss() {
        dispatch_async(dispatch_get_main_queue()) {
            self.resetBoard()
            //computer always starts round
            self.playerTurn = Player.A
            delay(1) {
                self.startRound()
            }
        }
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard message["interact"] as? [String:String] != nil else {return}
        
        let interactiveMsg = message["interact"] as! [String : String]
        let value = CGFloat((interactiveMsg["pinchStrength"]! as NSString).floatValue)
        
        paddlePosition = value*(canvasBounds.bottom - paddleHeight)
        spacer.setHeight(paddlePosition)
        
    }
}