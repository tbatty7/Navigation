//
//  CodeNextViewController.swift
//  Navigation
//
//  Created by Timothy D Batty on 2/7/22.
//

import UIKit

class CodeNextViewController: UIViewController {

    let label = UILabel()
    
    init(labelText: String) {
        label.text = labelText
        super.init(nibName: nil, bundle: nil)
        print(">>>>>>> Initialized CodeViewController with \(labelText)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        activateEqualConstraints(.centerX, fromItem: label, toItem: view)
        activateEqualConstraints(.centerY, fromItem: label, toItem: view)
        print(">>>>>>>>> Loaded content")
    }
    
    private func activateEqualConstraints(
                                _ attribute: NSLayoutConstraint.Attribute,
                                  fromItem: UIView,
                                  toItem: UIView) {
        NSLayoutConstraint(item: fromItem,
                           attribute: attribute,
                           relatedBy: .equal,
                           toItem: toItem,
                           attribute: attribute,
                           multiplier: 1,
                           constant: 0).isActive = true
    }
    
    deinit {
        print(">>>>>>> CodeNextViewController.deinit")
    }
}
