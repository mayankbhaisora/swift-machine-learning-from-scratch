//
//  GameScene.swift
//  The First Neuron
//
//  Created by Mayank Bhaisora on 19/03/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    typealias CoordinateTupple = (x: Double, y: Double)
    
    private let canvasWidth: Double = 800
    private let canvasHeight: Double = 800
    
    // Colors of the trained and untrained points in coordinate based on the team value (-ve or +ve)
    private var teamPositiveColorUntrained: UIColor = .yellow
    private var teamNegativeColorUntrained: UIColor = .black
    private var teamPositiveColorTrained: UIColor = .red
    private var teamNegativeColorTrained: UIColor = .blue
    
    override func didMove(to view: SKView) {
        
//        self.backgroundColor = UIColor.init(red: 255, green: 191, blue: 0, alpha: 1)
        self.backgroundColor = .lightGray
        
        self.addResetButton()
//        self.addTrainButton()
        
        self.drawAxis()
        self.drawSeparatingLine()
        
        self.drawUntrainedCoordinates()
        self.drawTrainedCoordinates()
    }
    
    func touchDown(atPoint pos : CGPoint) { }
    func touchMoved(toPoint pos : CGPoint) { }
    func touchUp(atPoint pos : CGPoint) { }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func update(_ currentTime: TimeInterval) {
        
    }
}

extension GameScene {
    
    /// This function draws the axis on the screen
    func drawAxis() {
        let node = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -canvasWidth / 2, y: 0))
        path.addLine(to: CGPoint(x: canvasWidth / 2, y: 0))
        path.move(to: CGPoint(x: 0, y: -canvasHeight / 2))
        path.addLine(to: CGPoint(x: 0, y: canvasHeight / 2))
        node.path = path
        node.strokeColor = SKColor.darkGray
        addChild(node)
    }
    
    /// This function draws a line to divide the screen in two areas each for specific team (-1 or 1)
    func drawSeparatingLine() {
        let node = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -canvasWidth / 2, y: -canvasHeight / 2))
        path.addLine(to: CGPoint(x: canvasWidth / 2, y: canvasHeight / 2))
        node.path = path
        node.strokeColor = .black
        addChild(node)
    }
    
    /// This method draws the coordinates without using the training data so the points will be random all across the plane
    func drawUntrainedCoordinates() {
        let indexes = Helper.getArray(from: 0..<100)
        let randomCoordinates = indexes.map { (index) -> CoordinateTupple in
            return (x: Helper.getRandomNumber(between: -canvasWidth / 2, and: canvasWidth / 2), y: Helper.getRandomNumber(between: -canvasHeight / 2, and: canvasHeight / 2))
        }
        
        for coordinate in randomCoordinates {
            let position = CGPoint(x: coordinate.x, y: coordinate.y)
            
//            let teamNumber = self.getTeamNumber(for: coordinate)
            let randomWeight = (x: Helper.getRandomNumber(between: -1, and: 1), y: Helper.getRandomNumber(between: -1, and: 1))
            let teamNumber = self.guess(weight: randomWeight, coordinate: coordinate)
            
            let node = SKShapeNode.init(rectOf: CGSize.init(width: 4, height: 4), cornerRadius: 2)
            node.name = "coordinatePointUntrained"
            node.lineWidth = 3
            node.position = position
            node.strokeColor = teamNumber == 1 ? teamPositiveColorUntrained : teamNegativeColorUntrained
            self.addChild(node)
        }
    }
    
    /// This method draws the coordinates using the training data
    func drawTrainedCoordinates() {
        let indexes = Helper.getArray(from: 0..<100)
        let randomCoordinates = indexes.map { (index) -> CoordinateTupple in
            return (x: Helper.getRandomNumber(between: -canvasWidth / 2, and: canvasWidth / 2), y: Helper.getRandomNumber(between: -canvasHeight / 2, and: canvasHeight / 2))
        }
        
        for coordinate in randomCoordinates {
            let position = CGPoint(x: coordinate.x, y: coordinate.y)
            
            let randomWeight = (x: Helper.getRandomNumber(between: -1, and: 1), y: Helper.getRandomNumber(between: -1, and: 1))
            
            // Getting the trained weight from random weight using the training set
            let trainedWeight = self.getTrainedWeight(randomWeight: randomWeight)
            // Neuron is guessing the teamNumber based on the trained weight
            let teamNumber = self.guess(weight: trainedWeight, coordinate: coordinate)
            
            let node = SKShapeNode.init(rectOf: CGSize.init(width: 4, height: 4), cornerRadius: 2)
            node.name = "coordinatePointTrained"
            node.lineWidth = 3
            node.position = position
            node.strokeColor = teamNumber == 1 ? teamPositiveColorTrained : teamNegativeColorTrained
            self.addChild(node)
        }
    }
    
    /// This button clears the coordinate points and redraws new points
    func addResetButton() {
        let button = ButtonNode(defaultButtonImage: "reset", activeButtonImage: "reset") {
            // On tapping the reset button
            // Clearing all the coordinate points
            self.clearCoordinatePoints()
            // Redrawing the untrained random nodes to show that the network is working
            self.drawUntrainedCoordinates()
            // Redrawing the trained random nodes
            self.drawTrainedCoordinates()
        }
        button.position = CGPoint(x: -200, y: -400)
        self.addChild(button)
    }
    
