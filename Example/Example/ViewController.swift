//
//  ViewController.swift
//  Example
//
//  Created by sgcy on 15/11/19.
//  Copyright © 2015年 sgcy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sourcePath = NSBundle.mainBundle().pathForResource("Index", ofType: "json")
        let str = try! NSString(contentsOfFile: sourcePath!, encoding: NSUTF8StringEncoding) as String
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(NSData(data: str.dataUsingEncoding(NSUTF8StringEncoding)!), options: NSJSONReadingOptions(rawValue: 0))
        print(jsonObject)
        let index:P.Index = P.parseJsonToObject(jsonObject, classType: P.Index.self)
   }
}

