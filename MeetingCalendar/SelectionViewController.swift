//
//  SelectionViewController.swift
//  MeetingCalendar
//
//  Created by KimHaesoo on 03/12/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import UIKit


protocol editPlanDelegate{
    func editPlan(plan : Plan, indexPath : IndexPath, yearMonthKey : String)
    func deletePlan(plan : Plan)
}


class SelectionViewController: UIViewController {

    var selectedPlan : Plan
    var selectedIndexPath : IndexPath
    var selectedYearMonth : String
    
    var editDelegate : editPlanDelegate?
    
    
    
    //IBoutlets and etc
    
    @IBOutlet weak var whoCatTF: UITextField!
    
    @IBOutlet weak var withWhoTF: UITextField!
    
    @IBOutlet weak var whatCatTF: UITextField!
    
    @IBOutlet weak var doWhatTF: UITextField!
    
    @IBOutlet weak var whereTF: UITextField!
    
    @IBOutlet weak var timePickerTF: UITextField!
    
    @IBOutlet weak var datePickerTFDummy: UITextField!
    
    @IBOutlet weak var yearTFDummy: UITextField!
    
    @IBOutlet weak var monthTFDummy: UITextField!
    
    @IBOutlet weak var dayTFDummy: UITextField!
    
    
    
    //for Pickers
    
    var datePicker : UIDatePicker?
    var timePicker : UIDatePicker?
    let clearToolbar = UIToolbar()
    
    var whoCatPicker : UIPickerView?
    var whatCatPicker : UIPickerView?
    
    var whoCatArray : [WhoCategory] = []
    var whatCatArray : [WhatCategory] = []
    
    var selectedWhoCat : WhoCategory = WhoCategory.Undefined
    var selectedWhatCat : WhatCategory?
    //var enteredDate : Date?
    var fullDateString : String = ""
    
    
    required init?(coder: NSCoder) {
        
        selectedPlan = Plan(planID: "100", date: "2019/12/25", time: "", whoCategory: WhoCategory.Other, withWho: "", whatCategory: WhatCategory.Undefined, doWhat: "", place: "")
        
        selectedIndexPath = IndexPath(row: 1, section: 1)
        
        selectedYearMonth = ""
        
        super.init(coder: coder)
//        selectedIndexPath =
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //setup delgates for tf
        configureDelegates()
        
        //tapguestures
        configureTapGesture()
        
        //setup date/time pickers
        
        
        //TODO: - block copypaste etc
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .date
        //mmddyy needs to be changed -_-
        datePicker!.locale = .autoupdatingCurrent //when actual release
        datePicker!.addTarget(self, action: #selector(InputViewController.datePickerInputChanged), for: .valueChanged)
        
        datePickerTFDummy.inputView = datePicker
        datePickerTFDummy.tintColor = UIColor.clear
        
        timePicker = UIDatePicker()
        clearToolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(clearTimeData))
        clearToolbar.setItems([cancelButton], animated: true)
        timePicker!.datePickerMode = .time
        timePicker!.minuteInterval = 5
        timePicker!.addTarget(self, action: #selector(InputViewController.timePickerInputChanged), for: .valueChanged) //currently set to valueChanged, but need better trigger
        
        timePickerTF.inputView = timePicker
        timePickerTF.inputAccessoryView = clearToolbar
        timePickerTF.tintColor = UIColor.clear
        
        
        //setup for category pickers
        
        for cat in WhoCategory.allCases{
            whoCatArray.append(cat)
        }
        
        for cat in WhatCategory.allCases{
            whatCatArray.append(cat)
        }
        
        createCategoryPicker()
        
        
        
    }
    
    
    // TODO : is viewDidAppear too slow in showing the data of selected plan?
    // if so, then find better way if possible
    override func viewDidAppear(_ animated: Bool) {
        
        //all defaults of labels, buttons and textfields
        
        yearTFDummy.text = selectedPlan.year + "년"
        monthTFDummy.text = selectedPlan.month + "월"
        dayTFDummy.text = selectedPlan.day + "일"
        
        timePickerTF.text = selectedPlan.time
        whoCatTF.text = selectedPlan.whoCategory.rawValue
        whatCatTF.text = selectedPlan.whatCategory?.rawValue
        
        withWhoTF.text = selectedPlan.withWho
        doWhatTF.text = selectedPlan.doWhat
        whereTF.text = selectedPlan.place
        
        //import implied data
        fullDateString = selectedPlan.date
        selectedWhoCat = selectedPlan.whoCategory
        selectedWhatCat = selectedPlan.whatCategory
        
        
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
        editDelegate?.editPlan(plan : selectedPlan, indexPath: selectedIndexPath, yearMonthKey: selectedYearMonth)
        
        
        //perform segue - done in delegate
        //dismiss(animated: true, completion: nil)
    }
    
    
    func applyChanges(){
        
        //apply changes made in input to the selectedPlan
        
        //those that are applied from textfield texts
        selectedPlan.withWho = withWhoTF.text
        selectedPlan.doWhat = doWhatTF.text
        selectedPlan.place = whereTF.text
        
        
        //from implied data
        selectedPlan.time = timePickerTF.text
        selectedPlan.date = fullDateString
        selectedPlan.whoCategory = selectedWhoCat
        selectedPlan.whatCategory = selectedWhatCat
        
        
        
    }
    
    
    //action : close VC and sent data back
    
    
    
    @IBAction func deletePlan(_ sender: Any) {
        print(selectedPlan.planID)
        //PlanList.shared.deletePlanFromCPRA(targetPlan: selectedPlan)
         editDelegate?.deletePlan(plan : selectedPlan)
        
        //perform segue
        //dismiss(animated: true, completion: nil)
        
    }

}



extension SelectionViewController : UITextFieldDelegate {
    
    
    //MARK: - TextField Related
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureTapGesture(){
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(InputViewController.tapAction))
        view.addGestureRecognizer(tapGuesture)
    }
    
