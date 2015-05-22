//
//  YRHttpRequest.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-5.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

import UIKit
import Foundation

//class func connectionWithRequest(request: NSURLRequest!, delegate: AnyObject!) -> NSURLConnection!


class YRHttpRequest: NSObject {

    override init()
    {
        super.init();
    }
    
    class func requestWithURL(urlString:String, completionHandler:(data:AnyObject)->Void)
    {
        var url: NSURL = NSURL(string: urlString)!
        var req = NSMutableURLRequest(URL: url)
        req.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0",forHTTPHeaderField:"User-Agent")
        var queue = NSOperationQueue();
        NSURLConnection.sendAsynchronousRequest(req, queue: queue, completionHandler: { response, data, error in
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(),
                {
                    println(error)
                    completionHandler(data:NSNull())
                })
            }
            else
            {
                var err:NSError?
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary

                dispatch_async(dispatch_get_main_queue(),
                {
                    completionHandler(data:jsonData)
                })
            }
        })
    }
    
    
    
}
