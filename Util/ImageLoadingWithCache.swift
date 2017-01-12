//
//  ImageLoadingWithCache.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import UIKit
class ImageLoadingWithCache {
	var imageCache = [String:UIImage]()
	func getImage(url: String, imageView: UIImageView, defaultImage: String) {
		
		if let img = imageCache[url] {
			imageView.image = img
		} else {
			let session = NSURLSession.sharedSession()
			let URL = NSURL(string: url)
			
			session.dataTaskWithURL(URL!, completionHandler: {
				(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
				
				if error == nil {
					let image = UIImage(data: data!)
					self.imageCache[url] = image
					
					dispatch_async(dispatch_get_main_queue(), {
						imageView.image = image
					})
				} else {
					imageView.image = UIImage(named: defaultImage)
				}
			}).resume()
		}
	}
}
