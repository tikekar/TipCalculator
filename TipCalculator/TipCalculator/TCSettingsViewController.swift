//
//  TCSettingsViewController.swift
//  TipCalculator
//
//  Created by Gauri Tikekar on 3/6/17.
//  Copyright © 2017 Gauri Tikekar. All rights reserved.
//

import UIKit

class TCSettingsViewController: UIViewController {
    
   
    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultTip()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Add the index in the user defaults.
    // TODO: Better to add the percent value.
    @IBAction func onSegmentControlChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(String(self.segmentControl.selectedSegmentIndex), forKey: "default_tip_percentage_index")
        defaults.synchronize()
        
    }
    
    // When view loaded, if default percentage index already exists, show it selected
    func setDefaultTip() {
        let defaults = UserDefaults.standard
        let indexString_:String? = defaults.object(forKey: "default_tip_percentage_index") as! String?
        if(indexString_ != nil) {
            self.segmentControl.selectedSegmentIndex = Int(indexString_!)!;
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
