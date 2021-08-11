//
//  NewItemControllerViewController.swift
//  todos
//
//  Created by Wang Pin <guyusay@gmail.com> on 2021/8/9.
//

import UIKit
import os.log

class NewItemViewController: UIViewController, UINavigationControllerDelegate {
    
    var content: String?
    
    
    @IBOutlet weak var SaveBtn: UIBarButtonItem!
    
    @IBAction func editingChanged(_ sender: UITextField) {
        content = sender.text
        os_log("Changed: %s", log: OSLog.default, type: .debug, content!)
    }
    @IBAction func editingDidEnd(_ sender: UITextField) {
        content = sender.text
        os_log("Ended: %s", log: OSLog.default, type: .debug, content!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === SaveBtn else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        os_log("Save Btn Pressed", log: OSLog.default, type:.debug)
    }
    

}
