//Copyright (c) 2019 Cybavo. All rights reserved.

import UIKit
import AVFoundation
import CYBAVOAuth

protocol QRCodeContentDelegate: class {
    func onPair(result: Result<PairResult>)
}

class QRCodeScanController: UIViewController {
    var scanPairView: ScanPairView!
//    var captureSession: AVCaptureSession!
//    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: QRCodeContentDelegate?
    @IBAction func pickQRImage(_ sender: Any) {
        PairImagePicker.start(self, pairListener: self, pushDeviceToken: PushDeviceToken, mode: PairMode.TOKEN)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanPairView = ScanPairView(frame: CGRect(x: 0, y: 0 , width: view.frame.width, height: view.frame.height))
        scanPairView.setPairListener(listener: self)
        scanPairView.setMode(mode: PairMode.TOKEN)
        scanPairView.setPushDeviceToken(token: PushDeviceToken)
        view.addSubview(scanPairView)
//        view.backgroundColor = UIColor.black
//        captureSession = AVCaptureSession()
//
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return
//        }
//
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//        } else {
//            failed()
//            return
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)
//
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]
//        } else {
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = view.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
//
//        captureSession.startRunning()
    }
    
//    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//        captureSession = nil
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if (captureSession?.isRunning == false) {
//            captureSession.startRunning()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if (captureSession?.isRunning == true) {
//            captureSession.stopRunning()
//        }
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()
//
//        if let metadataObject = metadataObjects.first {
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//            guard let stringValue = readableObject.stringValue else { return }
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: stringValue)
//        }
//
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func found(code: String) {
//        print(code)
//        delegate?.onScan(code: code)
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension QRCodeScanController : PairListener {
    func getEndpoint() -> String {
        return UserDefaults.standard.string(forKey: "endpoints") ?? ""
    }
    
    func getApiCode() -> String {
        return UserDefaults.standard.string(forKey: "apicode") ?? ""
    }
    
    func onPairSuccess(result: Result<PairResult>) {
        delegate?.onPair(result: result)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onPairError(_ error: Error) {
        self.navigationController?.popViewController(animated: true)
    }
}
