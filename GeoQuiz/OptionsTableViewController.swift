//
//  OptionsTableViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
import Parse

class OptionsTableViewController: UITableViewController {

    @IBOutlet weak var switchSoundEnable: UISwitch!
    var defaults: NSUserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = NSUserDefaults()

        if let enabled: AnyObject = defaults.objectForKey("SoundEnabled") {
            switchSoundEnable.on = enabled as! Bool
        } else {
            switchSoundEnable.on = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }

    @IBAction func logoutClick(sender: AnyObject) {
        PFUser.logOut()
    }
    
    @IBAction func soundEnableChange(sender: AnyObject) {
        defaults.setBool(switchSoundEnable.on , forKey: "SoundEnabled")
        defaults.synchronize()
    }
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionsCell") as! UITableViewCell

        if cell.textLabel!.text != "Language" {
            var enabledSwitch = UISwitch(frame: CGRectZero) as UISwitch
            enabledSwitch.on = true
            cell.accessoryView = enabledSwitch
        }
        

        return cell
    }*/
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
    let admin = self.admin[indexPath.row]
    
    let text1a = admin.FirstName
    let text1aa = " "
    
    let text1b = admin.LastName
    let text1 = text1a + text1aa + text1b
    (cell.contentView.viewWithTag(1) as UILabel).text = text1
    
    if admin.admin == "yes" {
    (cell.contentView.viewWithTag(2) as UISwitch).setOn(true, animated:true)
    
    } else if admin.admin == "no" {
    (cell.contentView.viewWithTag(2) as UISwitch).setOn(false, animated:true)
    }
    
    return cell
    }*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
