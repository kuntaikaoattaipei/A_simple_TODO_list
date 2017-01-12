//
//  NewTaskViewController.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import UIKit
import SystemConfiguration
class NewTaskViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var initDateTextField: UITextField!
	@IBOutlet weak var endDateTextField: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var Btn_change_status: UIButton!
    @IBOutlet weak var state_label: UILabel!
	var task: Task!
    var label_change_1 = 1

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        state_label.text! = "TRUE"
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
    @IBAction func BtnTD(sender: AnyObject) {
        if label_change_1 == 1
        {
        state_label.text! = "FALSE"
        label_change_1 = 0
        }
        else
        {
        state_label.text! = "TRUE"
        label_change_1 = 1
        }
    }
	
	@IBAction func datePickerTapped(sender: AnyObject) {
		let textField = sender as! UITextField
		self.view.endEditing(true)
		textField.resignFirstResponder()
		DatePickerDialog().show("Date", doneButtonTitle: "Ok", cancelButtonTitle: "Cancel", datePickerMode: UIDatePickerMode.Date) {
			(date) -> Void in
			textField.text = "\(date)"
		}
	}
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
    if (isConnectedToNetwork() == true)
    {
        
		let taskDictionary: NSMutableDictionary = NSMutableDictionary()
		
		if saveButton === sender {
            let transformdatetime: String = initDateTextField.text! as String
            let purified_datetime: String = (transformdatetime as NSString).substringToIndex(10)
            taskDictionary.setValue(purified_datetime, forKey: "datetime")
            taskDictionary.setValue(endDateTextField.text, forKey: "task")
            taskDictionary.setValue(state_label.text!, forKey: "isFinish")
			self.task = Task(values: taskDictionary)
		}
    }
    else{
    
    }
	}
	
	@IBAction func cancel(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	
	@IBAction func editingEnd(sender: AnyObject) {
		let textField = sender as! UITextField
		textField.resignFirstResponder()
	}
	
}




