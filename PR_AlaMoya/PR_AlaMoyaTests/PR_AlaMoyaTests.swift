//
//  PR_AlaMoyaTests.swift
//  PR_AlaMoyaTests
//
//  Created by Hyeontae on 11/09/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import XCTest
@testable import PR_AlaMoya
import Moya
import Alamofire

class PR_AlaMoyaTests: XCTestCase {

    let provider = MoyaProvider<TestTarget>()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGet() {
        let expectation = XCTestExpectation(description: "get TEST 1")
        let expectation2 = XCTestExpectation(description: "get TEST 2")
        
        provider.request(.getData) { result in
            print(expectation.description)
            switch result {
            case .success(let value):
                let json = try! JSONSerialization.jsonObject(with: value.data, options: []) as! [String: Any]
                print(json)
            case .failure(let error):
                print("error \(error.response)")
            }
            
            expectation.fulfill()
        }
        
        provider.request(.getPath) { result in
            print(expectation2.description)
            switch result {
            case .success(let value):
                print("@@@@")
                print(try! value.mapString())
                print("@@@@")
                print(try! value.mapJSON())
                print("@@@@")
//                let json = try! JSONSerialization.jsonObject(with: value.data, options: []) as! [String: Any]
//                print(json)
            case .failure(let error):
                print("error \(error.response)")
            }
            
            expectation2.fulfill()
        }
        
        wait(for: [expectation,expectation2], timeout: 2)
    }
    
    func testPost() {
        let exp2 = XCTestExpectation(description: "post Data")
        
        let testobj: [String: String] = ["hello": "world", "foo2": "bar2"]
        let testJSON = try! JSONSerialization.data(withJSONObject: testobj, options: [])
        
        provider.request(.postData(data: testJSON)) { result in
            print(exp2.description)
            switch result {
            case .success(let value):
                let json = try! JSONSerialization.jsonObject(with: value.data, options: []) as! [String: Any]
                print("@@@")
                print(json["data"])
                print("@@@@")
                print(json)
            case .failure(let error):
                print("error \(error.response)")
            }
            exp2.fulfill()
        }
        
        wait(for: [exp2], timeout: 2)
    }
//
//    func testMultipart() {
//        print("multipart TEST")
//        let ex = XCTestExpectation(description: "multi")
//        var formData: [MultipartFormData] = []
//
//        formData.append(MultipartFormData(provider: .data("bar1".data(using: .utf8)!), name: "foo1"))
//        formData.append(MultipartFormData(provider: .data("bar2".data(using: .utf8)!), name: "foo2"))
//
//        provider.request(.multi(data: formData)) { result in
//            print("got response")
//            switch result {
//            case .success(let val):
//                print("success")
//                print(val.data)
//                print(try! val.mapJSON())
//
//            case .failure(let error):
//                print("fail")
//                print(error.errorCode)
//                print(error.errorDescription)
//
//            }
//
//            ex.fulfill()
//        }
//        wait(for: [ex], timeout: 3)
//
//    }
    
    func testAlamof() {
        let ex = XCTestExpectation(description: "alamofire")
        print("START")
        Alamofire.upload(multipartFormData: { multipart in
            multipart.append("bar1".data(using: .utf8)!, withName: "foo1")
            multipart.append("bar2".data(using: .utf8)!, withName: "foo2")
        }, to: "https://postman-echo.com/post") { response in
            print("GOT RESPONSE")
            switch response {
            case .success(let req, _, _):
                print("SUCCESS")
                req.responseJSON(completionHandler: { dataResponse in
                    
                    print("SECONDE SUCCESS")
                    print(dataResponse.data)
                    print(dataResponse.response?.statusCode)
                    ex.fulfill()
                })
            case .failure(let error):
                print("FAIL")
                print(error.localizedDescription)
            }
            
        }
        
        wait(for: [ex], timeout: 3)
        
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
