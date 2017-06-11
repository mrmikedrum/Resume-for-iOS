//
//  MasterViewController.swift
//  Resume
//
//  Created by Mike Drum on 6/4/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
  
  var resume: Resume!
  
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

//  var detailViewController: DetailViewController? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.resume = ObjectManager.shared.resume
    
//    if let split = splitViewController {
//        let controllers = split.viewControllers
//        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//    }
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = self.itemForRowAtIndexPath(indexPath)
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
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
  
  fileprivate func itemForRowAtIndexPath(_ indexPath: IndexPath) -> ResumeObject? {
    switch indexPath.section {
      case Sections.Jobs.rawValue: return self.resume.jobs?[indexPath.item]
      case Sections.Education.rawValue: return self.resume.education?[indexPath.item]
      case Sections.Projects.rawValue: return self.resume.projects?[indexPath.item]
      case Sections.Certifications.rawValue: return self.resume.certifications?[indexPath.item]
      case Sections.Skills.rawValue: return self.resume.skills?[indexPath.item]
    default: return nil
    }
  }

}

