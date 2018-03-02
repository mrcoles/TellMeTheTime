//
//  TableViewController.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 3/1/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

import UIKit

protocol ChildToParentProtocol:class {
    var speaker: Speaker { get }
    var formatter: TimeFormat { get }
    var muted: Bool { get set }
    var currentTime: CurrentTime? { get set }
    var timeLabel: UILabel! { get }
    
    func updateClockLabel()
}

class TableViewController: UITableViewController, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    
    weak var delegate:ChildToParentProtocol? = nil
    
    @IBOutlet weak var voiceLabelWrapper: UIStackView!
    
    @IBOutlet weak var timeFormat12Label: UILabel!
    @IBOutlet weak var timeFormat24Label: UILabel!
    @IBOutlet weak var timeFormatSwitch: UISwitch!
    
    @IBOutlet weak var volumeOnLabel: UILabel!
    @IBOutlet weak var volumeOffLabel: UILabel!
    @IBOutlet weak var volumeSwitch: UISwitch!
    
    @IBOutlet weak var voicePicker: UIPickerView!

    var isVoicesExpanded = false
    
    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parent = self.delegate!
        
        // Setup voicePicker
        voicePicker.selectRow(parent.speaker.voiceRow, inComponent: 0, animated: false)
        
        // Update UI
        timeFormatSwitch.isOn = parent.formatter.use24
        volumeSwitch.isOn = parent.muted
        updateTimeFormatLabels()
        updateVolumeLabels()
        
        // Setup gesture recognizer for voice label
        voiceLabelWrapper.isUserInteractionEnabled = true
        let voiceTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapVoiceLabel(_:)))
        voiceLabelWrapper.addGestureRecognizer(voiceTap)
        voiceTap.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @objc func tapVoiceLabel(_ sender: UITapGestureRecognizer) {
        print("TAP VOICE LABEL!")
        
        //        let height = CGFloat(isVoicesExpanded ? 0.0 : 216.0)
        //        isVoicesExpanded = !isVoicesExpanded
        //
        //
        //        let newRect = CGRect(x: voicePicker.frame.origin.x, y: voicePicker.frame.origin.y, width: voicePicker.frame.width, height: height)
        //        voicePicker.frame = newRect
    }
    
    @IBAction func tapTimeFormatSwitch(_ sender: UISwitch) {
        let use24 = sender.isOn
        let parent = delegate!
        
        parent.formatter.use24 = use24
        updateTimeFormatLabels()
        
        // redraw clock immediately
        parent.currentTime = parent.formatter.currentTime()
        parent.updateClockLabel()
    }
    
    @IBAction func tapVolumeSwitch(_ sender: UISwitch) {
        let parent = delegate!
        
        parent.muted = sender.isOn
        updateVolumeLabels()
    }
    
    //MARK: UIPickerViewDataSource and UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let parent = delegate!
        
        return parent.speaker.voices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let parent = delegate!
        
        let voice = parent.speaker.voices[row]
        return "\(voice.name) (\(voice.language))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let parent = delegate!
        
        let voice = parent.speaker.voices[row]
        parent.speaker.voice = voice
    }
    
    // MARK: Private helpers
    
    func updateTimeFormatLabels() {
        let parent = delegate!
        
        let use24 = parent.formatter.use24
        toggleBold(label: timeFormat24Label, setBold: use24)
        toggleBold(label: timeFormat12Label, setBold: !use24)
    }
    
    func updateVolumeLabels() {
        let parent = delegate!
        
        let muted = parent.muted
        volumeOnLabel.alpha = muted ? 0.25 : 1.0
        volumeOffLabel.alpha = muted ? 1.0 : 0.25
        parent.timeLabel.alpha = muted ? 0.5 : 1.0
    }
    
    func toggleBold(label: UILabel, setBold: Bool) {
        if let font = label.font {
            let size = font.pointSize
            label.font = setBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
