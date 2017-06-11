//
//  Model.swift
//  Resume
//
//  Created by Mike Drum on 6/4/17.
//  Copyright © 2017 Mike Drum. All rights reserved.
//

import Foundation

fileprivate func extractArray<T: ResumeObject>(source: NSDictionary, key: String) -> [T]? {
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

protocol ResumeObject {
  init(dictionary: NSDictionary)
  var name: String? { get }
}

class Resume {
  var version: Int?
  var firstName: String?
  var lastName: String?
  var phone: String?
  var email: String?
  var address: String?
  var title: String?
  var abstract: String?
  var jobs: [Job]?
  var education: [Education]?
  var projects: [Project]?
  var certifications: [Certification]?
  var skills: [Skill]?
  
  init(dictionary: NSDictionary) {
    version = (dictionary.object(forKey: "version") as? NSNumber)?.intValue
    firstName = dictionary.object(forKey: "firstName") as? String
    lastName = dictionary.object(forKey: "lastName") as? String
    phone = dictionary.object(forKey: "phone") as? String
    email = dictionary.object(forKey: "email") as? String
    address = dictionary.object(forKey: "address") as? String
    title = dictionary.object(forKey: "title") as? String
    abstract = dictionary.object(forKey: "abstract") as? String
    
    jobs = extractArray(source: dictionary, key: "jobs")
    education = extractArray(source: dictionary, key: "education")
    projects = extractArray(source: dictionary, key: "projects")
    certifications = extractArray(source: dictionary, key: "certifications")
    skills = extractArray(source: dictionary, key: "skills")
  }
}

class Job: ResumeObject {
  var name: String?
  var title: String?
  var startDate: String?
  var endDate: String?
  var description: String?
  
  required init(dictionary: NSDictionary) {
    name = dictionary.object(forKey: "name") as? String
    title = dictionary.object(forKey: "title") as? String
    startDate = dictionary.object(forKey: "startDate") as? String
    endDate = dictionary.object(forKey: "endDate") as? String
    description = dictionary.object(forKey: "description") as? String
  }
}

class Education: ResumeObject {
  var name: String?
  var subject: String?
  var startDate: String?
  var endDate: String?
  var description: String?
  
  required init(dictionary: NSDictionary) {
    name = dictionary.object(forKey: "name") as? String
    subject = dictionary.object(forKey: "subject") as? String
    startDate = dictionary.object(forKey: "startDate") as? String
    endDate = dictionary.object(forKey: "endDate") as? String
    description = dictionary.object(forKey: "description") as? String
  }
}

class Project: ResumeObject {
  var name: String?
  var platform: String?
  var description: String?
  var link: URL?
  
  required init(dictionary: NSDictionary) {
    name = dictionary.object(forKey: "name") as? String
    platform = dictionary.object(forKey: "platform") as? String
    description = dictionary.object(forKey: "description") as? String
    if let linkString = dictionary.object(forKey: "link") as? String {
      link = URL(string: linkString)
    }
  }
}

class Certification: ResumeObject {
  var name: String?
  var description: String?
  
  required init(dictionary: NSDictionary) {
    name = dictionary.object(forKey: "name") as? String
    description = dictionary.object(forKey: "description") as? String
  }
}

class Skill: ResumeObject {
  var name: String?
  var description: String?
  
  required init(dictionary: NSDictionary) {
    name = dictionary.object(forKey: "name") as? String
    description = dictionary.object(forKey: "description") as? String
  }
}
