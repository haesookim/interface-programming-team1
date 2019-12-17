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
    //singleton
    static let shared = PlanList()
    
    //Raw data retrieved from database
    var completePlanRawArray : [Plan]
    
    //the actual complete list of data
    var completePlanList : [String: [String:[Plan]]]
    
    var planDate : String = "" // will be used as section data, which are dates (may use string?)

    private init(){
        // TODO: Load items in from database and append to planList
        
        // if there is no previous data, generate an example plan in completelist
        
        completePlanList = ["2019/12" : ["25" : [Plan(date: "2019/12/25",
                                                      time: "19:00",
                                                      whoCategory: WhoCategory.Family,
                                                      withWho: "Mr.Santa",
                                                      whatCategory: WhatCategory.Other,
                                                      doWhat: "Christmas!",
                                                      place: "Home")],
                                         ]
            
        ]
        
        // Retrieve raw plan data from database
        do{
            completePlanRawArray = try [Plan](fileName: "PlanData")
            if completePlanRawArray.count > 1{
                //Decode the raw plans to the intended complex dictionary form
                initPlanList()
            }
        }catch{
            completePlanRawArray = []
        }
  
        //var targetPlan = completePlanList["2019/12"]["25"][0]
    }

    func initPlanList() {
        completePlanList = [String: [String:[Plan]]]()
        
        let arrayToLoop = completePlanRawArray.sorted()
        for plan in arrayToLoop{
            guard let data = createNewPlan(Date: plan.date, time: plan.time, whoCategory: plan.whoCategory, withWho: plan.withWho, whatCategory: plan.whatCategory, doWhat: plan.doWhat, place: plan.place) else { return }
            addToCPL(item: data)
        }
    }
    
    //level 1 : implement adding plan with addplan.
    // if a new plan is successfully done, return the plan
    // if initializing new plan fails(level 0, returning nil), return nil
    func createNewPlan(Date: String, //input as yyyy/MM/dd
        time: String?,
        whoCategory: WhoCategory,
        withWho : String?,
        whatCategory: WhatCategory?,
        doWhat: String?,
        place : String?) -> Plan?{

        
        //init new Item
        //if let, in case of wrong input
        if let item = Plan(date: Date,
                           time: time,
                           whoCategory: whoCategory,
                           withWho: withWho,
                           whatCategory: whatCategory,
                           doWhat: doWhat,
                           place: place) {
            
            return item
        } else {
            return nil
        }
    }
    
    func addToCPL(item:Plan){
        
        let yearMonthKey = item.year+"/"+item.month
        let dayKey = item.day
        //add it to the completPlanlist
        if(completePlanList[yearMonthKey] == nil){ //create a new yearMonthKey entry if it doesn't exist
            completePlanList[yearMonthKey] = [:]
        }
        
        if (completePlanList[yearMonthKey]![dayKey] == nil){
            completePlanList[yearMonthKey]![dayKey] = [item]
        } else{
            completePlanList[yearMonthKey]![dayKey]!.append(item)
        }
    }
    
    func addToCPRA(item: Plan){
        completePlanRawArray.append(item)
        savePlanList()
        initPlanList()
    }
    
    func savePlanList(){
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("NewPlanData.json")
        print(fileUrl)
    
        // Transform array into data and save it into file
        do {
            var planEncodeArray : [Any] = []
            for plan in completePlanRawArray{
                let jsonObject = try JSONEncoder().encode(plan)
                let serializedObject = try JSONSerialization.jsonObject(with: jsonObject)
                planEncodeArray.append(serializedObject)
            }
            let data = try JSONSerialization.data(withJSONObject: planEncodeArray, options: [])

            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }

    }
       
    
    func deletePlan(date: String, index: Int){
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateValue = date.components(separatedBy: "/")
        let yearMonthKey = dateValue[0]+"/"+dateValue[1]
        let dayKey = dateValue[2]
        
        var planArray = completePlanList[yearMonthKey]![dayKey]
        planArray?.remove(at: index) // remove item at specified index value
        completePlanList[yearMonthKey]![dayKey] = planArray
        
        if(completePlanList[yearMonthKey]![dayKey]!.count == 0){
            completePlanList[yearMonthKey]!.removeValue(forKey: dayKey)
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
        if(completePlanList[newyearMonthKey] == nil){ //create a new yearMonthKey entry if it doesn't exist
            completePlanList[newyearMonthKey] = [:]
        }
        if (completePlanList[newyearMonthKey]?[newdayKey] == nil){
            completePlanList[newyearMonthKey]?[newdayKey] = [targetPlan]
        } else{
            completePlanList[newyearMonthKey]?[newdayKey]?.append(targetPlan)
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
        
        let originalPlan = completePlanList[yearMonthKey]![dayKey]?[originalIndexPath.row - 1] //the actual plan
        
        
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
        deletePlan(date: originalPlan!.date, index: originalIndexPath.row-1)
        
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
