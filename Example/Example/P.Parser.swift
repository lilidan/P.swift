//
//  P.swift
//  Example
//
//  Created by sgcy on 15/11/19.
//  Copyright © 2015年 sgcy. All rights reserved.
//

import UIKit

extension String {
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
}

extension P{
    
    class func parseJsonToObject <T:NSObject> (jsonObject:AnyObject,classType:AnyClass) -> T{
        
        let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
    
        return self.parseJsonToObject(jsonObject, className: String(classType.self) ,prefixStr:"_TtC",superClassStr:"\(appName.characters.count)\(appName)\("P".characters.count)P")
        
    }
    
    class func parseJsonToObject <T:NSObject> (json:AnyObject,className:String,var prefixStr:String,superClassStr:String) -> T{
        
        prefixStr += "C"
        let classStr = superClassStr + "\(className.characters.count)" + className.capitalizeFirst
        let classObj = NSClassFromString(prefixStr + classStr) as! T.Type
        let obj = classObj.init()
        
        if let jsonObj = json as? [String:AnyObject]{
            
            for key in jsonObj.keys{
                let value = jsonObj[key]
                
                if value is String || value is [String]{
                    
                    obj.setValue(value, forKey:key)
                    
                }else if let subJsonArray = value as? [[String:AnyObject]]{
                    
                    var subObjectArray = [AnyObject]()
                    
                    for subJson in subJsonArray{
                        subObjectArray.append(self.parseJsonToObject(subJson, className:key,prefixStr:prefixStr, superClassStr:classStr))
                    }
                    
                    obj.setValue(subObjectArray, forKey: key)
                    
                }else if let subJson = value as? [String:AnyObject]{
                    
                    obj.setValue(self.parseJsonToObject(subJson, className:key,prefixStr:prefixStr,superClassStr:classStr), forKey: key)
                    
                }else{
                    print("[P]Json Value ERROR key:\(key) value:\(value)")
                }
            }
        }
        return obj
    }

}
