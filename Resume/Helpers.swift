//
//  Helpers.swift
//  Resume
//
//  Created by Mike Drum on 6/17/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import UIKit

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

internal func fillOrHideLabel(_ label: UILabel, withProperty property: String?) {
  if let string = property, string.characters.count > 0 {
    label.text = string
    label.isHidden = false
  } else {
    label.isHidden = true
  }
}

internal func displayingInSplitScreen() -> Bool {
  if let splitViewController = UIApplication.shared.delegate?.window??.rootViewController as? UISplitViewController {
    return !splitViewController.isCollapsed && splitViewController.displayMode == .allVisible
  }
  return false;
}
