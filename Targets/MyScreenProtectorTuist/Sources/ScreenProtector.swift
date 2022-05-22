//
//  ScreenProtector.swift
//  DisableScreenCapture
//
//  Created by Hyunyou Lim on 2022/04/07.
//

import Foundation
import UIKit

class ScreenProtector {
    private var warningWindow: UIWindow?
    
    private var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
    
    func startPreventingRecording() {
        //Capture가되면 이 함수(didDetectRecording)을 호출하도록 매핑
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
        //처음앱에 진입할때 레코딩상태면 함수 호출
        if window?.screen.isCaptured == true {
            didDetectRecording()
        }
    }
    
    //ScreenRecording 이벤트시 호출되는 메소드
    @objc func didDetectRecording() {
        if window?.screen.isCaptured == true {
            DispatchQueue.main.async {
                self.hideScreen()
                self.presentWarningWindow()
            }
        }else {
            DispatchQueue.main.async {
                self.presentScreen()
            }
        }
    }
    
    private func presentScreen(){
        warningWindow?.removeFromSuperview()
        warningWindow = nil
        window?.isHidden = false
    }
    
    private func hideScreen(){
        window?.isHidden = true
    }
    
    private func presentWarningWindow(){
        //Remove existing
        warningWindow?.removeFromSuperview()
        warningWindow = nil
        
        guard let frame = window?.bounds else { return }
        
        //Warning Label
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Recording Screen is Prevented!"
        
        //Warning window->아래 소스가 에러안나도록 임의로 초기화함
        var warningWindow = UIWindow(frame: frame)
        
        //foreground에 있는 첫번째 Scene
        let windowScene = UIApplication.shared.connectedScenes.first
//        let windowScene = UIApplication.shared.connectedScenes.first{
//            //foregroundActive 는 현재 지금 이벤트를 받고 있는 Scene 화면에 떠있는 Scene
//            //foregroundInactive 는 현재 화면에 떠있긴 하지만 이벤트를 받지않고 있는 Scene
//            //(Lock Screen이나 Control Tower에가려진 Scene
//            //$0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
//            switch $0.activationState{
//            default:
//                return true
//            }
//        }
        //windowscene과 연결된 UIwindow만 띄울수있음(SceneDelegate가 생기면서 이렇게 바뀐것 같음)
        if let windowScene = windowScene as? UIWindowScene {
            //실제로 띄울 window 초기화
            warningWindow = UIWindow(windowScene: windowScene)
        }
        
        warningWindow.frame = frame
        warningWindow.backgroundColor = .black
        warningWindow.windowLevel = UIWindow.Level.statusBar + 1
        warningWindow.clipsToBounds = true
        warningWindow.isHidden = false
        warningWindow.addSubview(label)
        warningWindow.bringSubviewToFront(label)
        
        self.warningWindow = warningWindow
        
        UIView.animate(withDuration: 0.15){
            label.alpha = 1.0
            label.transform = .identity
        }
        
        warningWindow.makeKeyAndVisible()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
