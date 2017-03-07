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
    @IBOutlet weak var customOverlayButton: UIButton!
    
    var isInnerViewVisible:Bool! = false
    var tipObject: Dictionary<String,Double>? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tipObject = Dictionary.init()
        self.amountTextField.becomeFirstResponder()
        self.innerView.layer.opacity = 0.0;
        self.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.customOverlayButton.isHidden = true
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(tap)
        self.setFromUserState()
    }
    
    // Set the last user state with last entered amount and tip settings in UserDefaults
    func setUserState() {
        var userState_:Dictionary<String, AnyObject>? = Dictionary.init()
        if(self.amountTextField.text != nil){userState_?["amount"] = self.amountTextField.text as AnyObject?}
        if(self.tipObject?["tipValue"] != nil){
            userState_?["tipValue"] = self.tipObject?["tipValue"] as AnyObject?
            userState_?["percentage"] = nil;
        }
        else if(self.tipObject?["percentage"] != nil){
            userState_?["percentage"] = self.tipObject?["percentage"] as AnyObject?
            userState_?["tipValue"] = nil;
        }
        userState_?["date"] = Date() as AnyObject?
        let defaults = UserDefaults.standard
        defaults.set(userState_, forKey: "user_state")
        defaults.synchronize()
    }
    
    // Set Tip and amount from last saved user state
    func setFromUserState() {
        let defaults = UserDefaults.standard
        let indexString_:String? = defaults.object(forKey: "default_tip_percentage_index") as! String?
        if(indexString_ != nil) {
            self.segmentedControl.selectedSegmentIndex = Int(indexString_!)!;
        }
        let userState_:Dictionary<String, AnyObject>? = defaults.object(forKey: "user_state") as! Dictionary?
        if(userState_ != nil) {
            let userStateDate_:Date? = userState_?["date"] as! Date?;
            if(userStateDate_ != nil) {
                let diff_:Int = self.minutesBetween(start: userStateDate_!, end: Date())
                if(diff_ >= 5) {
                    defaults.removeObject(forKey: "user_state")
                    defaults.synchronize()
                    return;
                }
            }
            if(userState_?["percentage"] != nil) {
                let perc_:Int? = userState_?["percentage"] as! Int?
                self.tipObject?["percentage"] = Double(perc_!)
                self.tipObject?["tipValue"] = nil;
                if(perc_ == 10) {
                    self.segmentedControl.selectedSegmentIndex = 0
                }
                else if(perc_ == 15) {
                    self.segmentedControl.selectedSegmentIndex = 1
                }
                else if(perc_ == 20) {
                    self.segmentedControl.selectedSegmentIndex = 2
                }
                else {
                    self.segmentedControl.selectedSegmentIndex = 3
                }
            }
            else if(userState_?["tipValue"] != nil) {
                let val_:Double = userState_?["tipValue"] as! Double
                self.tipObject?["tipValue"] = val_
                self.tipObject?["percentage"] = nil;
                self.segmentedControl.selectedSegmentIndex = 3
            }
            if(userState_?["amount"] != nil) {
                self.amountTextField.text = userState_?["amount"] as! String?
            }
            self.innerView.layer.opacity = 1.0
            self.calculateTotalAmount()
        }
    }
    
    func minutesBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: start, to: end).minute!
    }
    
    // When Amount TextField value changed
    func textFieldDidChange(_ textField: UITextField) {
        if(self.amountTextField.text?.isEmpty)! {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "user_state")
            defaults.synchronize()
        }
        showHideInnerView();
        self.setTipObjectDictionary()
        self.calculateTotalAmount()
    }
    
    func setTipObjectDictionary() {
        let percentage_ = self.getPercentageFromSegmentControl()
        if(percentage_ == -1) {
            return;
        }
        self.tipObject?["percentage"] = Double(percentage_);
        self.tipObject?["tipValue"] = nil;
    }
    
    // When amount, percentage or tip value changed, calculate the total amount
    func calculateTotalAmount() {
        if(self.amountTextField.text?.isEmpty)! {
            self.addedAmountLabel.text = "";
            self.totalAmountLabel.text = "";
            return;
        }
        let amount_ = Double(self.amountTextField.text!)
        if(amount_ == nil) {
            self.addedAmountLabel.text = "";
            self.totalAmountLabel.text = "";
            self.amountTextField.text = "";
            return;
        }
        var tip_:Double? = 0;
        
        if(self.tipObject?["percentage"] != nil) {
            let percentage_ = Double((self.tipObject?["percentage"])!)
        
            tip_ = (amount_! * percentage_)/100
            self.addedAmountLabel.text = String(Int(percentage_)) + "% Tip Added: $" + String(Double(tip_!))
            self.totalAmountLabel.text = "Total: $" + String(amount_! + Double(tip_!))
        }
        else {
            tip_ = (self.tipObject?["tipValue"])!;
            self.addedAmountLabel.text = "Tip added: $" + String(Double(tip_!))
            self.totalAmountLabel.text = "Total: $" + String(amount_! + Double(tip_!))
        }
        self.setUserState()

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
    
    // Show hide tip area for better UI effect
    func showHideInnerView() {
        if(!self.isInnerViewVisible) {
            self.isInnerViewVisible = true;
            self.innerView.isHidden = false;
            UIView.animate(withDuration: 0.3, animations: {
                self.innerView.layer.opacity = 1.0;
            }, completion: { (Bool) in
            })
        }
        else if(self.amountTextField.text?.isEmpty)! {
            self.isInnerViewVisible = false;
            self.innerView.isHidden = true;
            UIView.animate(withDuration: 0.3, animations: {
                self.innerView.layer.opacity = 0.0;
            }, completion: { (Bool) in
                
            })
        }
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        if(gestureRecognizer.view?.isKind(of: UISegmentedControl.self))! {
            return
        }
        self.amountTextField.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSegmentControlChange(_ sender: Any) {
        // 3 is custom
        if(self.segmentedControl.selectedSegmentIndex == 3) {
            self.customOverlayButton.isHidden = false
            self.performSegue(withIdentifier: "Show Custom View", sender: nil)
        }
        else {
            self.customOverlayButton.isHidden = true
            self.setTipObjectDictionary()
            self.calculateTotalAmount()
        }
    }
    
    // Set the Total amount and added Tip text fields
    // This is delegate method of TCCustomTipDelegate protocol
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
    
    // This button is just added to handle multiple clicks on custom to open custom view
    // When first time custom is selected, it works with segment Control. But clicking on it again does not work
    // So added this overlay button. TODO: Need a better fix
    @IBAction func onCustomOverlayClick(_ sender: Any) {
        self.performSegue(withIdentifier: "Show Custom View", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TCCustomTipTableViewController {
            viewController.delegate = self
            viewController.amount = Double(self.amountTextField.text!)
            viewController.tipObject = self.tipObject
        }
    }
        

}


