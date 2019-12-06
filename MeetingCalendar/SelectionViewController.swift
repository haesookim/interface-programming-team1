//
//  SelectionViewController.swift
//  MeetingCalendar
//
//  Created by KimHaesoo on 03/12/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    var selectedPlan : Plan
    var selectedIndexPath : IndexPath
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        selectedPlan = Plan(date: "", time: <#T##String?#>, whoCategory: WhoCategory.Undefined, withWho: <#T##[String]?#>, whatCategory: <#T##WhatCategory?#>, doWhat: <#T##String?#>, place: <#T##String?#>)
//        selectedIndexPath =
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func doneEditing(_ sender : Any){
        
        //apply all the changes
        
        //perform segue
        performSegue(withIdentifier: "" , sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var listVC = segue.destination as! ViewController
        listVC.currentMonthPlans[ listVC.sortedDatesofMonth[selectedIndexPath.section] ]![selectedIndexPath.row] = selectedPlan
    }
    
    
    //action : close VC and sent data back
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
