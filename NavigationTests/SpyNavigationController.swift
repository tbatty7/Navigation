//
//  SpyNavigationController.swift
//  NavigationTests
//
//  Created by Timothy D Batty on 2/8/22.
//

import UIKit

class SpyNavigationController: UINavigationController {
    private(set) var pushViewControllerArgsAnimated: [Bool] = []
    
    override func pushViewController(_ viewController: UIViewController,
                            animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerArgsAnimated.append(animated)
    }
}
