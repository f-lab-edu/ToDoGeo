//
//  AlertManager.swift
//  ToDoGeo
//
//  Created by SUN on 5/10/24.
//

import UIKit

final class AlertManager {
    static let shared = AlertManager()
    private init() {}
    
    func showInfoAlert(message: String, completeTitle: String = "확인", completeHandler:(() -> Void)? = nil) {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let completeAction = UIAlertAction(title: completeTitle, style: .default) { action in
            completeHandler?()
        }
        
        alert.addAction(completeAction)
        
        keyWindow.rootViewController?.topMostViewController.present(alert, animated: true, completion: nil)
    }
}
