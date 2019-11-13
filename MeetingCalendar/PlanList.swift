//
//  PlanList.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

class PlanList {
    var planList: [Plan] = [] // Init as empty array
    
    init(){
        // TODO: Load items in from database and append to planList
    }
    
    func addNewPlan(date: String, time: String, category: Category, peopleCount: Int, meetingWith: String?, notes: String?) -> Plan {
        
        //init new Item
        let item = Plan(date: date, time: time, category: category, peopleCount: peopleCount, meetingWith: meetingWith, notes: notes);
        
        planList.append(item!); // force-unwrap
        return item!;
    }
}
