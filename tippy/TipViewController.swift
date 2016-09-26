//
//  ViewController.swift
//  tippy
//
//  Created by Tuan Anh Ngo on 9/19/16.
//  Copyright © 2016 ThomSoftware. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var txtBill: UITextField!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var scTipPercent: UISegmentedControl!
    let session = UserDefaults.standard
    var tipPercentages = [0.18, 0.2, 0.25]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtBill.becomeFirstResponder()
        
        setTheme()
        
        var percent = session.integer(forKey: "percent0")
        if percent > 0{
            scTipPercent.setTitle("\(percent)%", forSegmentAt: 0)
            tipPercentages[0] = Double(percent)/100.0
        }
        
        percent = session.integer(forKey: "percent1")
        if percent > 0{
            scTipPercent.setTitle("\(percent)%", forSegmentAt: 1)
            tipPercentages[1] = Double(percent)/100.0
        }
        
        percent = session.integer(forKey: "percent2")
        if percent > 0{
            scTipPercent.setTitle("\(percent)%", forSegmentAt: 2)
            tipPercentages[2] = Double(percent)/100.0
        }

        session.set(false, forKey: "Back")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let lastDate:NSDate = session.object(forKey: "lastDate") as! NSDate?{
            if -lastDate.timeIntervalSinceNow < 600{
                if let bill = session.object(forKey: "billAmount"){
                    txtBill.text = String(describing: bill)
                    calculateTip()
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func txtBillEdittingChanged(_ sender: AnyObject) {
        calculateTip()
    }
    @IBAction func scValueChanged(_ sender: AnyObject) {
        calculateTip()
    }
    
    func calculateTip(){
        let bill = Double(txtBill.text!) ?? 0
        let tip =  bill*tipPercentages[scTipPercent.selectedSegmentIndex]
        let total = tip + bill
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = NSLocale.current
        
        lblTip.text = currencyFormatter.string(from: tip as NSNumber)
        lblTotal.text = currencyFormatter.string(from: total as NSNumber)
        
        session.set(bill, forKey: "billAmount")
        session.set(NSDate(), forKey: "lastDate")
    }
    
    func setTheme(){
        if session.bool(forKey: "Back") == true{
            view.layer.sublayers?.remove(at: 0)
        }
        let theme = session.string(forKey: "Theme")
        print("theme: \(theme)")
        if theme == "Light" {
            let layer = CAGradientLayer()
            layer.frame = view.bounds
            layer.colors = [UIColor(red: 80/255, green: 195/255, blue: 1, alpha: 1).cgColor, UIColor(red: 190/255, green: 240/255, blue: 1, alpha: 1).cgColor]
            view.layer.insertSublayer(layer, at: 0)
        }else {
            let layer = CAGradientLayer()
            layer.frame = view.bounds
            layer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
            view.layer.insertSublayer(layer, at: 0)
        }
    }
}

