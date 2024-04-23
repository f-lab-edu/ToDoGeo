//
//  BaseViewController.swift
//  ToDoGeo
//
//  Created by SUN on 4/13/24.
//

import UIKit.UIViewController
import class RxSwift.DisposeBag

class BaseViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
