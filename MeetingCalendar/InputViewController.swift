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
    
    
    
    
    //for Plans
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureDelegates()
        configureTapGesture()
        

        // Do any additional setup after loading the view.
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
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(SelectionViewController.tapAction))
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
    
    
    
}
