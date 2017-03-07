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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func onSliderValueChange(_ sender: Any) {
        self.applyBarButton.isEnabled = true;
        self.tipTextField.text = ""
        self.sliderValueLabel.text = String(Int(self.slider.value)) + "%"
        self.appliedTipLabel.text = self.sliderValueLabel.text! + " tip will be applied"
        self.appliedTipLabel.textColor = UIColor.black;
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
    
    @IBAction func onNoTipClick(_ sender: Any) {
        if(self.noTipButton.currentTitle == nil || (self.noTipButton.currentTitle?.isEmpty)!) {
            self.noTipButton.setTitle("✔︎", for: UIControlState.normal)
        }
        else {
            self.noTipButton.setTitle("", for: UIControlState.normal)
        }
    }
    
    func handleTap() {
        self.tipTextField.resignFirstResponder();
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        self.applyBarButton.isEnabled = true;
        if(self.tipTextField.text == nil || (self.tipTextField.text?.isEmpty)!) {
            self.appliedTipLabel.text = self.sliderValueLabel.text! + " tip will be applied"
            return;
        }
        if(Int(self.tipTextField.text!)! > Int(self.amount!)) {
            self.appliedTipLabel.text = "Tip is greater than $" + String(Double(self.amount!))
            self.appliedTipLabel.textColor = UIColor.red;
            self.applyBarButton.isEnabled = false;
        }
        else {
            self.appliedTipLabel.text = "$" + self.tipTextField.text! + " tip will be applied"
            self.appliedTipLabel.textColor = UIColor.black;
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
