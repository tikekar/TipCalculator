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
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(TCMainViewController.handleTap))
        self.view.addGestureRecognizer(tap)
       
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
        self.addedAmountLabel.text = "+ Tip Added: $" + String(tip_)
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
    
    func handleViewSliding() {
        if(!self.isViewSlided) {
            self.isViewSlided = true;
            UIView.animate(withDuration: 0.3, animations: {
                self.outerView.frame = CGRect(x: self.outerView.frame.origin.x, y: self.outerView.frame.origin.y - 120 , width: self.outerView.frame.size.width, height: self.outerView.frame.size.height)
                self.innerView.isHidden = false;
            }, completion: { (Bool) in
            })
        }
        else if(self.amountTextField.text?.isEmpty)! {
            self.isViewSlided = false;
            UIView.animate(withDuration: 0.3, animations: {
                self.outerView.frame = CGRect(x: self.outerView.frame.origin.x, y: self.outerView.frame.origin.y + 120 , width: self.outerView.frame.size.width, height: self.outerView.frame.size.height)
                self.innerView.isHidden = true;
            }, completion: { (Bool) in
                
            })
        }
    }
    
    func handleTap() {
        self.amountTextField.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
