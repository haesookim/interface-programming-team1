//
//  PlanList.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation


class PlanList {
    
    //the actual complete list of data
    var completePlanList : [String: [String:[Plan]]]

    var planDate : String = "" // will be used as section data, which are dates (may use string?)
    
    
    init(){
        // TODO: Load items in from database and append to planList
        
        // if there is no previous data, generate an example plan in completelist
        
        completePlanList = ["2019/12" : ["25" : [Plan(date: "25",
                                                      time: "19:00",
                                                      whoCategory: WhoCategory.Family,
                                                      withWho: ["Parents", "Mr.Santa"],
                                                      whatCategory: WhatCategory.Other,
                                                      doWhat: "House Party",
                                                      place: "Home")],
                                        "31" : [Plan(date: "31",
                                                        time: "23:55",
                                                        whoCategory: WhoCategory.Family,
                                                        withWho: ["Parents"],
                                                        whatCategory: WhatCategory.Other,
                                                        doWhat: "Ready for Countdown",
                                                        place: "Home")]]    ]
        
        
    }
    
    func addNewPlan(rawDate: Date,
                    time: String?,
                    whoCategory: WhoCategory,
                    withWhoString : String?,
                    whatCategory: WhatCategory?,
                    doWhat: String?,
                    place : String?) -> Plan {
        
        
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateValue = dateFormatter.string(from: rawDate).components(separatedBy: "-")
        let yearMonthKey = dateValue[0]+"/"+dateValue[1]
        let dayKey = dateValue[2]
        
        
        //format withWho
        let withWho = withWhoString?.components(separatedBy: ",")
        
        
        //init new Item
        let item = Plan(date: dayKey,
                        time: time,
                        whoCategory: whoCategory,
                        withWho: withWho,
                        whatCategory: whatCategory,
                        doWhat: doWhat,
                        place: place)
        
        
        //add it to the completPlanlist
        if(completePlanList[yearMonthKey] == nil){ //create a new yearMonthKey entry if it doesn't exist
            completePlanList[yearMonthKey] = [:]
        }
        if (completePlanList[yearMonthKey]![dayKey] == nil){
            completePlanList[yearMonthKey]![dayKey] = [item!]
        } else{
            completePlanList[yearMonthKey]![dayKey]?.append(item!)
        }
        
        return item!;
    }
    
    
    
    func deletePlan(date: Date, index: Int){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateValue = dateFormatter.string(from: date).components(separatedBy: "-")
        let yearMonthKey = dateValue[0]+"/"+dateValue[1]
        let dayKey = dateValue[2]
        
        var planArray = completePlanList[yearMonthKey]?[dayKey]
        planArray?.remove(at: index) // remove item at specified index value
        completePlanList[yearMonthKey]?[dayKey] = planArray
    }
}
