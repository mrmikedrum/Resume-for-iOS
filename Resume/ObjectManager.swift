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
  
  let resume: Resume
  
  init() {
    guard let filePath = Bundle.main.path(forResource: "resume", ofType: "json"), let stream = InputStream(fileAtPath: filePath)
      else {
        fatalError() //FIXME: handle missing file or just wait till it's networked idc
    }
    var object: NSDictionary?
    stream.open()
    do {
      object = try JSONSerialization.jsonObject(with: stream, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
    } catch {
      fatalError() //FIXME: handle bad deserialization
    }
    
    resume = Resume(dictionary: object!)
  }
  
}
