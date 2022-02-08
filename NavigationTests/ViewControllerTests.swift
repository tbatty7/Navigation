@testable import Navigation
import XCTest

final class ViewControllerTests: XCTestCase {

    func test_tappingCodePushButton_shouldPushCodeNextViewController() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.loadViewIfNeeded()
        let navigation = UINavigationController(rootViewController: viewController)
        
        tap(viewController.codePushButton)
        executeRunLoop()
        
        XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
        let pushedVC = navigation.viewControllers.last
        guard let codeNextVC = pushedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, but was \(String(describing: pushedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Pushed from code")
    }
}
