//
//  ProtoSquare.swift
//  Square Evolved
//
//  Created by Artem Koloskov on 24/04/2019.
//  Copyright © 2019 Artem Koloskov. All rights reserved.
//

import Foundation

class ProtoSquare {
    
    var squareDimension = 50
    var array: Array2D<Bool>
    var evolutionCycles = 1000
    var liveEvolutionDelay = 20.0
    
    let liveCell = "**"
    let deadCell = "  "
    
    
    
    init(dimension: Int, cycles: Int, delay: Double)
    {
        squareDimension = dimension
        evolutionCycles = cycles
        liveEvolutionDelay = delay
        
        array = Array2D<Bool>(columns: dimension, rows: dimension)
        
        for i in 0..<squareDimension {
            for j in 0..<squareDimension {
                array[i,j] = Bool.random()
            }
        }
        
        for i in 0...evolutionCycles {
            print("i: \(i)")
            
            printArray(array: array)
            
            evolveArray()
            
            //Thread.sleep(forTimeInterval: liveEvolutionDelay)
        }
    }
    
    func printArray(array: Array2D<Bool>) -> Void {
        for i in 0..<array.rows {
            var str = ""
            
            for j in 0..<array.columns {
                if (array[i, j]!) {
                    str.append(liveCell)
                }
                else {
                    str.append(deadCell)
                }
            }
            
            print(str)
        }
    }
    
    func evolveArray() -> Void {
        let oldState = array
        
        for i in 0..<array.rows {
            for j in 0..<array.columns {
                array[i, j] = checkNewState(oldState: oldState, i: i, j: j)
            }
        }
    }
    
    func checkNewState(oldState: Array2D<Bool>, i: Int, j: Int) -> Bool {
        var numOfAliveCells = 0
        
        for x in (i - 1)...(i + 1) {
            for y in (j - 1)...(j + 1) {
                var realI: Int
                var realJ: Int
                
                if (x < 0) {
                    realI = oldState.rows-1
                }
                else if (x > oldState.rows-1) {
                    realI = 0
                }
                else {
                    realI = x
                }
                
                if (y < 0) {
                    realJ = oldState.columns-1
                }
                else if (y > oldState.columns-1) {
                    realJ = 0
                }
                else {
                    realJ = y
                }
                
                if (realI != i || realJ != j) {
                    if (oldState[realI, realJ]!) {
                        numOfAliveCells += 1
                    }
                }
                
            }
        }
        
        if (!oldState[i, j]!) {
            if (numOfAliveCells == 3) {
                return true
            }
            
            return false
        }
        
        if (numOfAliveCells == 2 || numOfAliveCells == 3) {
            return true
        }
        
        return false
    }
}
