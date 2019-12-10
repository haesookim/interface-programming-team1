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
    
    var datePicker : UIDatePicker?
    var timePicker : UIDatePicker?
    
    var whoCatPicker : UIPickerView?
    var whatCatPicker : UIPickerView?
    
    
    
    //for Plans
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureDelegates()
        configureTapGesture()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        
        timePicker = UIDatePicker()
        timePicker!.datePickerMode = .time
        timePicker!.minuteInterval = 5
        timePicker!.addTarget(self, action: #selector(InputViewController.timePickerInputChanged), for: .valueChanged) //currently set to valueChanged, but need better trigger
        timePickerTF.inputView = timePicker

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
        view.endEditing(true)
        
    }
    
    @objc func datePickerInputChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString = dateFormatter.string(from: datePicker!.date).components(separatedBy: "-")
        
        let yearString = dateString[0]
        let monthString = dateString[1]
        let dayString = dateString[2]
        
        
        
    }
    
    
    
    
}
