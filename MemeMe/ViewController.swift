//
//  ViewController.swift
//  MemeMe
//
//  Created by Aditya Ramayanam on 9/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topNavToolbar: UINavigationBar!
    @IBOutlet weak var bottomNavToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.text = "TOP"
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        topText.delegate = self
        
        bottomText.text = "BOTTOM"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
        bottomText.delegate = self
        
        shareButton.enabled = false
        cancelButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        // Only enable the camera button if there is a camera available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        imagePickerView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(type: String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) -> Void in
            // Save the meme and dismiss the view controller that was presented modally.
            dispatch_async(dispatch_get_main_queue()){
                self.save()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    func save() {
        //Create the meme image
        let memedImage = generateMemedImage()
        
        // Create the meme object based on the above image and save to photo album
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
        UIImageWriteToSavedPhotosAlbum(meme.getMemedImage(), nil, nil, nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide the nav bars when saving the meme
        topNavToolbar.hidden = true
        bottomNavToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomNavToolbar.hidden = false
        topNavToolbar.hidden = false

        return memedImage
    }

    // Pick an image from photo album
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Take a picture using the camera
    @IBAction func takeAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Once user grabs a valid image, enable the sharing and cancelling ability
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
            shareButton.enabled = true
            cancelButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
        textField.isFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the image screen up based on keyboard height
    func keyboardWillShow(notification: NSNotification) {
        if(bottomText.isFirstResponder()) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Move the image screen down based on keyboard height
    func keyboardWillHide(notification: NSNotification) {
        if(bottomText.isFirstResponder()) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Set notifications for whenever the user selects and dismisses the keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
}

