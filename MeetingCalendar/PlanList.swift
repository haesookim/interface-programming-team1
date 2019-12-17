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
        
        completePlanList = ["2019/12" : ["25" : [Plan(planID:"1",
                                                      date: "2019/12/25",
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
            guard let data = createNewPlan(planID: plan.planID, Date: plan.date, time: plan.time, whoCategory: plan.whoCategory, withWho: plan.withWho, whatCategory: plan.whatCategory, doWhat: plan.doWhat, place: plan.place) else { return }
            addToCPL(item: data)
            
            LocalNotificationManager.notifManager.notifications.append(
                Notification(id: UUID().uuidString, title: "일정 알림입니다", datetime: DateComponents(calendar: Calendar.current, year: Int(data.year), month: Int(data.month), day: Int(data.day)!, hour: 2, minute: 44)))
        }
    }
    
    //level 1 : implement adding plan with addplan.
    // if a new plan is successfully done, return the plan
    // if initializing new plan fails(level 0, returning nil), return nil
    func createNewPlan(planID: String,
                       Date: String, //input as yyyy/MM/dd
        time: String?,
        whoCategory: WhoCategory,
        withWho : String?,
        whatCategory: WhatCategory?,
        doWhat: String?,
        place : String?) -> Plan?{

        //init new Item
        //if let, in case of wrong input
        if let item = Plan(
            planID: planID,
            date: Date,
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
    
    
    func deletePlanFromCPRA(targetPlan : Plan){
        
        for i in 0..<completePlanRawArray.count{
            if(completePlanRawArray[i].planID == targetPlan.planID){
                completePlanRawArray.remove(at: i)
                break;
            }
        }
        
        savePlanList()
        initPlanList()
        
    }
    
}
