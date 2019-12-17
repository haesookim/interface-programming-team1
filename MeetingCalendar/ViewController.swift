//
//  ViewController.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //for current month
    var currentMonthString : String //key for the completeDict
    var currentMonthPlans : [ String:[Plan] ] //]dictionary of entries with key string and plan array as value
    //needs to be refreshed in every monthchange action, ordered too
    
    //sorted array of dictionary keys, that will be used as sections
    var sortedDatesofMonth : [String]
    
    var yearMonthPair : [Int]
    
    //parameters for data transfer
    var indexPathforEditing : IndexPath
    var planforEditing : Plan
    var monthStringforEditing : String
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var monthIcon : UIButton!
    let MonthArray = ["jan","feb","mar","apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
    
    @IBAction func toPreviousMonth(_ sender: Any) {
        
        if (yearMonthPair[1] <= 1 ) {
            yearMonthPair[1] = 12
            yearMonthPair[0] -= 1
            
        } else {
            yearMonthPair[1] -= 1
            
        }
        
        applyMonthChange()
        tableView.reloadData()
    }
    
    
    @IBAction func toNextMonth(_ sender: Any) {
        
        if (yearMonthPair[1] >= 12 ) {
            yearMonthPair[1] = 1
            yearMonthPair[0] += 1
            
        } else {
            yearMonthPair[1] += 1
            
        }
        
        applyMonthChange()
        tableView.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        applyMonthChange()
        tableView.reloadData()
    }
    
    
    func applyMonthChange(){
        
        //re-calculate currentmonth and extract currentMonthPlans
        if yearMonthPair[1] > 9 {
            currentMonthString = String(yearMonthPair[0]) + "/" + String(yearMonthPair[1])
        }else {
            currentMonthString = String(yearMonthPair[0]) + "/0" + String(yearMonthPair[1])
        }
        currentMonthPlans.removeAll()
        
        //use if let in case of months with no plans
        if let monthList = PlanList.shared.completePlanList[currentMonthString] {
            for (key, value) in monthList{
                currentMonthPlans[key] = value
            }
        } else {print("No plans in current month!")}
        
        //sortedDatesofMonth = Array(currentMonthPlans.keys).sorted(by : <)
        
        //debug purposes
        //print("current year/month = " + "\(currentMonthString)")
        
        // update the month icon according to change made
        let imageName = "font_" + MonthArray[yearMonthPair[1]-1]
        let monthImage = UIImage(named: "\(imageName).png")!
        self.monthIcon.setImage(monthImage, for: .normal)
        
        //update the table
        //currentMonthPlans.removeValue(forKey: "")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    required init?(coder: NSCoder) {
        
        //is required if initializing is needed
        //myPlanList = PlanList()
        
        sortedDatesofMonth = [""]
        
        currentMonthString = "2019/12"
        
        currentMonthPlans = [ "":[] ]
        for (key, value) in PlanList.shared.completePlanList[currentMonthString]!{
            currentMonthPlans[key] = value
            
        }
        currentMonthPlans.removeValue(forKey: "")
        
        yearMonthPair = [2019, 12]
        
        
        
        
        indexPathforEditing = IndexPath(row: 1, section: 1)
        planforEditing = Plan(date: "2019/12/25", time: "", whoCategory: WhoCategory.Other, withWho: [""], whatCategory: WhatCategory.Undefined, doWhat: "", place: "")
        monthStringforEditing = "2019/12"
        
        super.init(coder: coder)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    //function that returns the number of sections
    //this case, number of date entries in month
    func numberOfSections(in tableView: UITableView) -> Int {

        return currentMonthPlans.count
    }
    
    
    //function that returns the number of rows in certain section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //generate key array and sort
        sortedDatesofMonth = Array(currentMonthPlans.keys).sorted(by : <)
        
        //if(currentMonthPlans[ sortedDatesofMonth[section] ]!.count == 0 ){
        //    return 0
        //}else {
            return currentMonthPlans[ sortedDatesofMonth[section] ]!.count + 1
            
        //}
    }
    
    //function that generates cell in a certain indexpath
    //and applies changes within the cells
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row) == 0{ // this cell will be used for showing the section(date)
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateHeader", for: indexPath)
            
            //use guard to be precise
            let header = cell.viewWithTag(10) as? UILabel
            header?.text = sortedDatesofMonth[indexPath.section]
            
            print("generate header cell")
            
            return cell
            
        } else { //these cells will be used for showing the actual PlanItems
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanItem", for: indexPath)
            
            let item = currentMonthPlans[ sortedDatesofMonth[indexPath.section] ]![indexPath.row - 1 ] //is a Plan object
            
            print("generate plan cell")
            
            //tag 1 : time(label)
            if let timeLabel = cell.viewWithTag(1) as? UILabel{
                timeLabel.text = item.time
            }
            
            //tag 2 : whoCategory sticker(image)
            if let colorSticker = cell.viewWithTag(2) as? UIImageView{
                
                // TODO : Update color stickers according to whoCat
                //sticker.image = [UIImage imageNamed: @ ""]
                
            }
            
            //tag 3 : specifics(label)
            if let specLabel = cell.viewWithTag(3) as? UILabel{
                if(item.withWho != [""]){
                    specLabel.text = item.withWhoString
                    
                }else{
                    
                    //when there is no entry for withWho, apply whoCategory
                    specLabel.text = item.whoCategory.rawValue
                }
                
                
            }
            
            //tag 4 : character sticker(image)
            if let characterSticker = cell.viewWithTag(4) as? UIImageView{
                
                // TODO : Update character stickers according to whoCat
                
                let imageName = (item.whatCategory?.value ?? "") + item.whoCategory.value
                //self.monthIcon.setImage(monthImage, for: .normal)
                characterSticker.image = UIImage(named: "\(imageName).png")!
                //characterSticker.image = [UIImage imageNamed: @ ""]
            }
            
            return cell
        }
        
        
    }
    
    
    //function that enters to edit mode when selected
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
            
        if(indexPath.row != 0){//not header
            tableView.reloadData()
            
            //data to be sent
            indexPathforEditing = indexPath
            
            planforEditing = currentMonthPlans[ sortedDatesofMonth[indexPath.section] ]![indexPath.row - 1 ]
            
            monthStringforEditing = currentMonthString
            
            
            //ALT : using target plan
            //PlanList.shared.targetPlan = PlanList.shared.completePlanList[currentMonthString]![ sortedDatesofMonth[indexPath.section] ]![indexPath.row - 1]
            
            
            //perform Segue
            performSegue(withIdentifier: "EnterEditing" , sender: self)
            
            
            //inter-VC data transfer will be ran in prepare segue
            
        }
        
        //ends the function by deselecting the row selected by this function
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //function that does the actual data transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! SelectionViewController
        print("transfer!")
        editVC.editDelegate = self
        editVC.selectedPlan = planforEditing
        editVC.selectedIndexPath = indexPathforEditing
        editVC.selectedYearMonth = monthStringforEditing
    }
    
    
    
    
    
    //function that removes a cell from the table and the list (the swipe-delete)
    //will this be needed? not for now
