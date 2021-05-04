import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DeepLinkTests.allTests),
        testCase(XUITests.allTests),
    ]
}
#endif
