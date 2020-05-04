//
//  DashboardViewController.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit

class DashboardViewController : UIViewController{
  
  @IBOutlet weak var speedView: UIView!
  @IBOutlet weak var speed: CircularProgressBar!
  @IBOutlet weak var accuracy: CircularProgressBar!
  @IBOutlet weak var accuracyView: UIView!
  
  private let greenColor = UIColor(red: 0, green: 104/255.0, blue: 55/255.0, alpha: 1)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Dashboard"
    speed.progressColor = greenColor
    speed.suffix = "KM/H"
    speedView.layer.borderColor = greenColor.cgColor
    speedView.layer.cornerRadius  = 10
    speedView.layer.borderWidth = 2
    
    accuracy.progressColor = greenColor
    accuracy.reverse = true
    accuracy.suffix = "Meter"
    accuracyView.layer.borderColor = greenColor.cgColor
    accuracyView.layer.borderWidth = 2
    accuracyView.layer.cornerRadius  = 10
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(newLocationAdded(_:)),
      name: .newLocationSaved,
      object: nil)
  }
  
  @objc func newLocationAdded(_ notification: Notification) {
    guard let location = notification.userInfo?["Data"] as? DataRow else {return}
    speed.setProgress(to: Int(location.speed*3.6))
    accuracy.setProgress(to: Int(location.accuracy))
  }
}
