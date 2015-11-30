//
//  ViewController.swift
//  Example
//
//  Created by sgcy on 15/11/19.
//  Copyright © 2015年 sgcy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Read json file from local or Internet
        let sourcePath = NSBundle.mainBundle().pathForResource("Weather", ofType: "json")
        let str = try! NSString(contentsOfFile: sourcePath!, encoding: NSUTF8StringEncoding) as String
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(NSData(data: str.dataUsingEncoding(NSUTF8StringEncoding)!), options: NSJSONReadingOptions(rawValue: 0))
        print(jsonObject)
        
        // Parse json to instance object
        let weather:P.Weather = P.parseJsonToObject(jsonObject, classType: P.Weather.self)

        // use it
        weather.query?.results?.channel?.item
   }
    
    var model = ""
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = model
        return cell!
    }
    //use it
//    model = (weather.query?.results?.channel?.item?.condition?.text)!
//    print(model)

    
   // weather.query?.results?.channel?.item

}

