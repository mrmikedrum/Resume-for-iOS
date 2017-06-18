//
//  Helpers.swift
//  Resume
//
//  Created by Mike Drum on 6/17/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import Foundation

internal func extractArray<T: ResumeObject>(source: NSDictionary, key: String) -> [T]? {
  if let array = source.object(forKey: key) as? NSArray {
    var result = [T]()
    for item in array {
      //if let dict as? NSDictionary {
      result.append(T(dictionary: item as! NSDictionary))
      //}
    }
    return result
  }
  return nil
}
