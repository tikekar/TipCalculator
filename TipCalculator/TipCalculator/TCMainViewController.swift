//
//  TCMainViewController.swift
//  TipCalculator
//
//  Created by Gauri Tikekar on 3/6/17.
//  Copyright © 2017 Gauri Tikekar. All rights reserved.
//

import UIKit

class TCMainViewController: UIViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addedAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    var isViewSlided:Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountTextField.becomeFirstResponder()
        self.innerView.isHidden = true
        self.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //self.amountTextField.addTarget(self, action: #selector(textFieldBeginEditing(_:)),, for: editing)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        handleViewSliding();
        calculateTotalAmount();
        
    }
    
    func calculateTotalAmount() {
        if(self.amountTextField.text?.isEmpty)! {
            self.addedAmountLabel.text = "";
            self.totalAmountLabel.text = "";
            return;
        }
        let amount_ = Double(self.amountTextField.text!)
        let percentage_ = self.getPercentage()
        let tip_ = (amount_! * percentage_)/100
        self.addedAmountLabel.text = "+ $" + String(tip_)
        self.totalAmountLabel.text = "Total: $" + String(amount_! + tip_)

    }
    
    func getPercentage() -> Double {
        if(self.segmentedControl.selectedSegmentIndex == 0) {
            return 10;
        }
        else if(self.segmentedControl.selectedSegmentIndex == 1) {
            return 15;
        }
        else if(self.segmentedControl.selectedSegmentIndex == 2) {
            return 20;
        }
        return -1;
    }
    
    @IBAction func onSegmentControlChange(_ sender: Any) {
        
    }
    
    func handleViewSliding() {
        if(!self.isViewSlided) {
            self.isViewSlided = true;
            UIView.animate(withDuration: 0.3, animations: {
                self.outerView.frame.origin.y = self.outerView.frame.origin.y - 120;
                self.innerView.isHidden = false;
            }, completion: { (Bool) in
            })
        }
        else if(self.amountTextField.text?.isEmpty)! {
            self.isViewSlided = false;
            UIView.animate(withDuration: 0.3, animations: {
                self.outerView.frame.origin.y = self.outerView.frame.origin.y + 120;
                self.innerView.isHidden = true;
            }, completion: { (Bool) in
                
            })
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