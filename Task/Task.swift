//
//  Task.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import Foundation
class Task {
	var item_photo: NSString?
    var datetime: NSString
    var task:NSString
    var isFinish: NSString
    init(values: NSDictionary) {
        self.datetime = values.valueForKey("datetime") as! NSString
        self.task = values.valueForKey("task") as! NSString
        self.isFinish = values.valueForKey("isFinish") as! NSString
    }
}

