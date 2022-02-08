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
        executeRunLoop() // This ensures the ViewController added to the UIWindow deinits
        viewController.cleanup()
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
        // This sets the viewController as the rootViewController in a visible UIWindow.
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
    
    func test_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        let presentationVerifier = PresentationVerifier()
        tap(viewController.codeModalButton)
        let codeNextVC: CodeNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: viewController)
        // this tests that the main ViewController was the presenting one,
        // that CodeNextViewController was navigated to and had animation set on it,
        // and returns the instance of the correct type if it was a CodeNextViewController,
        // otherwise it returns nil
        // This also deinits the ViewControllers
        XCTAssertEqual(codeNextVC?.label.text, "Modal from code")
    }
    
    func test_tappingSeguePushButton_shouldShowSegueNextViewController() {
        let presentationVerifier = PresentationVerifier()
        putInWindow(viewController) // for segue to work in the test, we need to load the ViewController into a visible UIWindow
        tap(viewController.seguePushButton)
        
        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: viewController)
        XCTAssertEqual(segueNextVC?.labelText, "Pushed from segue")
    }
    
    func test_tappingSegueModalButton_shouldShowSegueNextViewController() {
        // This does not deinit either of the ViewControllers, but there is not a known better option yet.
        // You can limit the side effects by creating a back door cleanup function in the ViewControllers with #if DEBUG...#endif
        let presentationVerifier = PresentationVerifier()
        
        tap(viewController.segueModalButton)
        
        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: viewController)
        XCTAssertEqual(segueNextVC?.labelText, "Modal from segue")
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
