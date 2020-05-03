//
//  LocationsStorage.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

class LocationsStorage {
    static let shared = LocationsStorage()
    
    private(set) var dataRows: [DataRow]
    private(set) var motion: [Motion] = []
    private let fileManager: FileManager
    private let documentsURL: URL
    private var lastMotiom : Motion = Motion()
    
    init() {
        let fileManager = FileManager.default
        documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.fileManager = fileManager
        
        let jsonDecoder = JSONDecoder()
        
        let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                     includingPropertiesForKeys: nil)
        self.dataRows = locationFilesURLs.compactMap { url -> DataRow? in
            guard !url.absoluteString.contains(".DS_Store") else {
                return nil
            }
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? jsonDecoder.decode(DataRow.self, from: data)
        }.sorted(by: { $0.date < $1.date })
        
    }
    func deleteData(compleation:()->()){
        
        let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                     includingPropertiesForKeys: nil)
        for url in locationFilesURLs{
            try? fileManager.removeItem(at: url)
        }
        dataRows = []
        compleation()
    }
    func saveDataOnDisk(_ location: CLLocation) {
        let row = DataRow(location , lastMotiom)
        let encoder = JSONEncoder()
        let timestamp = Date().description
        let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
        let data = try! encoder.encode(row)
        try? data.write(to: fileURL)
        
        dataRows.append(row)
        NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["Data": row])
    }
    
    
    func saveLastMotion(_ current:CMAccelerometerData){
        lastMotiom = Motion(current)
    }
    
    func creatCSV(_ compleation:((URL) ->())) -> Void {
        
        let fileName = "Data.csv"
        let path = documentsURL.appendingPathComponent(fileName)
        
        try? FileManager.default.removeItem(at: path)
        
        var csvText = "Time Stamp,acceleration X, acceleration Y,acceleration Z,GPS accuracy,GPS altitude,GPS latitude,GPS longitude\n"
        
        for row in dataRows {
            let newLine = "\(row.dateString),\(row.motionX),\(row.motionY),\(row.motionZ),\(row.accuracy),\(row.altitude),\(row.latitude),\(row.longitude)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        compleation(path)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension Notification.Name {
    static let newLocationSaved = Notification.Name("newLocationSaved")
}


