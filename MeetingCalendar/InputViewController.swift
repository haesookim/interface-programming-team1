//
//  InputViewController.swift
//  MeetingCalendar
//
//  Created by KimHaesoo on 10/12/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    
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
    
    var whoCatPicker : UIPickerView?
    var whatCatPicker : UIPickerView?
    
    var whoCatArray : [WhoCategory] = []
    var whatCatArray : [WhatCategory] = []
    
    var selectedWhoCat : WhoCategory?
    var selectedWhatCat : WhatCategory?
    
    
    
    
    
    //for Plans
    var newPlan : Plan?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //apply delegates
        configureDelegates()
        configureTapGesture()
        
        
        //setup date/time pickers
        
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .date
        //mmddyy needs to be changed -_-
        datePicker!.locale = .autoupdatingCurrent //when actual release
        datePicker!.addTarget(self, action: #selector(InputViewController.datePickerInputChanged), for: .valueChanged)
        
        datePickerTFDummy.inputView = datePicker
        datePickerTFDummy.tintColor = UIColor.clear
        
        timePicker = UIDatePicker()
        timePicker!.datePickerMode = .time
        timePicker!.minuteInterval = 5
        timePicker!.addTarget(self, action: #selector(InputViewController.timePickerInputChanged), for: .valueChanged) //currently set to valueChanged, but need better trigger
        
        timePickerTF.inputView = timePicker
        timePickerTF.tintColor = UIColor.clear
        
        
        //setup for category pickers
        
        for cat in WhoCategory.allCases{
            whoCatArray.append(cat)
        }
        
        for cat in WhatCategory.allCases{
            whatCatArray.append(cat)
        }
        
        createCategoryPicker()
        

        // Do any additional setup after loading  the view.
    }
    
    
    
    //IB action
    
    @IBAction func ConfirmInput(_ sender: Any) {
        //apply the settings and pass it to the list view controller
        
        
    }
    

}



extension InputViewController : UITextFieldDelegate {
    
    
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
    
    
    @objc func timePickerInputChanged(){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timePickerTF.text = timeFormatter.string(from: timePicker!.date)
        
    }
    
    @objc func datePickerInputChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datePicker!.date).components(separatedBy: "-")
        
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


extension InputViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
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
            whoCatTF.text = selectedWhoCat?.rawValue
        }else{//what
            
            selectedWhatCat = whatCatArray[row]
            whatCatTF.text = selectedWhatCat?.rawValue
        }
    }
    
    
}

