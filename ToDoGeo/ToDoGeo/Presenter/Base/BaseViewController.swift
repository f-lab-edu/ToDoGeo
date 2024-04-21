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
        
        setupLayout()
        setupAttribute()
    }
    
    /// 레이아웃, addSubview 등
    func setupLayout() {}
    /// 각 UI의 특성을 추가
    func setupAttribute() {}
}
