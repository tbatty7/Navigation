//
//  SegueNextViewController.swift
//  Navigation
//
//  Created by Timothy D Batty on 2/7/22.
//

import UIKit

class SegueNextViewController: UIViewController {

    var labelText: String?
    
    @IBOutlet private(set) var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
    }
    
    deinit {
        print(">>>>>>> SegueNextViewController.deinit")
    }

}
