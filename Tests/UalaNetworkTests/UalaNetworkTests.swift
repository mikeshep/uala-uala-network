import XCTest
import RxSwift

@testable import UalaNetwork

final class UalaNetworkTests: XCTestCase {
    
    let network = UalaNetwork()
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    func test_search_fish() {
        //Given
        let expect = expectation(description: "Waiting for request...")
        
        //When
        network.search(by: "fish").subscribe { (response) in
            //Then
            expect.fulfill()
        } onError: { (error) in
            debugPrint(error)
            //Then
            XCTFail("Unexpected Error")
        }.disposed(by: disposeBag)
        waitForExpectations(timeout: 2)
    }
    
    func test_get_detail_Fish_Pie_52802() {
        //Given
        let expect = expectation(description: "Waiting for request...")
        
        //When
        network.getMealDetail(by: "52802").subscribe { (response) in
            //Then
            expect.fulfill()
        } onError: { (error) in
            debugPrint(error)
            //Then
            XCTFail("Unexpected Error")
        }.disposed(by: disposeBag)
        waitForExpectations(timeout: 2)
    }

    static var allTests = [
        ("test_search_fish", test_search_fish),
        ("test_get_detail_Fish_Pie_52802", test_get_detail_Fish_Pie_52802)
    ]
}
