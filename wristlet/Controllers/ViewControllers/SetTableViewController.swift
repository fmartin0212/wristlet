//
//  SetTableViewController.swift
//  wristlet
//
//  Created by Frank Martin Jr on 8/9/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {
    
    let accessToken: String? = UserDefaults.standard.value(forKey: "accessToken") as? String
    let userID: String? = UserDefaults.standard.value(forKey: "userID") as? String
    
    var sets: [QuizletSet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let accessToken = accessToken,
            let userID = userID
            else { return }
        
        NetworkController.getUserInfo(userID: userID, accessToken: accessToken) { (sets) in
            guard let sets = sets else { return }
//            self.sets = sets
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = sets[indexPath.row].title
        
        return cell
    }
    
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
