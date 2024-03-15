//
//  LocationManager.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocations(time: Date, latitude: Double, longitude: Double, comment: String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var manager = CLLocationManager()
    private var lastLocation: CLLocationCoordinate2D?
    
    init(delegate: LocationManagerDelegate?) {
        super.init()
        manager.delegate = self
        manager.distanceFilter = 20
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .authorizedAlways {
            manager.requestAlwaysAuthorization()
        }
    }
    
    func startMonitoring() {
        manager.startUpdatingLocation()
    }
    
    func stopMonitoring() {
        manager.stopUpdatingLocation()
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        lastLocation = location.coordinate
        let latitude = round(location.coordinate.latitude * 1000) / 1000.0
        let longitude = round(location.coordinate.longitude * 1000) / 1000.0
        let comment = UIApplication.shared.applicationState == .background ? "Background" : "Foreground"
        DataManager.shared.saveLocation(time: Date(), latitude: latitude, longitude: longitude, comment: comment)

    }
    
    func setupGeofence() {
        
        guard let lastLocation = lastLocation else { return }
        let radius = 100.0 // Geofence radius in meters
        let identifier = "MyGeofenceRegionIdentifier" // A unique identifier for the geofence
        
        let geofenceRegion = CLCircularRegion(center: lastLocation, radius: radius, identifier: identifier)
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        manager.startMonitoring(for: geofenceRegion)
    }


    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            let center = circularRegion.center
            let latitude = round(center.latitude * 1000) / 1000.0
            let longitude = round(center.longitude * 1000) / 1000.0
            
            DataManager.shared.saveLocation(time: Date(), latitude: latitude, longitude: longitude, comment: "Geofencing Entry")
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("device exited geofencing region...")
        if let circularRegion = region as? CLCircularRegion {
            let center = circularRegion.center
            let latitude = round(center.latitude * 1000) / 1000.0
            let longitude = round(center.longitude * 1000) / 1000.0
            
            DataManager.shared.saveLocation(time: Date(), latitude: latitude, longitude: longitude, comment: "Geofencing Exit")
        }
    }

}

