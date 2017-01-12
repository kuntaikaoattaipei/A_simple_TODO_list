//
//  HTTPClient.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import Foundation
class HTTPClient {
	//Receives:
	//endpoint: URL of the REST service
	//method: HTTP verb for the request
	//callback: function to excecute after the request finishes. NSDictionary or NSArray result is passed back.
	static func request(endpoint: NSString, method: NSString, body: NSString, callback: ((AnyObject?, Bool, NSString) -> Void)) {
		
		let session = NSURLSession.sharedSession()
		let url = NSURL(string: endpoint as String)
		let request = NSMutableURLRequest(URL: url!)
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.HTTPMethod = method as String
		request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
		
		//The async task for the request
		let task = session.dataTaskWithRequest(request){
			(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
			
			//Check whether the response is successful
			guard let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
				print("Http request unsuccessful.")
				dispatch_async(dispatch_get_global_queue(priority, 0), {
					dispatch_async(dispatch_get_main_queue(), {
						//The request was unsuccessful. Call callback function with error status and message.
						callback(nil, true, NSLocalizedString("REQUEST_ERROR", comment: ""))
					})
				})
				return
			}
			
			var jsonObject: AnyObject!
			let jsonDictionary: NSDictionary!
			let jsonArray: NSArray!
			
			do {
				//Check whether data is utf-8 compliant
				if let _ = NSString(data: data!, encoding: NSUTF8StringEncoding) {
					//Try to convert data to JSON first.
					jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
				}
			} catch {
				print("JSON parse unsuccessful.")
				//The json parse was unsuccessful. Call callback function with error status and message.
				dispatch_async(dispatch_get_global_queue(priority, 0), {
					dispatch_async(dispatch_get_main_queue(), {
						callback(nil, true, NSLocalizedString("JSON_PARSE_ERROR", comment: ""))
					})
				})
				return
			}
			
			jsonDictionary = jsonObject as? NSDictionary
			jsonArray = jsonObject as? NSArray
			
			//Let param be dictionary or array depending on the returning data
			let param = jsonDictionary ?? jsonArray
			
			dispatch_async(dispatch_get_global_queue(priority, 0), {
				dispatch_async(dispatch_get_main_queue(), {
					//Call callback function with data
					callback(param!, false, "")
				})
			})
		}
		
		//Send the request
		task.resume()
	}
}



