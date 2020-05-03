//
//  Queue.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation

public struct Queue {
    fileprivate var array = [Double]()
    var sum  = 0.0
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: Double) {
        if array.count == 50{
            if let first = dequeue(){
                sum += (element-first)/50
            }
        }else{
            sum += element
        }
        array.append(element)
    }
    
    public mutating func dequeue() -> Double? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public var front: Double? {
        return array.first
    }
}
