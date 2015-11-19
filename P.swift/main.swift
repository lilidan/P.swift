//
//  main.swift
//  P.swift
//
//  Created by sgcy on 15/11/19.
//  Copyright © 2015年 sgcy. All rights reserved.
//

import Foundation



do {
    let callInformation = try CallInformation(processInfo: NSProcessInfo.processInfo())
    
    let xcodeproj = try Xcodeproj(url: callInformation.xcodeprojURL)
    let resourceURLs = try xcodeproj.resourceURLsForTarget(callInformation.targetName, pathResolver: pathResolverWithSourceTreeFolderToURLConverter(callInformation.URLForSourceTreeFolder))
    
    let jsonRes = JSONResources(resourceURLs: resourceURLs, fileManager: NSFileManager.defaultManager())
    let jsonStruct = jsonRes.generateResourceStructsWithResources()
    let jsonfileContents = [
        Header,
        Imports,
        jsonStruct.description
        ].joinWithSeparator("\n\n")
    
    // Write file if we have changes
    if readResourceFile(callInformation.outputURL) != jsonfileContents {
        writeResourceFile(jsonfileContents, toFileURL: callInformation.outputURL)
    }
    
} catch let InputParsingError.UserAskedForHelp(helpString: helpString) {
    print(helpString)
    exit(1)
} catch let InputParsingError.IllegalOption(helpString: helpString) {
    print(helpString)
    exit(2)
} catch let InputParsingError.MissingOption(helpString: helpString) {
    print(helpString)
    exit(2)
} catch let JSONParsingError.ParsingFailed(description) {
    print(description)
    exit(3)
}
