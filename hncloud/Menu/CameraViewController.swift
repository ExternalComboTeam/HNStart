//
//  CameraViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController {

    @IBOutlet weak var capturePreview: UIView!
    @IBOutlet weak var captureButtonOutlet: UIButton!
    
    private let cameraController = CameraController()
    
    @IBAction func captureAction(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            print("show image")
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
    @IBAction func toggleCamera(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        } catch {
            print(error)
        }
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let back = UIBarButtonItem()
        back.title = "取消".localized()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreview)
            }
        }
        
        configureCameraController()
        
        
        // MARK: Bluetooth shutter control
        CositeaBlueTooth.instance.changeTakePhotoState(true)
        CositeaBlueTooth.instance.recieveTakePhotoMessage { (_) in
            self.captureAction(self.captureButtonOutlet)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CositeaBlueTooth.instance.changeTakePhotoState(false)
        self.cameraController.stop()
    }
}
