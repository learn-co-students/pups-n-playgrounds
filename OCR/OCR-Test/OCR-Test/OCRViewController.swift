//
//  OCRViewController.swift
//  OCR-Test
//
//  Created by Felicity Johnson on 11/16/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import TesseractOCR
import GPUImage

class OCRViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    
    
    var activityIndicator:UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func performImageRecognition(_ image: UIImage) {
 
        
        let tesseract = G8Tesseract(language: "eng")
        
        tesseract?.pageSegmentationMode = .auto
       
        tesseract?.maximumRecognitionTime = 60.0
        
        tesseract?.image = image.g8_blackAndWhite()
        
        print("tesseract image: \(tesseract?.image)")
        
        tesseract?.recognize()
       
        textView.text = tesseract?.recognizedText
        textView.isEditable = true
    
        
        removeActivityIndicator()
    }
    
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    
    @IBAction func takePictureButton(_ sender: Any) {
        
        view.endEditing(true)

        // 2
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .actionSheet)
        
        print("image created")
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker,
                                                                           animated: true,
                                                                           completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker,
                                                                       animated: true,
                                                                       completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        
        print("done")
        present(imagePickerActionSheet, animated: true,
                              completion: nil)
    
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


extension OCRViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}



extension OCRViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(image: selectedPhoto, maxDimension: 640)
        
        let adaptiveThresholdFilter = GPUImageAdaptiveThresholdFilter()
        adaptiveThresholdFilter.blurRadiusInPixels = 350
        
        let outputImage = adaptiveThresholdFilter.image(byFilteringImage: scaledImage)!
        print("OUTPUT: \(outputImage)")
        addActivityIndicator()
        
        dismiss(animated: true, completion: {
            self.performImageRecognition(outputImage)
        })
    }
}



