//
//  Plan.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

enum WhoCategory : Equatable{
    case Friend
    case SignificantOther
    case Family
    case Work
    case Club
    case Religion
    case Other
    case Undefined // Initial state
}

enum WhatCategory : Equatable{
    case Work
    case Other
    case Undefined //Initial state
    
}


class Plan{
    
    //PLAN HOLDS ONLY THE REFINED DATA - ALL THE REFINING PROCESS WILL BE DONE IN PLANLIST
    
    
    //time
    var date: String; //Parse date information from viewcontroller
    var time: String; //dataType may change
    
    //who
    var whoCategory : WhoCategory
    var withWho : [String]?
    var withWhoCount: Int?
    
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
        self.whatCategory = whatCategory ?? WhatCategory.Other
        self.doWhat = doWhat ?? ""
        self.place = place ?? ""
        
    }
    
    func editPlan(){
        
    }
    
    func seeDetail(){
        
    }
}
