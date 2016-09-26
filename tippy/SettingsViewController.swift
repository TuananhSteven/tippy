//
//  SettingsViewController.swift
//  tippy
//
//  Created by Tuan Anh Ngo on 9/22/16.
//  Copyright © 2016 ThomSoftware. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var lblDarkTheme: UILabel!
    @IBOutlet weak var btnChangePercent: UIButton!
    @IBOutlet weak var swChangeTheme: UISwitch!
    @IBOutlet weak var pkvTipPercent: UIPickerView!
    @IBOutlet weak var vwTipPercent: UIView!
    
    var percentageList:[Int] = []
    var temp = [0, 0, 0]
    
    var session = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        vwTipPercent.alpha = 0
        // Do any additional setup after loading the view.
        let theme = session.string(forKey: "Theme")
        if theme == "Light" {
            swChangeTheme.setOn(false, animated: false)
        }
        setTheme()
        pkvTipPercent.dataSource = self
        pkvTipPercent.delegate = self
        for i in 1...100 {
            percentageList.append(i)
        }
        session.set(true, forKey: "Back")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swChangeTheme(_ sender: AnyObject) {
        view.layer.sublayers?.remove(at: 0)
        if swChangeTheme.isOn{
            session.set("Dark", forKey: "Theme")
            setTheme()
        }else {
            session.set("Light", forKey: "Theme")
            setTheme()
        }
        
    }
    
    func setTheme(){
        let theme = session.string(forKey: "Theme")
        lblDarkTheme.textColor = UIColor.white
        btnChangePercent.setTitleColor(UIColor.white, for: .normal)
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
            
            swChangeTheme.onTintColor = UIColor.yellow
        }
    }
    
    @IBAction func btnChangeTipPercent(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.vwTipPercent.alpha = 1
            }, completion: nil)
    }
    
    @IBAction func btnCancelTipPercent(_ sender: AnyObject) {
        hideViewChangeTipPercent()
    }
    
    @IBAction func btnFinishChangeTipPercent(_ sender: AnyObject) {
        hideViewChangeTipPercent()
        session.set(temp[0], forKey: "percent0")
        session.set(temp[1], forKey: "percent1")
        session.set(temp[2], forKey: "percent2")

    }
    
    func hideViewChangeTipPercent(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.vwTipPercent.alpha = 0
            }, completion: nil)
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

extension SettingsViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return percentageList.count
    }
}

extension SettingsViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(percentageList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        temp[0] = percentageList[pickerView.selectedRow(inComponent: 0)]
        temp[1] = percentageList[pickerView.selectedRow(inComponent: 1)]
        temp[2] = percentageList[pickerView.selectedRow(inComponent: 2)]
    }
}
