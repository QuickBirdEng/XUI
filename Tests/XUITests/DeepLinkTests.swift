
import XCTest
@testable import XUI

class ParentViewModel: ViewModel, ObservableObject {
    @Published var child: ChildViewModel?
}

class ChildViewModel: ViewModel, ObservableObject {

}

final class DeepLinkTests: XCTestCase {

    func testMirror() {
        let viewModel = ParentViewModel()
        XCTAssertNil(viewModel.firstReceiver(as: ChildViewModel.self))
        viewModel.child = .init()
        XCTAssertNotNil(viewModel.firstReceiver(as: ChildViewModel.self))
        viewModel.child = nil
        XCTAssertNil(viewModel.firstReceiver(as: ChildViewModel.self))
    }

    static var allTests = [
        ("testMirror", testMirror),
    ]

}
