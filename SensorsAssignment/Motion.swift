//
//  Motion.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import CoreMotion

struct Motion{
    let x : Double
    let y : Double
    let z : Double
    
    init(_ current:CMAccelerometerData){
        self.x = current.acceleration.x
        self.y = current.acceleration.y
        self.z = current.acceleration.z
    }
    
    init(){
        self.x = 0
        self.y = 0
        self.z = 0
    }
}
