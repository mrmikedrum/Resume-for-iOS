//
//  UINavigationBar+Hiding.swift
//  Resume
//
//  Created by Mike Drum on 6/24/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import UIKit

protocol ScrollingNavBarViewController {
//  var splitViewController: UISplitViewController { get set }
  var scrollView: UIScrollView! { get }
  var headerView: UIView { get }
  var navigationController: UINavigationController? { get }
  func navBarDidHide()
  func navBarDidShow()
}

extension ScrollingNavBarViewController {
  
  func updateNavigationBar() {
    if (self.headerView.frame.origin.y + (self.headerView.frame.size.height / 2) >
      self.scrollView.contentOffset.y) {
      self.navigationController?.navigationBar.hide()
      self.navBarDidHide()
    } else {
      self.navigationController?.navigationBar.show()
      self.navBarDidShow()
    }
  }
}

extension UINavigationBar {
  
  var isHiding: Bool {
    get {
      return self.backgroundImage(for: .default) != nil
    }
  }
  
  func hide() {
    if !self.isHiding {
      let image = UIImage()
      UIView.animate(withDuration: 0.25) {
        self.setBackgroundImage(image, for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.backgroundColor = UIColor.clear
      }
    }
  }
  
  func show() {
    if self.isHiding {
      self.setBackgroundImage(nil, for: UIBarMetrics.default)
      self.barTintColor = UIColor.white
      
      let barAnimation = CATransition()
      barAnimation.duration = 0.25
      barAnimation.type = kCATransitionMoveIn
      barAnimation.subtype = kCATransitionFromBottom
      self.layer.add(barAnimation, forKey: "barAnimation")
    }
  }
}
