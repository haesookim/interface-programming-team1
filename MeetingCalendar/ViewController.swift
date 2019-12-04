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
    var currentMonthString : String
    var currentMonthPlans : [[String:[Plan]]] //needs to be refreshed in every monthchange action, ordered too
    
    //sorted array of dictionary keys, that will be used as sections
    var sortedDatesofMonth : [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    required init?(coder: NSCoder) {
        
        //is required if initializing is needed
        //planList = PlanList()
        
        //test initialization of celldata
        
        
        //test initialization of listofPlanLists
        
        currentMonthString = "2019/12"
        
        currentMonthPlans = [[:]]
        for (key, value) in myPlanList.completePlanList[currentMonthString]!{
            currentMonthPlans.append([key : value])
            
        }
        
        super.init(coder: coder)
    }

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


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    //function that returns the number of sections,
    //which actually affects the indexpath of the followed functions so be aware
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentMonthPlans.count
    }
    
    
    //function that returns the number of rows in certain section
    //referencing the tableviewdata for number of plans
    //func tableView(_ tableView: UITableView,
    //               numberOfRowsInSection section: Int) -> Int {
        //return tableViewData[section].plans.count + 1 //compensating for the header cell
        //return listofPlanLists[section].planList.count + 1
    //}
    
    //wonder if this works
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMonthPlans[section].values.count + 1
        //return myPlanList.completePlanList.index(after: section).count
    }
    
    
    //function that generates cell in a certain indexpath
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row) == 0{ // this cell will be used for showing the section(date)
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateHeader", for: indexPath)
            let header = currentMonthPlans[indexPath.section]
            
            //use guard to be precise
            //cell.textLabel?.text = tableViewData[indexPath.section].dates
            cell.textLabel?.text = header.keys.description
            
            //do other stuff such as visualization for DateHeader cells
            
            return cell
            
        }else{ //these cells will be used for showing the actual PlanItems
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanItem", for: indexPath)
            //let item = listofPlanLists[indexPath.row].planList[indexPath.row]
            let item = currentMonthPlans[indexPath.section].values[indexPath.row]
            
            let temp = item[indexPath.row]
            
            //cell.textLabel?.text = tableViewData[indexPath.section].plans[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateValue = dateFormatter.string(from: item.date)
            cell.textLabel?.text = dateValue
            
            //do other stuff such as visualization for PlanItem cells
            
            return cell
        }
        
        
    }
    
    
    //function that enters to edit mode when selected
    //more sophisticated codes will come
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            //from matching item...
            //let item = planList.planList[indexPath.row]
            
            
            
            //ends the function by deselecting the row selected by this function
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    //function that removes a cell from the table and the list (the swipe-delete)
    //will this be needed?
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        //remove from the todos list
        //planList.planList.remove(at: indexPath.row)
        
        //tableView.reloadData()
        
        //remove from the table, by referencein the indexPath
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    
    func configureColor(for cell: UITableViewCell, with item: Plan) {
        //cell.accessoryType = item.checked ? .checkmark : .none
        if let categoryIndicator = cell.viewWithTag(1) as? UIView{
            switch (item.category){
            case Category.Friend:
                categoryIndicator.backgroundColor = UIColor.red
                
            default:
                categoryIndicator.backgroundColor = UIColor.black
            }
        }
    }
    
    //function that changes the cell's text to match the text in the item
    func configureText(for cell: UITableViewCell, with item: Plan) {
        
        //check for the view in the cell with the tag1000, which is the label in the cell
        // also check wheather it is a UIlabel by as?
        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = item.meetingWith
        }
    }
}
