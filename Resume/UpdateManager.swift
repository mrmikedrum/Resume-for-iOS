//
//  UpdateManager.swift
//  Resume
//
//  Created by Mike Drum on 6/25/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import Foundation

private let endpoint = "http://mikedrum.co/resume/resume.json"

struct UpdateManager {
  
  static func update() {
    guard let url = URL(string: endpoint) else { return }
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: url, completionHandler: completionHandler)
    task.resume()
    print("starting update")
  }
  
  static var completionHandler: (Data?, URLResponse?, Error?) -> Void = {(data, response, error) in
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
