//
//  LocationViewModel.swift
//  Locator
//
//  Created by Tony Ayoub on 15-03-2024.
//

import Foundation
import CoreLocation

class LocationViewModel: ObservableObject {
    private var locationManager: LocationManager?
    @Published var lastLocation: CLLocation?
    
    init() {
        self.locationManager = LocationManager(delegate: self)
    }
    
    func requestPermissionAndStartUpdates() {
        locationManager?.requestPermission()
        locationManager?.startUpdatingLocation()
    }
    
    func deleteAll() {
        DataManager.shared.deleteAllUpdates()
    }
    
    func setGeoFence() {
        locationManager?.setupGeofence()
    }
}

extension LocationViewModel: LocationManagerDelegate {
    func didUpdateLocations(time: Date, latitude: Double, longitude: Double, comment: String) {
        DataManager.shared.saveLocation(time: time, latitude: latitude, longitude: longitude, comment: comment)
    }
}
