//
//  FindNumberSlowTests.swift
//  FindNumberSlowTests
//
//  Created by 전성훈 on 2023/12/06.
//

import XCTest

@testable import FindNumber

final class FindNumberSlowTests: XCTestCase {
    var sut: URLSession!
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_유효한API_호출후_HTTPStatusCode200_받기() throws {
        try XCTSkipUnless(networkMonitor.isReachable, "Network connectivity needed for this test.")

        // given
        let urlString = "https://www.randomnumberapi.com/api/v1.0/random?min=0&max=3&count=1"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        
        dataTask.resume()
        wait(for: [promise], timeout: 3)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
