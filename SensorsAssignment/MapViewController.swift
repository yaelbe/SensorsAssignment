//
//  MapViewController.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.userTrackingMode = .follow
  }
  
  func annotationForLocation(_ location: DataRow) -> MKAnnotation {
    let annotation = MKPointAnnotation()
    annotation.title = location.dateString
    annotation.coordinate = location.coordinates
    return annotation
  }
}
