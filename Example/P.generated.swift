// This is a generated file, do not edit!

// Generated by P.swift

import Foundation

class P:NSObject {
  class Index:NSObject {
    var data: Data?
    var rs_msg: String?
    var rs_status: String?
    
    class Data:NSObject {
      var cases:[Cases]?
      var doctors:[Doctors]?
      var slide:[Slide]?
      var tags:[Tags]?
      
      class Cases:NSObject {
        var comments: String?
        var image: String?
        var name: String?
        var nid: String?
        var title: String?
        var views: String?
      }
      
      class Doctors:NSObject {
        var avatar: String?
        var hname1: String?
        var hname2: String?
        var name: String?
        var tags:[Tags]?
        var title: String?
        var uid: String?
        
        class Tags:NSObject {
          var id: String?
          var name: String?
        }
      }
      
      class Slide:NSObject {
        var fid: String?
        var image: String?
        var nid: String?
        var title: String?
        var type: String?
        var url: String?
      }
      
      class Tags:NSObject {
        var id: String?
        var name: String?
      }
    }
  }
}