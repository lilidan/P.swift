# P.swift
Convert JSON to Object in one line of code. Inspired by [R.swift](https://github.com/mac-cain13/R.swift).

Current version: 0.1

![](https://github.com/lilidan/P.swift/blob/master/themov.gif)

Currently you do with JSON:
```swift
// Example for SwiftyJSON
if let statusesArray = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]],
    let user = statusesArray[0]["user"] as? [String: AnyObject],
    let username = user["name"] as? String {
    ...
}
// Example for ObjectMapper,JSONHelper
class User: Mappable {
    var username: String?
    var age: Int?
    var weight: Double!
    required init?(_ map: Map) {
        username <- ...
        age <- ...
        weight <- ...
    }
```

With P.swift it becomes:
```swift
if let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]{
   let obj:P.Obj = P.parseJsonToObject(jsonObject, classType: P.Obj.self)
   print obj.foo?.bar?
}
```

## Why use this?

1.**Automatically generate** the classes,no need to code. (Compared with ObjectMapper,JSONHelper)

2.**Compiletime check** and **autocompleted**.(Compared with SwiftyJSON)

3.Modifiable value and inheritable class.(Compared with SwiftyJSON) 

## Installation

1. Download a P.swift release, unzip it and put it into your source root directory
2. In XCode: Click on your project in the file list, choose your target under `TARGETS`, click the `Build Phases` tab and add a `New Run Script Phase` by clicking the little plus icon in the top left
3. Drag the new `Run Script` phase **above** the `Compile Sources` phase, expand it and paste the following script: `"$SRCROOT/.../pswift" "$SRCROOT"`,replace `...` to make sure the `pswift` file is into that folder
4. Drag the `P.Parser` file to your project.
5. Build your project, in Finder you will now see a `P.generated.swift` in the `$SRCROOT`-folder, drag the `R.generated.swift` files into your project and **uncheck** `Copy items if needed`


## TO DO
1.Handle the conficts caused by variable names.(id,description..) 

2.Support more data types.(Number,Date..) 

3.Avoid duplicate classes in P.generate.swift. 

...

## License
The MIT License.
