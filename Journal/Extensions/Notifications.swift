//
//  Notifications.swift
//  Journal
//
//  Created by Edward Huang on 1/9/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation


extension Notification.Name {
    static let journalChanged = Notification.Name(rawValue: "journal_changed")
    static let entryDeleted = Notification.Name(rawValue: "entry_deleted")
}
