//
//  Plan.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

enum WhoCategory : String{
    case Friend = "친구"
    case SignificantOther = "연인"
    case Family = "가족"
    case Work = "동료"
    case Club = "동아리"
    case Religion = "종교"
    case Other = "기타"
    case Undefined = "" // Initial state
}

enum WhatCategory : String{
    case Work = "일"
    case Other = "기타"
    case Undefined = "" //Initial state
    
}


class Plan{
    
    //PLAN HOLDS ONLY THE REFINED DATA - ALL THE REFINING PROCESS WILL BE DONE IN PLANLIST
    
    
    //time
    var date: String; //Parse date information from viewcontroller
    var time: String?; //dataType may change
    
    //who
    var whoCategory : WhoCategory
    var withWho : [String]?
    var withWhoCount: Int?
    var withWhoString : String? //for convenience purpose
    
    //what
    var whatCategory : WhatCategory?
    var doWhat : String?
    
    //where
    var place : String?

    
    init!(date: String,
          time: String?,
          whoCategory: WhoCategory,
          withWho: [String]?,
          whatCategory: WhatCategory?,
          doWhat: String?,
          place : String?        ){
        
        if (date.isEmpty || whoCategory == WhoCategory.Undefined ) {
            print("plan went wrong")
            return nil
            // fail init when the above required fields are empty
            // We may forego this data validation step by adding a client-side prevention
            // this I agree.
        }
        
        self.date = date
        self.time = time ?? ""
        self.whoCategory = whoCategory
        self.withWho = withWho ?? [""]
        self.withWhoCount = withWho?.count ?? 0
        self.whatCategory = whatCategory ?? WhatCategory.Undefined
        self.doWhat = doWhat ?? ""
        self.place = place ?? ""
        
        
        
        if(withWho!.count > 1){
                           var str = ""
                           
                           //re-generate withWhoString
                           for e in (withWho)!{
                               if(str == ""){
                                   str = e
                               }else{
                                   str += ( ", " + e )
                               }
                           }
                           
                           withWhoString = str
        }else{
            withWhoString = withWho![0]
            
        }
        
    }
    
    func editPlan(){
        
    }
    
    func seeDetail(){
        
    }
    
    
    func withWhoStringToArray(_ newWithWhoString : String){
        withWhoString = newWithWhoString
        let newString = withWhoString?.replacingOccurrences(of: ", ", with: ",")
        withWho = newString?.components(separatedBy: ",")
      
        
    }
    
    func withWhoArrayToString(_ newWithWhoArray : [String]){
        withWho = newWithWhoArray
        if(withWho!.count > 1){
                                  var str = ""
                                  
                                  //re-generate withWhoString
                                  for e in (withWho)!{
                                      if(str == ""){
                                          str = e
                                      }else{
                                          str += ( ", " + e )
                                      }
                                  }
                                  
                                  withWhoString = str
               }else{
                   withWhoString = withWho![0]
        }
        
    }
    
}
