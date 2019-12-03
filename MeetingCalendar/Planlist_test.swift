//
//  Planlist_test.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 03/12/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import Foundation

class PlanList {
    var list : [String: [String:[String: [Plan]]]] = [:]
    
    func addNewPlan() -> Plan{
        let planItem = new Plan()
        return planItem
    }
}



