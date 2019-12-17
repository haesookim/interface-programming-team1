//
//  Plan.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

enum WhoCategory : String, CaseIterable, Decodable{
    case Friend = "친구"
    case SignificantOther = "연인"
    case Family = "가족"
    case Work = "동료"
    case Club = "동아리"
    case Religion = "종교"
    case Other = "기타"
    case Undefined = "" // Initial state
}

enum WhatCategory : String, CaseIterable, Decodable{
    case Celebrate = "축하한다"
    case Party = "파티를 한다"
    case Meeting = "회의한다"
    case Reluctanct = "안 보고 싶다"
    case Music = "음악을 한다"
    case Date = "데이트를 한다"
    case Important = "중요한 날이다"
    case Rest = "쉰다"
    case Anniversary = "기념일이다"
    case Food = "맛있는 걸 먹는다"
    case Movie = "영화를 본다"
    case Cafe = "카페를 간다"
    case Exercise = "운동한다"
    case Create = "창작한다"
    case Drink = "술을 마신다"
    case Study = "공부한다"
    case Pray = "기도한다"
    case Service = "봉사한다"
    case Game = "게임한다"
    case Concert = "공연을 본다"
    case Shopping = "쇼핑한다"
    case Travel = "여행간다"
    case Hospital = "병원을 간다"
    case Other = "기타"
    case Undefined = "" //Initial state

}

// TODO : input type of Dates should be confirmed
// TODO : customizing catogories needed...?


class Plan{
    
    //PLAN HOLDS ONLY THE REFINED DATA - ALL THE REFINING PROCESS WILL BE DONE IN PLANLIST
    
    
    //time
    var date: String; //Parse date information from viewcontroller
    var year: String
    var month : String
    var day : String
    
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

    
    init!(date: String, // yyyy/MM/dd format
          time: String?,
          whoCategory: WhoCategory,
          withWho: [String]?,
          whatCategory: WhatCategory?,
          doWhat: String?,
          place : String?        ){
        
        let dateArray = date.components(separatedBy: "/")
               
        
        //much more precise approach?
        //level 0 : if input data for initializing is not enough, return nil
        if (dateArray[0].isEmpty || dateArray[1].isEmpty || dateArray[2].isEmpty || dateArray.count != 3
            || whoCategory == WhoCategory.Undefined ) {
            print("plan went wrong")
            return nil
            // fail init when the above required fields are empty
            // We may forego this data validation step by adding a client-side prevention
            // this I agree.
        }
        
        self.date = date
        
        self.year = dateArray[0]
        self.month = dateArray[1]
        self.day = dateArray[2]
        
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
    
    
    //for editing the plan, without change in dates(key)
    func editPlan( time: String?,
                 whoCategory: WhoCategory,
                 withWhoString : String?,
                 whatCategory: WhatCategory?,
                 doWhat: String?,
                 place : String?){
        
        self.time = time ?? ""
        self.whoCategory = whoCategory
        //self.withWho = withWho ?? [""]
        self.withWhoStringToArray(withWhoString ?? "")
        self.withWhoCount = withWho?.count ?? 0
        self.whatCategory = whatCategory ?? WhatCategory.Undefined
        self.doWhat = doWhat ?? ""
        self.place = place ?? ""
        
        
    }
    
    
    func withWhoStringToArray(_ newWithWhoString : String){
        withWhoString = newWithWhoString
        let newString = withWhoString?.replacingOccurrences(of: ", ", with: ",")
        withWho = newString?.components(separatedBy: ",")
        withWhoCount = withWho?.count
      
        
    }
    
    func withWhoArrayToString(_ newWithWhoArray : [String]){
        withWho = newWithWhoArray
        withWhoCount = withWho?.count
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
    
    func printforDebug(){
        print("date : \(date)\n time : \(time)\n whoCat : \(whoCategory.rawValue)\n withWhoString : \(withWhoString)\n whatCategory : \(whatCategory?.rawValue)\n doWhat : \(doWhat)\n where : \(place)")
        
    }

}

// For database entry

struct PlanData: Decodable, Comparable{
    enum DecodingError: Error {
        case missingFile
    }

    let date: String
    let time: String?
    let whoCategory: WhoCategory //TODO: Check if this is the right value to recieve
    let withWho: String?
    let whatCategory: WhatCategory
    let doWhat: String?
    let place: String?

    func save(directory: FileManager.SearchPathDirectory) throws {
        let kindDirectoryURL = URL(fileURLWithPath: "", relativeTo: FileManager.default.urls(for: directory, in: .userDomainMask)[0])

        try? FileManager.default.createDirectory(at: kindDirectoryURL, withIntermediateDirectories: true)
    }
    
    // Comparable functions for sorting
    static func ==(lhs: PlanData, rhs: PlanData) -> Bool {
        return lhs.date == rhs.date && lhs.time == rhs.time
    }

    static func <(lhs: PlanData, rhs: PlanData) -> Bool {
        let lhsDate = lhs.date
        let rhsDate = rhs.date

        
        if (lhsDate != rhsDate){
            return lhsDate < rhsDate
        } else {
            var lhsTime = ""
            var rhsTime = ""
            if lhs.time != nil{
                lhsTime = lhs.time!
            }
            if rhs.time != nil{
                rhsTime = rhs.time!
            }

            return lhsTime < rhsTime
        }
    }
}

extension Array where Element == PlanData {
    init(fileName: String) throws {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw PlanData.DecodingError.missingFile
        }
    
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        self = try decoder.decode([PlanData].self, from: data)
    }
}

