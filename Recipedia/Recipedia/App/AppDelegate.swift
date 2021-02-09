//
//  AppDelegate.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import UIKit
import RealmSwift
import class Core.NetworkReachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var realm: Realm?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    realm = try? Realm()
    return true
  }
}