//    func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//
//        //remove from the todos list
//        //planList.planList.remove(at: indexPath.row)
//
//        //tableView.reloadData()
//
//        //remove from the table, by referencein the indexPath
//        let indexPaths = [indexPath]
//        tableView.deleteRows(at: indexPaths, with: .automatic)
//    }
    
    



    
}


extension ViewController : editPlanDelegate{
    
    func editPlan(plan: Plan, indexPath : IndexPath, yearMonthKey : String) {
        self.dismiss(animated: true) {
            
            
            //IMPORTANT : the data should be stored in original myPlanList, not temporary currentMonthPlans
            //self.currentMonthPlans[ self.sortedDatesofMonth[indexPath.section] ]![indexPath.row - 1 ]  = plan
            
            //Assumption : we are only able to edit the plans that are on current month
            // --> sounds legit
            //PlanList.shared.completePlanList[self.currentMonthString]?[ self.sortedDatesofMonth[indexPath.section] ]?[indexPath.row - 1 ] = plan
            
            //try manually add new and delete old
            
            PlanList.shared.editPlan(originalIndexPath: indexPath,
                                     yearMonthKey: yearMonthKey,
                                     date: plan.date,
                                     time: plan.time,
                                     whoCategory: plan.whoCategory,
                                     withWhoString: plan.withWhoString,
                                     whatCategory: plan.whatCategory,
                                     doWhat: plan.doWhat,
                                     place: plan.place)
            self.applyMonthChange()
            self.tableView.deleteRows(at: [indexPath], with: .none)
            print("deleting done?")
            
            //self.tableView.deleteRows(at: [indexPath], with: .none)
            
            
            
            //how to update the data
            //self.tableView.reloadData()
            
        }
    }
}
