//
//  FileListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/27.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import EZLoadingActivity

class FileListViewController: UITableViewController {
    
    var fileList = [RepoFile]()
    var apiURLString: String?
    var pathTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        configNavigationTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let path = apiURLString {
            fetchFileList(path)
        }
    }
    
    // MARK: Private methods
    
    func configNavigationTitle() {
        let pathComponents = self.pathTitle.components(separatedBy: "/")
        let currentPath = pathComponents[pathComponents.count-1]
        let parentPath = pathComponents[pathComponents.count-2]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: currentPath == "" ? "/" : currentPath, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        if pathTitle.characters.count > 30 {
            navigationItem.title = ".../" + parentPath + "/" + currentPath
        } else {
            navigationItem.title = pathTitle
        }
    }
    
    func fetchFileList(_ path: String) {
        _ = EZLoadingActivity.show("loading files", disableUI: true)
        Alamofire.request(path)
            .responseArray(completionHandler: { (response: DataResponse<[RepoFile]>) in
                if let items = response.result.value {
                    self.fileList = items
                    self.tableView.reloadData()
                }
                _ = EZLoadingActivity.hide()
            })
//            .responseJSON { (response) in
//                switch response.result{
//                case .success:
//                    if let items = Mapper<RepoFile>().mapArray(response.result.value) {
//                        self.fileList = items
//                        self.tableView.reloadData()
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//                EZLoadingActivity.hide()
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! FileCell
        let file = fileList[(indexPath as NSIndexPath).row]
        if file.type == "dir" {
            cell.filenameLabel.textColor = UIColor(red: 51/255, green: 98/255, blue: 178/255, alpha: 1)
            cell.fileIconImageView.image = UIImage(named: "dir")
        } else {
            cell.fileIconImageView.image = UIImage(named: "file")
        }
        cell.filenameLabel.text = file.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = fileList[(indexPath as NSIndexPath).row]
        if file.type == "dir" {
            let nextFileListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FileListViewController") as! FileListViewController
            nextFileListVC.apiURLString = file.apiURLString
            if pathTitle == "/" {
                nextFileListVC.pathTitle = self.pathTitle + file.name!
            } else {
                nextFileListVC.pathTitle = self.pathTitle + "/" + file.name!
            }
            navigationController?.pushViewController(nextFileListVC, animated: true)
        } else if file.type == "file" {
            
            performSegue(withIdentifier: "ShowCode", sender: file)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCode" {
            let codeVC = segue.destination as! CodeViewController
            let file = sender as! RepoFile
            RecentsManager.sharedManager.addRecentFile(file)
            codeVC.file = file
        }
    }
    
    @IBAction func backToRoot(_ sender: UIBarButtonItem) {
        if let repoVC = navigationController?.viewControllers[1] {
            _ = navigationController?.popToViewController(repoVC, animated: true)
        } else {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
}
