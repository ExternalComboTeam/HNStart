//
//  QRCodeReader.swift
//  QRCodeDemo
//
//  Created by Ray on 2017/9/20.
//  Copyright © 2017年 KSD. All rights reserved.
//
import UIKit
import AVFoundation

// if not extension NSObjectProtocol, variable can't use weak
protocol QRCodeReaderDelegate: NSObjectProtocol {
    func qrcodeReader(_ qrcodeReader: QRCodeReader, didComplete data: [QRCodeData])
}

class QRCodeReader: UIView {
    
    enum ScanType {
        /// QRCode
        case QR
        /// 二維條碼
        case DataMatrix
    }
    
    weak var delegate: QRCodeReaderDelegate?
    @IBInspectable var numberOfQRCode: Int {
        set {
            self._numberOfQRCode = newValue
        }
        get {
            return self._numberOfQRCode
        }
    }
    
    var type: ScanType {
        set {
            self._scanType = newValue
        }
        get {
            return self._scanType
        }
    }
    
    var isTorch: Bool {
        get {
            guard let device = self.setVideoFrame() else {
                return false
            }
            return device.torchMode == .on
        }
    }
    
    fileprivate var session: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var qrCodeFrameView: [UIView] = []
    fileprivate var qrCodeData: [QRCodeData] = []
    fileprivate var _numberOfQRCode: Int = 1
    fileprivate var _scanType: ScanType = .QR
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.initAVCaptureSession(at: self)
    }
    
    // init camera
    private func initAVCaptureSession(at view: UIView) {
        self.session = AVCaptureSession()
        self.setCaptureInAndOut()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.previewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(self.previewLayer, at: 0)
        self.session.startRunning()
    }
    
    // set capture input and output
    private func setCaptureInAndOut() {
        guard let device = self.setVideoFrame() else {
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: device)
            if self.session.canAddInput(videoInput) {
                self.session.addInput(videoInput)
            }
            
            let dataOutputDispatch = DispatchQueue(label: "scanQRCode")
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dataOutputDispatch)
            if self.session.canAddOutput(captureMetadataOutput) {
                self.session.addOutput(captureMetadataOutput)
                captureMetadataOutput.metadataObjectTypes = [ self._scanType == .QR ? .qr : .dataMatrix ]
            }
        } catch {
            print("carma failed")
        }
    }
    
    // set video max frmae duration
    private func setVideoFrame() -> AVCaptureDevice? {
        guard let device = self.catchDevice() else {
            return nil
        }
        
        do {
            try device.lockForConfiguration()
            device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 29)
            device.unlockForConfiguration()
            return device
        } catch {
            print("setting video device failed")
            return nil
        }
    }
    
    private func catchDevice() -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
                return nil
            }
            return device
        } else {
            guard let device = AVCaptureDevice.default(for: .video) else {
                return nil
            }
            return device
        }
    }
    
    // reStart
    func reStart() {
        guard let subLayer = self.layer.sublayers else {
            return
        }
        
        guard self.previewLayer != nil else {
            return
        }
        
        guard subLayer.contains(self.previewLayer) else {
            return
        }
        
        self.subviews.forEach({$0.removeFromSuperview()})
        
        self.qrCodeData.removeAll()
        self.session.startRunning()
    }
    
    // stop
    func stop() {
        self.session.stopRunning()
    }
    
    /// open light
    func changeLight() {
        guard let device = self.catchDevice() else {
            return
        }
        
        guard device.hasTorch else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            if self.isTorch {
                device.torchMode = .off
            } else {
                device.torchMode = .on
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    // 移除影像
    func remove() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        guard let subLayer = self.layer.sublayers else {
            return
        }
        
        for layer in subLayer {
            layer.removeFromSuperlayer()
        }
    }
}

extension QRCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        self.qrCodeData.removeAll()
        DispatchQueue.main.async {
            self.qrCodeFrameView.forEach({$0.removeFromSuperview()})
        }
        guard let metaArray = metadataObjects as? [AVMetadataMachineReadableCodeObject], metaArray.count > 0 else {
            return
        }
        
        for meta in metaArray {
			
            guard let barCode = self.previewLayer.transformedMetadataObject(for: meta) as? AVMetadataMachineReadableCodeObject else {
                return
            }
			
            if meta.type == .qr && self._scanType == .QR {
				if let code = barCode.stringValue {
					let data = QRCodeData(value: code, bounds: barCode.bounds)
					self.qrCodeData.append(data)
				}
            }
            
            if meta.type == .dataMatrix && self._scanType == .DataMatrix {
                
            }
        }
        
        if self.qrCodeData.count >= self._numberOfQRCode {
            DispatchQueue.main.async {
                self.delegate?.qrcodeReader(self, didComplete: self.qrCodeData)
            }
        }
    }
}

struct QRCodeData {
    var value: String = ""
    var bounds: CGRect = CGRect.zero
    
    func contains(_ item: QRCodeData) -> Bool {
        return self.value == item.value
    }
}
