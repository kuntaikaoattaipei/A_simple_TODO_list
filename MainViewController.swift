//
//  ViewController.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import UIKit
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var tasksTable: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.tasksTable.tableFooterView = UIView(frame: CGRectZero)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func trunc(string: String, length: Int, trailing: String? = "...") -> String {
		if string.characters.count > length {
			return string.substringToIndex(string.startIndex.advancedBy(length)) + (trailing ?? "")
		} else {
			return string
		}
	}
	
	@IBAction func unwindToTasksList(sender: UIStoryboardSegue) {
        // write
		if let sourceViewController = sender.sourceViewController as? NewTaskViewController {
			let task = sourceViewController.task
			
			let newIndexPath = NSIndexPath(forRow: taskManager.tasks.count, inSection: 0)
			taskManager.addTask(task)
			self.tasksTable.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            let URL: NSString = "https://sheetsu.com/apis/v1.0/7decfd275eca"
            let body = String(format: "{\"datetime\": \"%@\", \"task\": \"%@\", \"isFinish\": \"%@\"}", task.datetime, task.task, task.isFinish)
            
			UIApplication.sharedApplication().networkActivityIndicatorVisible = true
			HTTPClient.request(URL, method: "POST", body: body, callback: {
				(resultObject: AnyObject?, error: Bool, errorMessage: NSString) -> Void in
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
				if error == false {
					self.tasksTable.reloadData()
				} else {
					let alertController = UIAlertController(title: "Error", message: errorMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "somthing is wrong!"), style: UIAlertActionStyle.Default, handler: nil))
					self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
				}
			})

		}
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return taskManager.tasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CustomCell")! as UITableViewCell
        let datetimecell = cell.viewWithTag(1) as! UILabel
        let profileImage = cell.viewWithTag(2) as! UIImageView
        let taskcell = cell.viewWithTag(3) as! UILabel
		let isTrueImage = cell.viewWithTag(4) as! UIImageView
        let isFinishcell = cell.viewWithTag(5) as! UILabel
		let task = taskManager.tasks[indexPath.row]

		profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
		profileImage.clipsToBounds = true;
        profileImage.image = UIImage(named: "works.png")
        
		if let item_photo = task.item_photo {
			let cache = ImageLoadingWithCache()
			cache.getImage(item_photo as String, imageView: profileImage, defaultImage: "default_profile.jpeg")
		}
        datetimecell.text = "Date time:" + (task.datetime as String) as String
        taskcell.text = "Task:" + (task.task as String) as String
        isFinishcell.text = "isFinish:" + (task.isFinish as String) as String
        if task.isFinish == "TRUE" {
            isTrueImage.image = UIImage(named: "TRUE.png")
        } else {
            isTrueImage.image = UIImage(named: "FALSE.png")
        }
        
		return cell
	}
	
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

	}

}

