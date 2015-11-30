//
//  Kaoru.swift
//  R.swift
//
//  Created by sgcy on 15/11/16.
//  Copyright © 2015年 Mathijs Kadijk. All rights reserved.
//
import Foundation


let JSONExtensions: Set<String> = ["json"]

func ==(lhs: JSONType, rhs: JSONType) -> Bool {
    return (lhs.hashValue == rhs.hashValue)
}

private func dataStringToObject(dataString: String) -> AnyObject? {
    let data: NSData = dataString.dataUsingEncoding(NSUTF8StringEncoding)!
    do {
        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        return jsonObject
    } catch {
        return nil
    }
}

struct JSONType:CustomStringConvertible, Equatable, Hashable{
    let name:String
    init(name:String){
        self.name = name.capitalizeFirst
    }
    var description: String {
        return name
    }
    var hashValue: Int {
        return name.hashValue
    }
}

struct JSONVar: CustomStringConvertible {
    let name: String
    let type: JSONType
    let isArray: Bool
    var description: String {
        var newName = name
        if newName == "description"{
            newName = "description_p"
        }
        if isArray{
            return "var \(newName):[\(type)]?"
        }else{
            return "var \(newName): \(type)?"
        }
    }
}
let IndentationString = "  "
let indent = indentWithString(IndentationString)

struct JSONStruct: CustomStringConvertible {
    let type: JSONType
    let vars: [JSONVar]
    let structs: [JSONStruct]
    init(type: JSONType, vars: [JSONVar], structs: [JSONStruct]) {
        self.type = type
        self.vars = vars
        self.structs = structs
    }
    
    var description: String {
        let varsString = vars
            .sort { ($0.name) < ($1.name) }
            .joinWithSeparator("\n")

        let structsString = structs
            .sort { $0.type.description < $1.type.description }
            .joinWithSeparator("\n\n")
        
        let bodyComponents = [varsString,structsString].filter { $0 != "" }
        let bodyString = indent(bodyComponents.joinWithSeparator("\n\n"))
        return "class \(type):NSObject {\n\(bodyString)\n}"
    }
}

private func parse(json:[String:AnyObject],name:String) -> JSONStruct{
    var vars = [JSONVar]()
    var structs = [JSONStruct]()
    
    for key in json.keys{
        let value = json[key]
        if value is String{
            vars.append(JSONVar(name:key, type:JSONType(name:"String"),isArray:false))
        }else if value is [String]{
            vars.append(JSONVar(name:key, type:JSONType(name:"String"),isArray:true))
        }else if let jsonArray = value as? [[String:AnyObject]]{
            vars.append(JSONVar(name:key, type:JSONType(name:key),isArray:true))
             structs.append(parse(jsonArray[0],name:key))
        }else if let jsonObj = value as? [String:AnyObject]{
            vars.append(JSONVar(name:key, type:JSONType(name:key),isArray:false))
             structs.append(parse(jsonObj,name:key))
        }else{
            vars.append(JSONVar(name:key, type:JSONType(name:"String"),isArray:false))
          //  throw ResourceParsingError.ParsingFailed("JSON not String:AnyObject")
        }
    }
    return JSONStruct(type: JSONType(name:name), vars: vars, structs: structs)
}

struct JSON{
    let url:NSURL
    init(url: NSURL) throws {
        guard let pathExtension = url.pathExtension where JSONExtensions.contains(pathExtension) else{
            throw JSONParsingError.UnsupportedExtension(givenExtension: url.pathExtension, supportedExtensions: ["*"])
        }
        
        guard let filename = url.filename else {
            throw JSONParsingError.ParsingFailed("Couldn't extract filename without extension from URL: \(url)")
        }
        self.url = url
    }
    
    func extractJSONStruct() throws ->JSONStruct {
        let jsonObject = dataStringToObject(try NSString(contentsOfURL: self.url, encoding: NSUTF8StringEncoding) as String)
        if let jsonDic = jsonObject! as? [String:AnyObject]{
            let Obj = parse(jsonDic, name:url.filename!)
            return Obj
        }else{
            throw JSONParsingError.ParsingFailed("JSON not String:AnyObject")
        }
    }
}

struct JSONResources{
    let jsons: [JSON]

    init(resourceURLs: [NSURL],  fileManager: NSFileManager) {
        jsons = resourceURLs.flatMap{ (url) in tryResourceParsing{ try JSON(url: url) } }
    }
    
    func generateResourceStructsWithResources()->JSONStruct{
        let jsonStruct = JSONStruct(
            type: JSONType(name: "P"),
            vars: [],
            structs:jsons.flatMap{(json) in tryResourceParsing{
                try json.extractJSONStruct()}
            }
        )
        return jsonStruct
    }
}


private func tryResourceParsing<T>(parse: () throws -> T) -> T? {
    do {
        return try parse()
    } catch let JSONParsingError.ParsingFailed(humanReadableError) {
        print("[ERROR]:\(humanReadableError)")
        return nil
    } catch JSONParsingError.UnsupportedExtension {
        return nil
    } catch {
        return nil
    }
}

enum JSONParsingError: ErrorType {
    case UnsupportedExtension(givenExtension: String?, supportedExtensions: Set<String>)
    case ParsingFailed(String)
}
