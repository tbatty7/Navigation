//
//  TestHelpers.swift
//  NavigationTests
//
//  Created by Timothy D Batty on 2/7/22.
//

import UIKit

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
