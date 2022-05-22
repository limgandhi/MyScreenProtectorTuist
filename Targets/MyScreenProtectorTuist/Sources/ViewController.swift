//
//  ViewController.swift
//  DisableScreenCapture
//
//  Created by Hyunyou Lim on 2022/04/07.
//

import UIKit

class ViewController: UIViewController {

    private let screenProtector = ScreenProtector()
    
    @IBOutlet var goNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var b=(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.screen.isCaptured
//        var c = b ?? false
//        if c == true {
//            NotificationCenter.default.post(name: UIScreen.capturedDidChangeNotification, object: nil)
//        }
//        goNextButton.setTitle(String(c), for: .normal)
        screenProtector.startPreventingRecording()
        goNextButton.setTitleColor(.white, for: .normal)
        goNextButton.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
}

