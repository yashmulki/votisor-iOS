//
//  AppDelegate.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import MapKit

protocol Reloadable {
    func hardRefresh()
}

var controllers: [Reloadable] = []

func reloadAll() {
    for controller in controllers {
        controller.hardRefresh()
    }
}

struct Location: Codable {
    var lat: Double
    var long: Double
    
    func toCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(lat, long)
    }
}

var currentLocation: Location? = nil

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let loc = UserDefaults.standard.object(forKey: "loc") as? Data {
            do {
                // Load location from storage
                let decoder = JSONDecoder()
                currentLocation = try decoder.decode(Location.self, from: loc)
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "Feed")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                return true
            } catch {
                print("Could Not Decode... Moving to onboarding")
            }
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Onboarding")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }

    func switchToFeed() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "Feed")
        self.window?.rootViewController = nav
    }

    func switchToOnboarding() {
        
    }
    
}

