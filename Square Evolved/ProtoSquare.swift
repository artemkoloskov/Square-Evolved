//
//  ProtoSquare.swift
//  Square Evolved
//
//  Created by Artem Koloskov on 24/04/2019.
//  Copyright © 2019 Artem Koloskov. All rights reserved.
//

import Foundation

class ProtoSquare {
    
    var bodyWidth = 50
    var bodyHeight = 50
    var bodyArray: Array2D<Bool>
    var evolutionCycles = 1000
    var liveEvolutionDelay = 20.0
    var age = 0
    
    private let liveCell = "**"
    private let deadCell = "  "
    
    convenience init(dimension: Int, cycles: Int, delay: Double) {
        self.init(width: dimension, height: dimension, cycles: cycles, delay: delay)
    }
    
    init(width: Int, height: Int, cycles: Int, delay: Double) {
        
        bodyWidth = width
        bodyHeight = height
        evolutionCycles = cycles
        liveEvolutionDelay = delay
        
        bodyArray = Array2D<Bool>(columns: width, rows: height)
        
        // propagate the body of a square with "dead" and "alive" cells randomly
        buildBody()
    }
    
    private func buildBody () -> Void {
        
        for i in 0..<bodyArray.rows {
            
            for j in 0..<bodyArray.columns {
                
                bodyArray[i,j] = Bool.random()
            }
        }
    }
    
    func runFullEvolutionCycle () -> Void {
        
        // fully evolve body through whole bunch of evolution cycles
        for i in 0...evolutionCycles {
            
            // print for debug
            print("i: \(i)")
            //printArray(array: array)
            
            evolveArray()
            
            Thread.sleep(forTimeInterval: liveEvolutionDelay)
        }
    }
    
    func printArray(array: Array2D<Bool>) -> Void {
        
        // printing array to cosole for debug
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
        
        // runs through whole body, checking every cell for 3 "alive"
        // neighbours. if found - cell stays "alive"
        let oldState = bodyArray
        
        if age < evolutionCycles {
            for i in 0..<bodyArray.rows {
                for j in 0..<bodyArray.columns {
                    bodyArray[i, j] = checkNewState(oldState: oldState, i: i, j: j)
                    
                }
            }
        }
        
        age += 1
    }
    
    private func checkNewState(oldState: Array2D<Bool>, i: Int, j: Int) -> Bool {
        
        // checks the old state of cell. if cell is alive, and has 3 alive
        // neighbours - remembers the new state of a cell as alive. Dead
        // otherwise.
        var numOfAliveCells = 0
        
        // model cosiders the body as kind of a sphere or pattern
        // if you will. The row preciding to the firs row is the last row;
        // the row next aftr the last row - is the first row.
        // same goes for columns. Here, we check 8 cells around the cell [i,j]
        // if i or j are 0s, then we check cells in last row or column.
        // if i or j are at the end of row or column, we check cells in first
        // column or row
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
        
        // case if the cell was dead
        if (!oldState[i, j]!) {
            
            if (numOfAliveCells == 3) {
                // cell becomes alive if it has 3 alive neighbours
                return true
            }
            
            // stays dead
            return false
        }
        
        // case if cell was alive
        if (numOfAliveCells == 2 || numOfAliveCells == 3) {
            
            // stays alive if it has 2 or 3 alive neighbours
            return true
        }
        
        // dies in all other cases
        return false
    }
}
