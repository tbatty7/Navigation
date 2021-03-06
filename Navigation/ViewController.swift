//
//  ViewController.swift
//  Navigation
//
//  Created by Timothy D Batty on 2/5/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private(set) var codePushButton: UIButton!
    @IBOutlet private(set) var codeModalButton: UIButton!
    @IBOutlet private(set) var seguePushButton: UIButton!
    @IBOutlet private(set) var segueModalButton: UIButton!

    @IBAction private func pushNextViewController() {
        let nextVC = CodeNextViewController(labelText: "Pushed from code")
        self.navigationController?.pushViewController(nextVC, animated: true)
        print(">>>>>>>> Tapped button")
    }
    
    @IBAction private func presentModalNextViewController() {
        let nextVC = CodeNextViewController(labelText: "Modal from code")
        self.present(nextVC, animated: true)
    }
    
    deinit {
        print(">>>>>>> ViewController.deinit")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pushNext"?:
            guard let nextVC = segue.destination as? SegueNextViewController
            else { return }
            nextVC.labelText = "Pushed from segue"
        case "modalNext"?:
            guard let nextVC = segue.destination as? SegueNextViewController
            else { return }
            nextVC.labelText = "Modal from segue"
        default:
            return
        }
    }
    
    #if DEBUG
    func cleanup() {
        // eliminate any persistent side effects of ViewController like running a timer or observing notifications
    }
    #endif
}

