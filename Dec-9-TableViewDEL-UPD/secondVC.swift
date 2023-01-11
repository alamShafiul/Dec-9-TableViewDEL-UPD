//
//  secondVC.swift
//  Dec-9-TableViewDEL-UPD
//
//  Created by Admin on 12/12/22.
//

import UIKit

class secondVC: UIViewController {

    var delegate: firstVC?
    
    @IBOutlet weak var updateTask: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        if let _ = updateTask.text {
            delegate?.updateTask(value: updateTask.text!)
        }
        self.dismiss(animated: true)
    }
}
