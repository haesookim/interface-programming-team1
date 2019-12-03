//
//  Plan.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

enum Category : Equatable{
    case Friend
    case SignificantOther
    case Family
    case Work
    case Club
    case Religion
    case Other
    case Undefined // Initial state
}

class Plan{
    var date: Date; //Parse date information from viewcontroller
    var time: String; //dataType may change
    var category: Category;
    var peopleCount: Int;
    var meetingWith: String;
    var notes: String;
    
    init!(date: Date, time: String, category: Category, peopleCount: Int, meetingWith: String?, notes: String?){
        if (time.isEmpty || category == Category.Undefined || peopleCount < 0) {
            return nil
            // fail init when the above required fields are empty
            // We may forego this data validation step by adding a client-side prevention
        }
        
        self.date = date;
        self.time = time;
        self.category = category;
        self.peopleCount = peopleCount;
        self.meetingWith = meetingWith ?? ""; // default to empty string
        self.notes = notes ?? ""; // default to empty string
        
    }
    
    func editPlan(){
        
    }
    
    func seeDetail(){
        
    }
}
