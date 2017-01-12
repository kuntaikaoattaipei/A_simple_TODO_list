//
//  TaskManager.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import Foundation
var taskManager: TaskManager = TaskManager()
class TaskManager {
	var tasks = [Task]()
	func addTask(task: Task) {
    tasks.append(task)
	}
}

