//
//  DetailViewController.swift
//  Resume
//
//  Created by Mike Drum on 6/4/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate, ScrollingNavBarViewController {

  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var secondaryLabel: UILabel!
  @IBOutlet weak var datesLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var linkButton: UIButton!
  
  func configureView() {
    if let detail = self.detailItem, self.isViewLoaded {
      UIView.animate(withDuration: 1) {
        fillOrHideLabel(self.nameLabel, withProperty: detail.name)
        fillOrHideLabel(self.secondaryLabel, withProperty: detail.secondary)
        fillOrHideLabel(self.datesLabel, withProperty: detail.dates)
        fillOrHideLabel(self.descriptionLabel, withProperty: detail.description)
        if let _ = detail.link {
          self.linkButton.isHidden = false
        }
        else {
          self.linkButton.isHidden = true
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateNavigationBar()
  }

  var detailItem: ResumeObject? {
    didSet {
        // Update the view.
        configureView()
    }
  }

  @IBAction func linkButtonPressed(_ sender: UIButton) {
    if let url = self.detailItem?.link, UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:])
    }
  }
  
  // MARK: - Magic
  
  var headerView: UIView { return self.nameLabel }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateNavigationBar()
  }
  
  func navBarDidHide() {
    self.navigationItem.title = ""
  }
  
  func navBarDidShow() {
    self.navigationItem.title = self.nameLabel.text
  }
  

}

