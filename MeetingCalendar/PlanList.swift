////
////  PlanList.swift
////  MeetingCalendar
////
////  Created by Haesoo Kim on 13/11/2019.
////  Copyright © 2019 Haesoo Kim. All rights reserved.
////
//
//import Foundation
//
//
//struct cellData{ //this shall be merged into planlist in order to be coherent
//    
//    var dates : String //using string for test - need to adjust suitable format - date?
//    var plans : [String]//[Plan] //using string for test
//    
//    
//}
//
//var CompletePlanList : [String: Dictionary]
//
//class PlanList {
//    var planList: [String: NSMutableDictionary] = [:] // Init as empty dict
//    
//    var monthlyList: [String: NSMutableDictionary] = [:]
//    
//    var planDate : String = "" // will be used as section data, which are dates (may use string?)
//    
//    
//    init(date: String){
//        // TODO: Load items in from database and append to planList
//        
//        // need default initializing
//        // if section for plandate already exist, addNewPlan shall be ran, not init.
//        // if section for plandate does not exist, init and addNewPlan there.
//        // in conclusion, only consider case where new planlist for a certain date is needed
//        planDate = "19/12/24"
////        planList = [Plan(date: planDate, time: "19:00", category: Category.Friend, peopleCount: 1, meetingWith: "", notes: "")]
//        
//    }
//    
//    func addNewPlan(date: Date, time: String, category: Category, peopleCount: Int, meetingWith: String?, notes: String?) -> Plan {
//        
//        //init new Item
//        let item = Plan(date: date, time: time, category: category, peopleCount: peopleCount, meetingWith: meetingWith, notes: notes);
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let dateValue = dateFormatter.string(from: date).components(separatedBy: "-")
//        let yearMonthKey = dateValue[0]+"/"+dateValue[1]
//        let dayKey = dateValue[2]
//        
//        if (!((planList[yearMonthKey]?[dayKey]) != nil)){
//            planList[yearMonthKey]?[dayKey] = [item]
//        } else{
//            planList[yearMonthKey]?[dayKey].append(item)
//        }
//        return item!;
//    }
//    
//    func deletePlan(index: Int){
//        planList.remove(at: index) // remove item at specified index value
//    }
//}
