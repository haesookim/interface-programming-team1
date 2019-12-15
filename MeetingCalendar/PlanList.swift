//
//  PlanList.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation


// TODO : PlanList should be set as singleton

class PlanList {
    
    
    private init(){
        // TODO: Load items in from database and append to planList
        
        // if there is no previous data, generate an example plan in completelist
        
        completePlanList = ["2019/12" : ["25" : [Plan(date: "2019/12/25",
                                                      time: "19:00",
                                                      whoCategory: WhoCategory.Family,
                                                      withWho: ["Parents", "Mr.Santa"],
                                                      whatCategory: WhatCategory.Other,
                                                      doWhat: "House Party",
                                                      place: "Home")],
                                        "31" : [Plan(date: "2019/12/31",
                                                        time: "23:55",
                                                        whoCategory: WhoCategory.Family,
                                                        withWho: ["Parents"],
                                                        whatCategory: WhatCategory.Other,
                                                        doWhat: "Ready for Countdown",
                                                        place: "Home")]],
                            "2020/1" : ["1" : [Plan(date: "2020/1/1",
                                                        time: "00:00",
                                                        whoCategory: WhoCategory.Family,
                                                        withWho: ["Parents"],
                                                        whatCategory: WhatCategory.Other,
                                                        doWhat: "NewYears",
                                                        place: "Home")]]
            
        ]
        do{
            completePlanRawArray = try [PlanData](fileName: "PlanData")
        }catch{
            completePlanRawArray = []
        }
        
        //var targetPlan = completePlanList["2019/12"]["25"][0]
    }
    
    //singleton
    static let shared = PlanList()
    
    //Raw data retrieved from database
    var completePlanRawArray : [PlanData]
    
    //the actual complete list of data
    var completePlanList : [String: [String:[Plan]]]

    var planDate : String = "" // will be used as section data, which are dates (may use string?)
    
    
    //level 1 : implement adding plan with addplan.
    // if a new plan is successfully done, return the plan
    // if initializing new plan fails(level 0, returning nil), return nil
    func addNewPlan(Date: String, //input as yyyy/MM/dd
                    time: String?,
                    whoCategory: WhoCategory,
                    withWhoString : String?,
                    whatCategory: WhatCategory?,
                    doWhat: String?,
                    place : String?) -> Plan?{
        
        
        //format withWho
        let newString = withWhoString?.replacingOccurrences(of: ", ", with: ",")
        let withWho = newString?.components(separatedBy: ",")
        
        
        //init new Item
        //if let, in case of wrong input
        if let item = Plan(date: Date,
                        time: time,
                        whoCategory: whoCategory,
                        withWho: withWho,
                        whatCategory: whatCategory,
                        doWhat: doWhat,
                        place: place) {

            let yearMonthKey = item.year+"/"+item.month
            let dayKey = item.day
            
            //add it to the completPlanlist
            if(PlanList.shared.completePlanList[yearMonthKey] == nil){ //create a new yearMonthKey entry if it doesn't exist
                PlanList.shared.completePlanList[yearMonthKey] = [:]
            }
            if (PlanList.shared.completePlanList[yearMonthKey]![dayKey] == nil){
                PlanList.shared.completePlanList[yearMonthKey]![dayKey] = [item]
            } else{
                PlanList.shared.completePlanList[yearMonthKey]![dayKey]?.append(item)
            }
            
            return item
        }else {
            return nil
        }
    }
    
    
    
    func deletePlan(date: String, index: Int){
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        let dateValue = date.components(separatedBy: "/")
        let yearMonthKey = dateValue[0]+"/"+dateValue[1]
        let dayKey = dateValue[2]
        
        var planArray = completePlanList[yearMonthKey]?[dayKey]
        planArray?.remove(at: index) // remove item at specified index value
        completePlanList[yearMonthKey]?[dayKey] = planArray
        
        if(completePlanList[yearMonthKey]?[dayKey]?.count == 0){
            completePlanList[yearMonthKey]?.removeValue(forKey: dayKey)
            print("empty plan removed")
        }
        
    }
    
    func editTargetPlan(targetPlan : Plan, newDate : String){
        //minor changes will have been directly edited already
        //zb.withwhostringtoarray
        // except the dates
        
        //need to re-calculate position in the completeplanlist
        let newDateArray = newDate.components(separatedBy: "/")
        let newyearMonthKey = newDateArray[0]+"/"+newDateArray[1]
        let newdayKey = newDateArray[2]
        
        //add it to the completPlanlist
        if(PlanList.shared.completePlanList[newyearMonthKey] == nil){ //create a new yearMonthKey entry if it doesn't exist
            PlanList.shared.completePlanList[newyearMonthKey] = [:]
        }
        if (PlanList.shared.completePlanList[newyearMonthKey]![newdayKey] == nil){
            PlanList.shared.completePlanList[newyearMonthKey]![newdayKey] = [targetPlan]
        } else{
            PlanList.shared.completePlanList[newyearMonthKey]![newdayKey]?.append(targetPlan)
        }
        
        //delete original
        let yearMonthKey = targetPlan.year+"/"+targetPlan.month
        let dayKey = targetPlan.day
        
        
        var planArray = completePlanList[yearMonthKey]?[dayKey]
        //planArray?.remove(at: index) // remove item at specified index value
        completePlanList[yearMonthKey]?[dayKey] = planArray
        
    }
    
    
    
    //try not using this for now
    func editPlan(originalIndexPath : IndexPath, //information about secondary key
                    yearMonthKey : String,
                    date: String, //input as yyyy/MM/dd
                    time: String?,
                    whoCategory: WhoCategory,
                    withWhoString : String?,
                    whatCategory: WhatCategory?,
                    doWhat: String?,
                    place : String?){
        
        //return the plan of the indexpath
        //get yearmonth key - the indexpath does not contain information about year
        //therefore, information of the yearMonthKey needs to be given
        
        //get day key
        let sortedDatesofMonth = Array(completePlanList[yearMonthKey]!.keys).sorted(by : <)
        
        let dayKey = sortedDatesofMonth[originalIndexPath.section]

        //get the actual plan - which always exist
        
        let originalPlan = completePlanList[yearMonthKey]![dayKey ]![originalIndexPath.row - 1] //the actual plan
        
        
        //solved PROBLEM : original plan is altered immediately. why?
        //im guessing the mechanism is call by reference, since planlist is a singlton
        //so lets just do the blunt way of deleting and adding regardless
        
        print(dayKey)
        
        
        //check for change in date
        //if(originalPlan.date != date){
            //if so, addnewplan
//            _ = addNewPlan(Date: date,
//                                     time: time,
//                                     whoCategory: whoCategory,
//                                     withWhoString: withWhoString,
//                                     whatCategory: whatCategory,
//                                     doWhat: doWhat,
//                                     place: place)
            
            //and delete original plan
            deletePlan(date: originalPlan.date, index: originalIndexPath.row-1)
            
//        }
//
//
//        //else, meaning that the date stays, just apply the other changes
//        else{
//            originalPlan.editPlan(time: time, whoCategory: whoCategory, withWhoString: withWhoString, whatCategory: whatCategory, doWhat: doWhat, place: place)
//
//        }
        
        
    }
    
    
}
