//
//  TCCustomTipTableViewController.swift
//  TipCalculator
//
//  Created by Gauri Tikekar on 3/6/17.
//  Copyright © 2017 Gauri Tikekar. All rights reserved.
//

import UIKit

protocol TCCustomTipDelegate: class {
    func setTotalAmount(_ percentage: Int, tipInAmount: Double)
}

class TCCustomTipTableViewController: UITableViewController {

    @IBOutlet weak var tipTextField: UITextField!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    @IBOutlet weak var noTipButton: UIButton!
    
    @IBOutlet weak var appliedTipLabel: UILabel!
    
    @IBOutlet weak var applyBarButton: UIBarButtonItem!
    
    var delegate: TCCustomTipDelegate?
    
    var amount: Double?
    var tipObject: Dictionary<String,Double>? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noTipButton.layer.borderWidth = 1.0;
        self.noTipButton.layer.borderColor = UIColor.lightGray.cgColor;
        
        self.tipTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let tap = UITapGestureRecognizer(target: self, action: #selector(TCMainViewController.handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sliderValueLabel.text = String(Int(self.slider.value)) + "%"
        self.initializeTipValue()
    }
    
    func initializeTipValue() {
        if(self.tipObject != nil) {
            if(self.tipObject?["percentage"] != nil) {
                self.slider.value = Float((self.tipObject?["percentage"])!)
                self.sliderValueLabel.text = String(Int(self.slider.value)) + "%"
                self.appliedTipLabel.text = self.sliderValueLabel.text! + " tip will be applied"
                
            }
            else if(self.tipObject?["tipValue"] != nil) {
                self.tipTextField.text = String(Int((self.tipObject!["tipValue"])!))
                self.appliedTipLabel.text = "$" + self.tipTextField.text! + " tip will be applied"
                if(Int(self.tipObject!["tipValue"]!) == 0) {
                    self.noTipButton.setTitle("✔︎", for: UIControlState.normal)
                }
            }
        }
    }
    
    @IBAction func onSliderValueChange(_ sender: Any) {
        self.tipTextField.text = ""
        self.sliderValueLabel.text = String(Int(self.slider.value)) + "%"
        self.appliedTipLabel.text = self.sliderValueLabel.text! + " tip will be applied"
    }
    
    @IBAction func onApplyClick(_ sender: Any) {
        if(self.noTipButton.currentTitle != nil && !(self.noTipButton.currentTitle?.isEmpty)!) {
            self.delegate?.setTotalAmount(-1, tipInAmount: 0)
        }
        else if(self.tipTextField.text?.isEmpty)! {
            self.delegate?.setTotalAmount(Int(self.slider.value), tipInAmount: -1)
        }
        else {
            self.delegate?.setTotalAmount(-1, tipInAmount: Double(self.tipTextField.text!)!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // Handle no tip click
    @IBAction func onNoTipClick(_ sender: Any) {
        if(self.noTipButton.currentTitle == nil || (self.noTipButton.currentTitle?.isEmpty)!) {
            self.noTipButton.setTitle("✔︎", for: UIControlState.normal)
        }
        else {
            self.noTipButton.setTitle("", for: UIControlState.normal)
        }
    }
    
    // Tap the view to close the keyboard
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        self.tipTextField.resignFirstResponder();
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
         self.noTipButton.setTitle("", for: UIControlState.normal)
        if(self.tipTextField.text == nil || (self.tipTextField.text?.isEmpty)!) {
            self.appliedTipLabel.text = self.sliderValueLabel.text! + " tip will be applied"
            return;
        }
        self.appliedTipLabel.text = "$" + self.tipTextField.text! + " tip will be applied"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
