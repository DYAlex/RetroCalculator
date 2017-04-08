//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Mark Price on 7/15/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var outputLbl: UILabel!

    var btnSound: AVAudioPlayer!
    var btnClearSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
        
        let pathClear = Bundle.main.path(forResource: "jet-whoosh", ofType: "wav")
        let soundClearURL = URL(fileURLWithPath: pathClear!)
        
        do {
            try btnClearSound = AVAudioPlayer(contentsOf: soundClearURL)
            btnClearSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        currentOperation = Operation.Empty
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        result = ""
        outputLbl.text = "0"
        playClearSound()
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func playClearSound() {
        if btnClearSound.isPlaying {
            btnClearSound.stop()
        }
        
        btnClearSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            //A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }


}

