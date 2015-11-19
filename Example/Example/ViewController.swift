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
        // Do any additional setup after loading the view, typically from a nib.
        
        let sourcePath = NSBundle.mainBundle().pathForResource("Index", ofType: "json")
        let str = try! NSString(contentsOfFile: sourcePath!, encoding: NSUTF8StringEncoding) as String
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(NSData(data: str.dataUsingEncoding(NSUTF8StringEncoding)!), options: NSJSONReadingOptions(rawValue: 0))
        print(jsonObject)
        let index:P.Index = P.parseJsonToObject(jsonObject, classType: P.Index.self)
        models = index.data!.cases
   }
    
    var models:[P.Index.Data.Cases]!
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if models == nil{
            return 0
        }
        return models.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = models[indexPath.row].title
        return cell!
    }
}

