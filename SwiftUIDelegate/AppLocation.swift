//
//  AppPermission.swift
//  SwiftUIDelegate
//
//  Created by no name on 2023/12/13.
//  
//

import Foundation
import CoreLocation

final public class AppLocation: NSObject {
    
    public static let shared = AppLocation()
    
    private override init() {}
    
    private let locationManager = CLLocationManager()
    
    func getLocation() async throws -> CLLocation {
        locationManager.delegate = self
        let status = locationManager.authorizationStatus
        print("authorizationStatus=\(status)")
        switch status {
        case .notDetermined:
            print("notDetermined")
            let newStatus = try await getLocationPermission()
            switch newStatus {
            case .notDetermined:
                print("notDetermined")
            case .restricted, .denied:
                print("denied")
                throw LocationError.denied
            case .authorizedAlways, .authorizedWhenInUse:
                let location = try await getCurrentLocation()
                return location
            @unknown default:
                print("unknown")
            }
        case .restricted, .denied:
            print("denied")
            throw LocationError.denied
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            let location = try await getCurrentLocation()
            return location
        @unknown default:
            print("unknown")
        }
        throw LocationError.unknown
    }
    
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Error>?
    
    private func getLocationPermission() async throws -> CLAuthorizationStatus {
        return try await withCheckedThrowingContinuation { continuation in
            print("withCheckedThrowingContinuation START")
            permissionContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
            print("withCheckedThrowingContinuation END")
        }
    }

    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    private func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            print("withCheckedThrowingContinuation START")
            locationContinuation = continuation
            locationManager.requestLocation()
            print("withCheckedThrowingContinuation END")
        }
    }
    
    enum LocationError: Error {
        case denied
        case unknown
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocation: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = locationManager.authorizationStatus
        print("authorizationStatus=\(status)")
        permissionContinuation?.resume(returning: status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations \(locations)")
        if let location = locations.first {
            locationContinuation?.resume(returning: location)
        } else {
            locationContinuation?.resume(throwing: LocationError.unknown)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        locationContinuation?.resume(throwing: error)
    }
}
