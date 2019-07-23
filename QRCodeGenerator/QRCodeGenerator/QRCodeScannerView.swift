//
//  QRCodeScannerView.swift
//  QRCodeGenerator
//
//  Created by Aquib on 23/07/19.
//  Copyright © 2019 Aquib. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRDelegate:class {
    func onQrSuccess(value:String)
    func onQrFailure(message:String)
}


@IBDesignable
class QRCodeScannerView:UIView,AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate:QRDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCamera()
    }
    
    
    private func setUpCamera(){
        clipsToBounds = true
        backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed(message:"No Camera availabel")
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed(message: "Camera input error")
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed(message: "Camera session error")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed(message: "Camera session error")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
   
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stop()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                failed(message: "No code found")
                return
            }
            guard let stringValue = readableObject.stringValue else {
                failed(message: "No data found")
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    private func failed(message:String) {
        self.addBorder(color: .red)
        delegate?.onQrFailure(message: message)
    }
    
    private func found(code: String) {
        print(code)
        addBorder(color: .green)
        delegate?.onQrSuccess(value: code)
    }
    
    func stop(){
        captureSession.stopRunning()
    }
    
    private func addBorder(color:UIColor){
        let path = UIBezierPath(rect: bounds)
        
        let layer = CAShapeLayer()
        layer.lineWidth = 6
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.layer.insertSublayer(layer, at: 1)
    }
}
