//
//  Downloader.swift
//  Journal
//
//  Created by Edward Huang on 1/10/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

class Downloader {
    class func load(URL: URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                // This is your file-variable:
                // data
                
                print(data?.description)
                print(String(data: data!, encoding: String.Encoding.ascii))
            }
            else {
                // Failure
                print("Failure: %@", error?.localizedDescription);
            }
        })
        task.resume()
    }
}