//    func addTrainButton() {
//        let button = ButtonNode(defaultButtonImage: "train", activeButtonImage: "train") {
//            // On tapping this button, it will train the weight for more points
////            self.drawTrainedCoordinates()
//        }
//        button.position = CGPoint(x: 200, y: -400)
//        self.addChild(button)
//    }
    
    /// This function clears all the trained and untrained coordinate points from the screen
    func clearCoordinatePoints() {
        // Removing Specific Children
        for child in self.children {
           //Determine Details
            if child.name == "coordinatePointUntrained" || child.name == "coordinatePointTrained" {
                child.removeFromParent()
            }
        }
    }
    
    /// Defined function to get the actual team number from the predefined condition. i.e. Team number in this case
    // We use this function only to train the neural net as we have to pass the actual result for training
    func getTeamNumber(for coordinate: CoordinateTupple) -> Double {
        return coordinate.x > coordinate.y ? 1 : -1
    }
    
    // Neural net usages this guess function to decide the color of the point
    func guess(weight: CoordinateTupple, coordinate: CoordinateTupple) -> Double {
        let sum = coordinate.x * weight.x + coordinate.y * weight.y
        return sum >= 0 ? 1 : -1
    }
    
    /// Function to train the weight and returns new corrected weight
    func train(weight: CoordinateTupple, coordinate: CoordinateTupple, team: Double) -> CoordinateTupple {
        // Guessing the result through neuron
        let guessedResult = self.guess(weight: weight, coordinate: coordinate)
        // Calculating the difference between error and the guessed result
        let error = team - guessedResult
        // Returning the updated weight based on error
        return (x: weight.x + (coordinate.x * error), y: weight.y + (coordinate.y * error))
    }
    
    /// This function returns the trained weight from the given random weight using training data
    func getTrainedWeight(randomWeight: CoordinateTupple) -> CoordinateTupple {
        // Generating random coordinates for training data
        /// MARK - Larger the training set, the network is trained better. For example if we change numberOfTrainingPoints to small numbers, then the error will be higher and the points will not be colored properly
        let numberOfTrainingPoints = 1000
        let indexes = Helper.getArray(from: 0..<numberOfTrainingPoints)
        let randomCoordinates = indexes.map { (index) -> CoordinateTupple in
            return (x: Helper.getRandomNumber(between: -canvasWidth / 2, and: canvasWidth / 2), y: Helper.getRandomNumber(between: -canvasHeight / 2, and: canvasHeight / 2))
        }
        
        // Assigning the random weight as initial weight
        var trainedWeight = randomWeight
        // Looping through all the random points
        for coordinate in randomCoordinates {
            
            // Passing the weight, coordinate and the actual team in the train function
            // To calculate the actual team, we are using getTeamNumber function which manually calculates the actual team
            // Assigning the new slightly corrected weight to the existing trainedWeight variable
            trainedWeight = self.train(weight: trainedWeight, coordinate: coordinate, team: self.getTeamNumber(for: coordinate))
        }
        return trainedWeight
    }
}
