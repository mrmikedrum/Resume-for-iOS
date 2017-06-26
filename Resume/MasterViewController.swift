//
//  MasterViewController.swift
//  Resume
//
//  Created by Mike Drum on 6/4/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, ScrollingNavBarViewController {
  
  weak var resume: Resume!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var abstractLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  private var abbreviatedName: String!
    
  private enum Sections: Int {
    case Jobs
    case Education
    case Projects
    case Certifications
    case Skills
    case Count
  }
  
  private let SectionTitles = [
    Sections.Jobs.rawValue: "Jobs",
    Sections.Education.rawValue: "Education",
    Sections.Projects.rawValue: "Projects",
    Sections.Certifications.rawValue: "Certifications",
    Sections.Skills.rawValue: "Skills",
  ]
  
  // MARK: - Setup

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.resume = ObjectManager.shared.resume
    
    let firstInitial = self.resume.firstName?.characters.first
    self.abbreviatedName = (firstInitial != nil ? String(firstInitial!) : "") + (self.resume.lastName ?? "")
    
    self.navigationController?.view.backgroundColor = UIColor.white

    self.updateNavigationBar()
    
    self.updateUI()
    
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }
  
  private func updateUI() {
    if let firstName = self.resume.firstName, let lastName = self.resume.lastName {
      var name = firstName
      name.append(name.characters.count > 0 && lastName.characters.count > 0 ? " " : "")
      name.append(lastName)
      self.nameLabel.text = name
      self.nameLabel.isHidden = false
    } else {
      self.nameLabel.isHidden = true
    }
    
    fillOrHideLabel(self.titleLabel, withProperty: self.resume.title)
    fillOrHideLabel(self.abstractLabel, withProperty: self.resume.abstract)
    fillOrHideLabel(self.phoneLabel, withProperty: self.resume.phone)
    fillOrHideLabel(self.emailLabel, withProperty: self.resume.email)
    fillOrHideLabel(self.addressLabel, withProperty: self.resume.address)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.sizeHeaderToFit(tableView: self.tableView)
    self.updateNavigationBar()
  }
  
  private func sizeHeaderToFit(tableView: UITableView) {
    if let headerView = tableView.tableHeaderView {
      let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
      var frame = headerView.frame
      frame.size.height = height
      headerView.frame = frame
      tableView.tableHeaderView = headerView
      headerView.setNeedsLayout()
      headerView.layoutIfNeeded()
    }
  }
  
  // MARK: - Magic
  
  var scrollView: UIScrollView! { return self.tableView }
  var headerView: UIView { return self.nameLabel }
  
  func navBarDidHide() {
    self.navigationItem.title = ""
  }
  
  func navBarDidShow() {
    self.navigationItem.title = self.abbreviatedName
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateNavigationBar()
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var detailController: DetailViewController? = nil
    if segue.identifier == "show", let controller = segue.destination as? UINavigationController, let topController = controller.topViewController as? DetailViewController {
      detailController = topController
    }
    else if segue.identifier == "push", let destination = segue.destination as? DetailViewController {
      detailController = destination
    }
    if let indexPath = tableView.indexPathForSelectedRow, let detail = detailController {
      detail.detailItem = self.itemForRowAtIndexPath(indexPath)
      detail.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
      detail.navigationItem.leftItemsSupplementBackButton = true
    }
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.Count.rawValue;
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return SectionTitles[section] ?? ""
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
      case Sections.Jobs.rawValue: return self.resume.jobs?.count ?? 0
      case Sections.Education.rawValue: return self.resume.education?.count ?? 0
      case Sections.Projects.rawValue: return self.resume.projects?.count ?? 0
      case Sections.Certifications.rawValue: return self.resume.certifications?.count ?? 0
      case Sections.Skills.rawValue: return self.resume.skills?.count ?? 0
      default: return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    cell.textLabel?.text = self.itemForRowAtIndexPath(indexPath)?.name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if displayingInSplitScreen() {
      self.performSegue(withIdentifier: "show", sender: nil)
    }
    else {
      self.performSegue(withIdentifier: "push", sender: nil)
    }
  }
  
  private func itemForRowAtIndexPath(_ indexPath: IndexPath) -> ResumeObject? {
    switch indexPath.section {
      case Sections.Jobs.rawValue: return self.resume.jobs?[indexPath.item]
      case Sections.Education.rawValue: return self.resume.education?[indexPath.item]
      case Sections.Projects.rawValue: return self.resume.projects?[indexPath.item]
      case Sections.Certifications.rawValue: return self.resume.certifications?[indexPath.item]
      case Sections.Skills.rawValue: return self.resume.skills?[indexPath.item]
    default: return nil
    }
  }
  
  // MARK: - updating

  @IBAction func handleRefresh(_ sender: UIRefreshControl) {
    UpdateManager.shared.update() {
      self.refreshControl?.endRefreshing()
    }
  }
  
}