    private func configureDelegates(){
        whoCatTF.delegate = self
        withWhoTF.delegate = self
        whatCatTF.delegate = self
        doWhatTF.delegate = self
        whereTF.delegate = self
        
    }
    
    
    @objc func tapAction(){
        
        view.endEditing(true)
    }
    
    @objc func clearTimeData(){
        timePickerTF.text = ""
        view.endEditing(true)
        
    }
    
    
    // MARK: - Time/Date Picker Related
    
    @objc func timePickerInputChanged(){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timePickerTF.text = timeFormatter.string(from: timePicker!.date)
        
    }
    
    @objc func datePickerInputChanged(){
        
        //enteredDate = datePicker!.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        fullDateString = dateFormatter.string(from: datePicker!.date)
        let dateString = fullDateString.components(separatedBy: "/")
        
        yearTFDummy.text = dateString[0] + "년"
        monthTFDummy.text = dateString[1] + "월"
        dayTFDummy.text = dateString[2] + "일"
        
    }
    
    func createCategoryPicker(){
        let whoCatPicker = UIPickerView()
        let whatCatPicker = UIPickerView()
        
        whoCatPicker.delegate = self
        whatCatPicker.delegate = self
        
        whoCatPicker.tag = 1
        whatCatPicker.tag = 2
        
        whoCatTF.inputView = whoCatPicker
        whatCatTF.inputView = whatCatPicker
        

        
    }
    
}


extension SelectionViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    // MARK: - Pickers Related
    
    //need to implement two pickers
    //use tags to distinguish the two
    
    // 1 for whoCat
    // 2 for whatCat
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){ //who
            
            return whoCatArray.count
        }else{//what
            
            return whatCatArray.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){ //who
            
            return whoCatArray[row].rawValue
        }else{//what
            
            return whatCatArray[row].rawValue
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){ //who
            
            selectedWhoCat = whoCatArray[row]
            whoCatTF.text = selectedWhoCat.rawValue
        }else{//what
            
            selectedWhatCat = whatCatArray[row]
            whatCatTF.text = selectedWhatCat?.rawValue
        }
    }
    
    
}
