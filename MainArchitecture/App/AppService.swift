//
//  AppService.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit
import EventKit

struct AppService {
    
    static func openURL(_ url: URL?, completion: ((Bool) -> Void)? = nil) {
        guard let url = url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    static func openMap(with place: String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let allowedPlace = place.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? place
            if let url = URL(string: "comgooglemaps://?q=\(allowedPlace)") {
                UIApplication.shared.open(url)
            }
        } else {
            let allowedPlace = place.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? place
            if let url = URL(string:"http://maps.apple.com/?address=\(allowedPlace)") {
                if (UIApplication.shared.canOpenURL(url)) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    static func openShare(texts: [String] = [], image: UIImage? = nil, url: URL? = nil) {
        var shareObjects = [AnyObject]()
        var totalContent = texts.enumerated().reduce("") { (result, arg) -> String in
            let (index, text) = arg
            if index == 0 {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    return result + text
                }
            } else {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    return result + "\n" + text
                }
            }
            return result
        }
        
        if let urlString = url?.absoluteString,
            !urlString.trimmingCharacters(in: .whitespaces).isEmpty {
            totalContent += "\n"
            totalContent += urlString
        }
        
        shareObjects.append(totalContent as AnyObject)
        
        if let image = image {
            shareObjects.append(image as AnyObject)
        }
        
        let excludedActivities = [UIActivity.ActivityType.openInIBooks,
                                  UIActivity.ActivityType.print,
                                  UIActivity.ActivityType.mail,
                                  UIActivity.ActivityType.addToReadingList,
                                  UIActivity.ActivityType.assignToContact,
                                  UIActivity.ActivityType.saveToCameraRoll,
                                  UIActivity.ActivityType.message,
                                  UIActivity.ActivityType.postToFacebook,
                                  UIActivity.ActivityType.postToFlickr,
                                  UIActivity.ActivityType.postToTencentWeibo,
                                  UIActivity.ActivityType.postToTwitter,
                                  UIActivity.ActivityType.postToVimeo,
                                  UIActivity.ActivityType.postToWeibo]
        
        let activityViewController = UIActivityViewController(activityItems: shareObjects,
                                                              applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = excludedActivities
        
        let presenter = AppDelegate.shared.appCoordinator?.topCoordinator.router.toPresent()
        presenter?.present(activityViewController, animated: false, completion: nil)
    }
    
    static func addEventToCalendar(title: String, notes: String = "", startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = notes
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
            }
        }
    }
}
