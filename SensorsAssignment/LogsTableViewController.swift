//
//  PlacesTableViewController.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit
import UserNotifications

class LogsTableViewController: UITableViewController {
    
    private var logEnable = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newLocationAdded(_:)),
            name: .newLocationSaved,
            object: nil)
    }
    
    @objc func newLocationAdded(_ notification: Notification) {
        if !logEnable{
            return
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [
            IndexPath(row: LocationsStorage.shared.dataRows.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsStorage.shared.dataRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let location = LocationsStorage.shared.dataRows[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = location.description
        cell.detailTextLabel?.text = location.dateString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    @IBAction func onExport(_ sender: Any) {
        LocationsStorage.shared.creatCSV(){ fileName in
            let activity = UIActivityViewController(activityItems: [fileName], applicationActivities: nil)
            present(activity, animated: true)
        }
    }
    @IBAction func onClean(_ sender: Any) {
        LocationsStorage.shared.deleteData(){
            tableView.reloadData()
        }
    }
    
    @IBAction func onStop(_ sender: UIBarButtonItem) {
        logEnable = !logEnable
        if logEnable{
            sender.image = UIImage(systemName: "stop.circle")
            tableView.reloadData()
        }else{
            sender.image = UIImage(systemName: "play.circle")
        }
    }
}
