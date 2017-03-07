//
//  TCMainViewController.swift
//  TipCalculator
//
//  Created by Gauri Tikekar on 3/6/17.
//  Copyright © 2017 Gauri Tikekar. All rights reserved.
//

import UIKit

class TCMainViewController: UIViewController, TCCustomTipDelegate {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addedAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var isViewSlided:Bool! = false
    var tipObject: Dictionary<String,Double>? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tipObject = Dictionary.init()
        self.amountTextField.becomeFirstResponder()
        self.innerView.layer.opacity = 0.0;
        self.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(TCMainViewController.handleTap))
        self.view.addGestureRecognizer(tap)
        self.setDefaultTip()
       
    }
    
    func setDefaultTip() {
        let defaults = UserDefaults.standard
        let indexString_:String? = defaults.object(forKey: "default_tip_percentage_index") as! String?
        if(indexString_ != nil) {
            self.segmentedControl.selectedSegmentIndex = Int(indexString_!)!;
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        handleViewSliding();
        self.setTipDictionary()
        self.calculateTotalAmount()
        
    }
    
    func calculateTotalAmount() {
        if(self.amountTextField.text?.isEmpty)! {
            self.addedAmountLabel.text = "";
            self.totalAmountLabel.text = "";
            return;
        }
        let amount_ = Double(self.amountTextField.text!)
        
        if(self.tipObject?["percentage"] != nil) {
            let percentage_ = Double((self.tipObject?["percentage"])!)
        
            let tip_ = (amount_! * percentage_)/100
            self.addedAmountLabel.text = String(Int(percentage_)) + "% Tip Added: $" + String(tip_)
            self.totalAmountLabel.text = "Total: $" + String(amount_! + tip_)
        }
        else {
            let tip_:Double = (self.tipObject?["tipValue"])!;
            self.addedAmountLabel.text = "Tip added: $" + String(tip_)
            self.totalAmountLabel.text = "Total: $" + String(amount_! + tip_)
        }

    }
    
    func setTipDictionary() {
        let percentage_ = self.getPercentageFromSegmentControl()
        if(percentage_ == -1) {
            return;
        }
        self.tipObject?["percentage"] = Double(percentage_);
        self.tipObject?["tipValue"] = nil;
    }
    
    func getPercentageFromSegmentControl() -> Double {
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
            self.innerView.isHidden = false;
            UIView.animate(withDuration: 0.3, animations: {
                self.innerView.layer.opacity = 1.0;
            }, completion: { (Bool) in
            })
        }
        else if(self.amountTextField.text?.isEmpty)! {
            self.isViewSlided = false;
            self.innerView.isHidden = true;
            UIView.animate(withDuration: 0.3, animations: {
                self.innerView.layer.opacity = 0.0;
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
    
    @IBAction func onSegmentControlChange(_ sender: Any) {
        if(self.segmentedControl.selectedSegmentIndex == 3) {
            self.performSegue(withIdentifier: "Show Custom View", sender: nil)
        }
        else {
            self.setTipDictionary()
            self.calculateTotalAmount()
        }
    }
    
    func setTotalAmount(_ percentage: Int, tipInAmount: Double) {
        if(self.amountTextField.text?.isEmpty)! {
            self.addedAmountLabel.text = "";
            self.totalAmountLabel.text = "";
            return;
        }
        
        if(percentage == -1 && tipInAmount == -1) {
            return;
        }
        else if(percentage != -1) {
            self.tipObject?["percentage"] = Double(percentage);
            self.tipObject?["tipValue"] = nil;
        }
        else {
            self.tipObject?["tipValue"] = Double(tipInAmount);
            self.tipObject?["percentage"] = nil;
            
        }
        self.calculateTotalAmount()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TCCustomTipTableViewController {
            viewController.delegate = self
            viewController.amount = Double(self.amountTextField.text!)
        }
    }

}


