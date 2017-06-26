//
//  ObjectManager.swift
//  Resume
//
//  Created by Mike Drum on 6/10/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import Foundation

class ObjectManager {
  
  static let shared = ObjectManager()
  
  private let defaultsKey = "ResumeKey"
  
  // MARK: - data access
  
  var resume: Resume { return _resume }
  
  private var _resume: Resume!
  
  func setResume(withDictionary dictionary: NSDictionary) {
    let newResume = Resume(dictionary: dictionary)
    
    // only set if resume has updated
    if let newVersion = newResume.version, newVersion > _resume?.version ?? 0 {
      _resume = newResume
      
      // and write to UserDefaults
      let defaults = UserDefaults.standard
      defaults.set(dictionary, forKey: self.defaultsKey)
      defaults.synchronize()
    }
  }
  
  // MARK: - initialization
  
  init() {
    
    // try to get the saved resume out of UserDefaults
    let defaults = UserDefaults.standard
    if let object = defaults.object(forKey: self.defaultsKey) as? NSDictionary {
      setResume(withDictionary: object)
      return
    }
    
    var object: NSDictionary?
    
    // if it's not there, bootstrap with the bundled json
    guard let filePath = Bundle.main.path(forResource: "resume", ofType: "json"), let stream = InputStream(fileAtPath: filePath)
      else {
        setResume(withDictionary: NSDictionary())
        displayErrorAlert(withString: "Couldn't find bundled data to display. Something is seriously wrong with this app.")
        return
    }
    stream.open()
    do {
      object = try JSONSerialization.jsonObject(with: stream, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
    } catch {
      object = NSDictionary()
      defer {
        displayErrorAlert(withString: "Couldn't read contents of bundled data. Something is seriously wrong with this app.")
      }
    }
    
    setResume(withDictionary: object!)
  }
  
}
