//
//  ViewController.swift
//  Project22
//
//  Created by Ngoni Katsidzira  on 30/6/2025.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    @IBOutlet var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
                case .unknown:
                    self.view.backgroundColor = UIColor.gray
                    self.distanceReading.text = "UNKNOWN"
                case .immediate:
                    self.view.backgroundColor = UIColor.red
                    self.distanceReading.text = "RIGHT HERE"
                case .near:
                    self.view.backgroundColor = UIColor.orange
                    self.distanceReading.text = "NEAR"
                case .far:
                    self.view.backgroundColor = UIColor.blue
                    self.distanceReading.text = "FAR"
                default:
                    self.view.backgroundColor = .black
                    self.distanceReading.text = "WHOA!"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }

}

