@testable import Navigation
import XCTest
import ViewControllerPresentationSpy

final class ViewControllerTests: XCTestCase {
    private var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func test_tappingCodePushButton_shouldPushCodeNextViewController() throws {

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
    
    func test_tappingCodePushButton_shouldBeAnimatedWhenPushingCodeNextViewController() throws {

        let navigation = SpyNavigationController(rootViewController: viewController)
        
        tap(viewController.codePushButton)
        executeRunLoop()
        
        XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
        let pushedVC = navigation.viewControllers.last
        guard let codeNextVC = pushedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, but was \(String(describing: pushedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Pushed from code")
        XCTAssertEqual(navigation.pushViewControllerArgsAnimated.count, 2)
        XCTAssertEqual(String(describing: navigation.pushedViewControllers.first), String(describing: viewController), "Expected first ViewController to be the main ViewController, second one to be CodeNextViewController")
        XCTAssertEqual(navigation.pushViewControllerArgsAnimated.first, false, "Expected animation to not be passed for main ViewController")
        XCTAssertEqual(navigation.pushViewControllerArgsAnimated.last, true, "Expected animation to be passed for CodeNextViewController")
    }

    func test_INCORRECT_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        // This does not deinit either of the ViewControllers
        
        UIApplication.shared.windows.first?.rootViewController = viewController
        
        tap(viewController.codeModalButton)
        let presentedVC = viewController.presentedViewController
        guard let codeNextVC = presentedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, but was \(String(describing: presentedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Modal from code")
    }
}

// We can't use this for a ViewController that comes from a storyboard
private class TestableViewController: ViewController {
    var presentCallCount = 0
    var presentArgsViewController: [UIViewController] = []
    var presentArgsAnimated: [Bool] = []
    var presentArgsClosure: [(()->Void)?] = []
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (()->Void)? = nil) {
        presentCallCount += 1
        presentArgsViewController.append(viewControllerToPresent)
        presentArgsAnimated.append(flag)
    }
}
