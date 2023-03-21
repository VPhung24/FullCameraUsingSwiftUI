//
//  CameraView.swift
//  WhatChaUp2
//
//  Created by Vivian Phung on 3/20/23.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var isPresented = false
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            Text("Open Camera")
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            CameraViewControllerWrapper()
        })
    }
}

struct CameraViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No need to update the view controller
    }
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    private var captureSession: AVCaptureSession!
    private var cameraOutput: AVCapturePhotoOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        let camera = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: camera!)
            cameraOutput = AVCapturePhotoOutput()
            captureSession.addInput(input)
            captureSession.addOutput(cameraOutput)
        } catch {
            print(error.localizedDescription)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            let image = UIImage(data: imageData)
            // Do something with the captured image
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let settings = AVCapturePhotoSettings()
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
