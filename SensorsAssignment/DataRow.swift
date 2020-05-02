//
//  Location.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import Foundation
import CoreLocation

struct DataRow: Codable {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    let latitude: Double
    let longitude: Double
    let date: Date
    let dateString: String
    let description: String
    let accuracy : Double
    let altitude: Double
    let speed: Double
    let motionX: Double
    let motionY: Double
    let motionZ: Double
    
    init(_ location: CLLocation,_ motion: Motion) {
        latitude =  location.coordinate.latitude
        longitude =  location.coordinate.longitude
        self.date = location.timestamp
        self.accuracy = location.horizontalAccuracy
        self.altitude = location.altitude
        self.speed = location.speed
        dateString = DataRow.dateFormatter.string(from: date)
        description = location.description
        self.motionX = motion.x
        self.motionY = motion.y
        self.motionZ = motion.z
    }
}
