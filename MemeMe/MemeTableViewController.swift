//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Aditya Ramayanam on 10/9/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
   
    
    // Accessing the global meme array
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        // Manually reload the table data every time the user switches to the table view
        self.tableView.reloadData()
    }
    
    @IBAction func deleteSwipe(sender: UISwipeGestureRecognizer) {
        println("blah")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Iterate through the Meme array, display the image, and concatenate the top and bottom texts
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.memedLabel!.text = meme.topText + "..." + meme.bottomText
        cell.memedImage!.image = meme.memeImage
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}
