//
//  UpdateManager.swift
//  Resume
//
//  Created by Mike Drum on 6/25/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import Foundation

private let endpoint = "http://mikedrum.co/resume/resume.json"

class UpdateManager {
  
  static var shared = UpdateManager()
  
  var completionHandlers: [() -> ()] = []
  
  func update(completion handler: (() -> ())? = nil) {
    guard let url = URL(string: endpoint) else { return }
    
    // start a new task if we aren't already waiting for a response
    if self.completionHandlers.isEmpty {
      
      let session = URLSession.shared
      
      let task = session.dataTask(with: url, completionHandler: self.dataTaskCompletionHandler)
      task.resume()
      print("starting update")
    }
    
    if let closure = handler {
      assert(Thread.isMainThread, "Completion handlers must be coming from the main queue")
      self.completionHandlers.append(closure)
    }
  }
  
  private func completeAll() {
    for handler in self.completionHandlers {
      DispatchQueue.main.async(execute: handler)
    }
    completionHandlers = []
  }
  
  var dataTaskCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
    
    UpdateManager.shared.completeAll()
    
    guard error == nil else {
      displayErrorAlert(withString: error!.localizedDescription)
      return
    }
    
    if let response = response as? HTTPURLResponse, let data = data {
      let dictionary: NSDictionary
      do {
        dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
      } catch {
        dictionary = NSDictionary()
        defer {
          displayErrorAlert(withString: "Couldn't parse server response. Please try again later.")
        }
      }
      
      ObjectManager.shared.setResume(withDictionary: dictionary)
      print("finished updating")
    }
  }
}
