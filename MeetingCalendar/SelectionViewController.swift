//
//  SelectionViewController.swift
//  MeetingCalendar
//
//  Created by KimHaesoo on 03/12/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import UIKit


protocol editPlanDelegate{
    func editPlan(plan : Plan, indexPath : IndexPath)
}


class SelectionViewController: UIViewController, UITextFieldDelegate {

    var selectedPlan : Plan
    var selectedIndexPath : IndexPath
    
    var editDelegate : editPlanDelegate?
    
    //OUTLETS : labels
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    
    //OUTLETS : buttons
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var whoButton: UIButton!
    
    @IBOutlet weak var whatButton: UIButton!
    
    
    //OUTLETS : TextFields
    
    @IBOutlet weak var whoTF: UITextField!
    
    @IBOutlet weak var whatTF: UITextField!
    
    @IBOutlet weak var placeTF: UITextField!
    
    
    
    required init?(coder: NSCoder) {
        
        selectedPlan = Plan(date: "2019/12", time: "", whoCategory: WhoCategory.Other, withWho: [""], whatCategory: WhatCategory.Undefined, doWhat: "", place: "")
        
        selectedIndexPath = IndexPath(row: 1, section: 1)
        
        super.init(coder: coder)
//        selectedIndexPath =
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //setup delgates for tf
        whoTF.delegate = self
        whatTF.delegate = self
        placeTF.delegate = self
        
        //tapguestures
        configureTapGesture()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //all defaults of labels, buttons and textfields
        
        yearLabel.text = selectedPlan.date
        monthLabel.text = selectedPlan.date
        dayLabel.text = selectedPlan.date
        
        timeButton.setTitle( selectedPlan.time, for: .normal)
        whoButton.setTitle( selectedPlan.whoCategory.rawValue, for: .normal)
        whatButton.setTitle( selectedPlan.whatCategory?.rawValue, for: .normal)
        
        if !(selectedPlan.withWho?.isEmpty ?? true){
            whoTF.text = selectedPlan.withWhoString
        }
        if !(selectedPlan.doWhat?.isEmpty ?? true){
            whatTF.text = selectedPlan.doWhat
        }
        if !(selectedPlan.place?.isEmpty ?? true){
            placeTF.text = selectedPlan.place
        }
        
        
    }
    
    
    
    @IBAction func cancelEditing(_ sender : Any){
        
        view.endEditing(true)
        
        //perform segue
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmEditing(_ sender : Any){
        
        view.endEditing(true)
        
        //apply all the changes
        applyChanges()
        
        //use the protocol delegate
        editDelegate?.editPlan(plan : selectedPlan, indexPath: selectedIndexPath)
        
        
        //perform segue - done in delegate
        //dismiss(animated: true, completion: nil)
    }
    
    
    func applyChanges(){
        
        //apply changes made in input to the selectedPlan
        
        //do stuffs related to date and time
        //selectedPlan.date =
        //selectedPlan.time =
        
        //the categories will definitely use the rawValues as representations
        selectedPlan.whatCategory = WhatCategory(rawValue: whatButton.title(for: .normal)!)
        selectedPlan.whoCategory = WhoCategory(rawValue: whoButton.title(for: .normal)!)!
        
        
        selectedPlan.withWhoStringToArray(whoTF.text!)
        selectedPlan.doWhat = whatTF.text
        selectedPlan.place = placeTF.text
        
        
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let listVC = segue.destination as! ViewController
        listVC.currentMonthPlans[ listVC.sortedDatesofMonth[selectedIndexPath.section] ]![selectedIndexPath.row] = selectedPlan
    }
    */
    
    //action : close VC and sent data back
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - TextField Related
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureTapGesture(){
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(SelectionViewController.tapAction))
        view.addGestureRecognizer(tapGuesture)
    }
    
    
    @objc func tapAction(){
        view.endEditing(true)
    }
    
    
    
    

}
