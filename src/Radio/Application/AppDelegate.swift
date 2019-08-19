//
//  AppDelegate.swift
//  Radio
//
//  Created by evg on 15/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupCache()
		setupAudioPlayback()
		return true
	}
	
	// MARK: - Audio
	
	func setupAudioPlayback() {
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
			let _ = try AVAudioSession.sharedInstance().setActive(true)
		} catch let error as NSError {
			print("an error occurred when audio session category.\n \(error)")
		}
	}
	
	
	// MARK: - Core Data
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Radio")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	// MARK: - Cache
	
	private func setupCache() {
		let cache = URLCache.shared
		cache.diskCapacity = 1024 * 1024 * 20
		cache.memoryCapacity = 1024 * 1024 * 10
	}
	
}
