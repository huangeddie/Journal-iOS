//
//  FirstResponder.swift
//  Journal
//
//  Created by Edward Huang on 1/15/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func addDoneButtonAccessory() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(objcResignFirstResponder))
        
        
        toolBar.setItems([flexibleSpace, doneItem], animated: true)
        
        inputAccessoryView = toolBar
    }
    
    func addCancelButtonAccessory() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(objcResignFirstResponder))
        
        
        toolBar.setItems([flexibleSpace, doneItem], animated: true)
        
        inputAccessoryView = toolBar
    }
    
    @objc
    private func objcResignFirstResponder() {
        resignFirstResponder()
    }
}

extension UISearchBar {
    
    func addCancelButtonAccessory() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(objcResignFirstResponder))
        
        
        toolBar.setItems([flexibleSpace, doneItem], animated: true)
        
        inputAccessoryView = toolBar
    }
    
    @objc
    private func objcResignFirstResponder() {
        resignFirstResponder()
    }
}
