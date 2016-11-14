//
//  CommitFileListViewController.swift
//  CodeReader
//
//  Created by vulgur on 2016/10/19.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class CommitFileListViewController: UITableViewController {

    let commitFileCellIdentifier = "CommitFileCell"
    let dataSource = [("CodeReader.xcodeproj/project.pbxproj", 100, 200, 1),
                      ("CodeReader.xcodeproj/xcuserdata/wangshudao.xcuserdatad/xcschemes/CodeReader.xcscheme", 3, 43, 2),
                      ("CodeReader/View/CommitListViewController.swift", 2,232, 1),
                      ("CodeReader/View/RepoViewController.swift", 9323,121, 3),
                      ("CodeReader/View/BranchCell.xib", 234,1, 2)]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commitFileCellIdentifier, for: indexPath) as! CommitFileCell

        // Configure the cell...
        let item = dataSource[indexPath.row]
        cell.filenameLabel.text = shortenFilename(filename: item.0)
        cell.additionsLabel.text = "+\(item.1)"
        cell.deletionsLabel.text = "-\(item.2)"
        switch item.3 {
        case 1:
            cell.statusImageView.image = UIImage(named: "file_addition")
        case 2:
            cell.statusImageView.image = UIImage(named: "file_deletion")
        default:
            cell.statusImageView.image = UIImage(named: "file_modification")
        }

        return cell
    }
    
    private func shortenFilename(filename: String) -> String {
        let paths = filename.components(separatedBy: "/")
        if paths.count > 2 {
            return ".../".appending(paths[paths.count-2]).appending("/").appending(paths.last!)
        }
        return filename
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
