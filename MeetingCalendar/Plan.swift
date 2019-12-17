//
//  Plan.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

enum WhoCategory : String, CaseIterable, Codable{
    case Friend = "친구"
    case SignificantOther = "연인"
    case Family = "가족"
    case Work = "동료"
    case Club = "동아리"
    case Religion = "종교"
    case Other = "기타"
    case Undefined = "" // Initial state
    
    var value:String {
        switch self{
            case .Friend : return "1"
            case .SignificantOther : return "2"
            case .Family : return "3"
            case .Work : return "4"
            case .Club : return "5"
            case .Religion : return "6"
            case .Other : return "7"
            case .Undefined : return ""
        }
    }
}

enum WhatCategory : String, CaseIterable, Codable{
    case Celebrate = "축하한다"
    case Party = "파티를 한다"
    case Meeting = "회의한다"
    case Reluctant = "안 보고 싶다"
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
    
    var value:String {
        switch self{
            case .Celebrate : return "celebrate"
            case .Party : return "party"
            case .Meeting : return "meeting"
            case .Reluctant : return "reluctant"
            case .Music : return "music"
            case .Date : return "date"
            case .Important : return "important"
            case .Rest : return "rest"
            case .Anniversary : return "anniv"
            case .Food : return "food"
            case .Movie : return "movie"
            case .Cafe : return "cafe"
            case .Exercise : return "exercise"
            case .Create : return "create"
            case .Drink : return "drink"
            case .Study : return "study"
            case .Pray : return "pray"
            case .Service : return "service"
            case .Game : return "game"
            case .Concert : return "concert"
            case .Shopping : return "shopping"
            case .Travel : return "travel"
            case .Hospital : return "hospital"
            case .Other : return ""
            case .Undefined : return ""
        }
    }

}

// TODO : input type of Dates should be confirmed
// TODO : customizing catogories needed...?


class Plan : Comparable, Codable{
    
    //unique identifier
    var planID : String;
    
    
    //time
    var date: String; //Parse date information from viewcontroller
    var year: String
    var month : String
    var day : String
    
    var time: String?; //dataType may change
    
    //who
    var whoCategory : WhoCategory
    var withWho : String?
    
    //what
    var whatCategory : WhatCategory?
    var doWhat : String?
    
    //where
    var place : String?

    
    init!(planID: String,
          date: String, // yyyy/MM/dd format
          time: String?,
          whoCategory: WhoCategory,
          withWho: String?,
          whatCategory: WhatCategory?,
          doWhat: String?,
          place : String?){
        
        
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
        self.planID = planID
        
        self.date = date
        
        self.year = dateArray[0]
        self.month = dateArray[1]
        self.day = dateArray[2]
        
        self.time = time ?? ""
        self.whoCategory = whoCategory
        self.withWho = withWho ?? ""
        self.whatCategory = whatCategory ?? WhatCategory.Undefined
        self.doWhat = doWhat ?? ""
        self.place = place ?? ""
        
        
        
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
        self.withWho = withWho ?? ""
        self.whatCategory = whatCategory ?? WhatCategory.Undefined
        self.doWhat = doWhat ?? ""
        self.place = place ?? ""
        
        
    }
    
    
    //Database
    
    enum DecodingError: Error {
        case missingFile
    }
    
    func save(directory: FileManager.SearchPathDirectory) throws {
        let kindDirectoryURL = URL(fileURLWithPath: "", relativeTo: FileManager.default.urls(for: directory, in: .userDomainMask)[0])
        //print(kindDirectoryURL)

        try? FileManager.default.createDirectory(at: kindDirectoryURL, withIntermediateDirectories: true)
    }
    
    // Comparable functions for sorting
    static func ==(lhs: Plan, rhs: Plan) -> Bool {
        return lhs.date == rhs.date && lhs.time == rhs.time
    }

    static func <(lhs: Plan, rhs: Plan) -> Bool {
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

extension Array where Element == Plan {
    init(fileName: String) throws {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { throw Plan.DecodingError.missingFile }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("NewPlanData.json")
        
        let data = try Data(contentsOf: fileUrl)
        let decoder = JSONDecoder()
        self = try decoder.decode([Plan].self, from: data)
    }
}

