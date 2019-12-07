//
//  ViewController.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 13/11/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    //full plan list
    var myPlanList : PlanList
    
    //for current month
    var currentMonthString : String //key for the completeDict
    var currentMonthPlans : [ String:[Plan] ] //]dictionary of entries with key string and plan array as value
    //needs to be refreshed in every monthchange action, ordered too
    
    //sorted array of dictionary keys, that will be used as sections
    var sortedDatesofMonth : [String]
    
    
    var indexPathforEditing : IndexPath
    var planforEditing : Plan
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //print(currentMonthPlans["2019/12"]![0].date)
        print("initialize in viewcontroller")
        
    }
    
    required init?(coder: NSCoder) {
        
        //is required if initializing is needed
        myPlanList = PlanList()
        
        sortedDatesofMonth = [""]
        
        //test initialization of celldata
        
        
        //test initialization of listofPlanLists
        
        currentMonthString = "2019/12"
        
        currentMonthPlans = [ "":[] ]
        for (key, value) in myPlanList.completePlanList[currentMonthString]!{
            currentMonthPlans[key] = value
            
        }
        currentMonthPlans.removeValue(forKey: "")
        
        indexPathforEditing = IndexPath(row: 1, section: 1)
        
        planforEditing = Plan(date: "2019/12", time: "", whoCategory: WhoCategory.Other, withWho: [""], whatCategory: WhatCategory.Undefined, doWhat: "", place: "")
        
        super.init(coder: coder)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    //function that returns the number of sections
    //this case, number of date entries in month
    func numberOfSections(in tableView: UITableView) -> Int {

        print("generate no of sections \(currentMonthPlans.count) ")
        
        return currentMonthPlans.count
    }
    
    
    //function that returns the number of rows in certain section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //generate key array and sort
        sortedDatesofMonth = Array(currentMonthPlans.keys).sorted(by : <)
        
        print("generate no of rows \(currentMonthPlans[ sortedDatesofMonth[section] ]!.count) ")
        
        return currentMonthPlans[ sortedDatesofMonth[section] ]!.count + 1
    }
    
    
    //function that generates cell in a certain indexpath
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row) == 0{ // this cell will be used for showing the section(date)
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateHeader", for: indexPath)
            //let header = sortedDatesofMonth[indexPath.section]
            
            //use guard to be precise
            let header = cell.viewWithTag(10) as? UILabel
            header?.text = sortedDatesofMonth[indexPath.section]
            //cell.textLabel?.text = header
            //sticker selection is further behind priority
            
            print("generate header cell \(String(describing: header))")
            
            return cell
            
        }else{ //these cells will be used for showing the actual PlanItems
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanItem", for: indexPath)
            //let item = listofPlanLists[indexPath.row].planList[indexPath.row]
            let item = currentMonthPlans[ sortedDatesofMonth[indexPath.section] ]![indexPath.row - 1 ] //is a Plan object
            
            //following process will be unnecessary
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//
//            let dateValue = dateFormatter.string(from: item.date)
//            cell.textLabel?.text = dateValue
            
            //cell.textLabel?.text = tableViewData[indexPath.section].plans[indexPath.row]
            
            print("generate plan cell")
            
            //tag 1 : time(label)
            if let timeLabel = cell.viewWithTag(1) as? UILabel{
                timeLabel.text = item.time
            }
            
            
            
            //tag 2 : whoCategory sticker(image)
            if let whoSticker = cell.viewWithTag(2) as? UIImageView{
                
                
            }
            
            //tag 3 : specifics(label)
            if let specLabel = cell.viewWithTag(3) as? UILabel{
                if(item.withWho != [""]){
//                    var str = ""
//
//                    //re-generate withWhoString
//                    for e in (item.withWho)!{
//                        if(str == ""){
//                            str = e
//                        }else{
//                            str += ( ", " + e )
//                        }
//                    }
//
//                    specLabel.text = str
                    specLabel.text = item.withWhoString
                    
                }else{
                    
                    //when there is no entry for withWho, apply whoCategory
                    specLabel.text = "\(item.whoCategory)"
                }
                
                
            }
            
            //tag 4 : comprehensive sticker(image)
            if let compSticker = cell.viewWithTag(4) as? UIImageView{
                //sticker.image = [UIImage imageNamed: @ ""]
            }
            
            //do other stuff such as visualization for PlanItem cells
            
            return cell
        }
        
        
    }
    
    
    //function that enters to edit mode when selected
    //more sophisticated codes will come
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        //if let cell = tableView.cellForRow(at: indexPath) {
            
            
            if(indexPath.row != 0){//not header
                
                //data to be sent
                indexPathforEditing = indexPath
                
                planforEditing = currentMonthPlans[ sortedDatesofMonth[indexPath.section] ]![indexPath.row - 1 ]
                
                //perform Segue
                performSegue(withIdentifier: "EnterEditing" , sender: self)
                
                //inter-VC data transfer will be ran in prepare segue
                
            }
            
            //ends the function by deselecting the row selected by this function
            tableView.deselectRow(at: indexPath, animated: true)
            
        //}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! SelectionViewController
        print("transfer!")
        editVC.selectedPlan = planforEditing
        editVC.selectedIndexPath = indexPathforEditing
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
    
    
//    func configureColor(for cell: UITableViewCell, with item: Plan) {
//        //cell.accessoryType = item.checked ? .checkmark : .none
//        if let categoryIndicator = cell.viewWithTag(1) as? UIView{
//            switch (item.category){
//            case Category.Friend:
//                categoryIndicator.backgroundColor = UIColor.red
//
//            default:
//                categoryIndicator.backgroundColor = UIColor.black
//            }
//        }
//    }
//
//    //function that changes the cell's text to match the text in the item
//    func configureText(for cell: UITableViewCell, with item: Plan) {
//
//        //check for the view in the cell with the tag1000, which is the label in the cell
//        // also check wheather it is a UIlabel by as?
//        if let label = cell.viewWithTag(2) as? UILabel {
//            //label.text = item.meetingWith
//        }
//    }



    //function of adding an item into the row of the table, action sent by add button(the sender)
        @IBAction func addNewPlaninTable(_ sender: Any) {
            
            //get count of the todolist = the new index
//            let newRowIndex = to doList.todos.count
            
            //newTodo() returns the item - but the returned item will not be used anyway
            //so _ is used and just the initializing is done
            //newTodo() has embedded process of automatically adding the new item into the todo list
//            _ = todoList.newTodo()
    //        tableView.reloadData()
            
            
            //not sure of what the "section" here is,
            //but anyway, IndexPath generates a direct(?) path that leads to the newRowIndex generated
//            let indexPath = IndexPath(row: newRowIndex, section: 0)
//            let indexPaths = [indexPath]
            
            //actual row is added to the tableview (+ with animation)
            //my guess is that now the row in the tableview holds the indexpath data of that cell
            //meaning that each rows in the tableview has its own indexpaths
            //which then can be referenced when the cell is selected on the screen(storyboard)
//            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    
}
