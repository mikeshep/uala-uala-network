
import RxSwift

struct UalaNetwork {
    
    let provider = MealDBProvider()
    
    func search(by string: String) -> Single<MealResponse> {
        return provider.request(.search(s: string))
    }
    
    func getMealDetail(by id: String) -> Single<MealResponse> {
        return provider.request(.detail(id: id))
    }
}


