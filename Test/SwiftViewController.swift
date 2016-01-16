//
//  SwiftViewController.swift
//  Test
//
//  Created by Sergey Kolupaev on 1/5/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var picker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func click(sender: AnyObject) {
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
 
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
