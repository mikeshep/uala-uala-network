
import RxSwift

public struct UalaNetwork {
    
    public init() {}
    
    private let provider = MealDBProvider()
    
    public func search(by string: String) -> Single<MealResponse> {
        return provider.request(.search(s: string))
    }
    
    public func getMealDetail(by id: String) -> Single<MealResponse> {
        return provider.request(.detail(id: id))
    }
}


