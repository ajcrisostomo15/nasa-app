//
//  ApodViewModel.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import RxSwift
import Moya
import RxRelay
import SwiftDate

class ApodViewModel {
    private let disposeBag = DisposeBag()
    private let todayUseCase: TodayUseCase!
    let data = PublishSubject<ApodData>()
    let errorMessage = PublishSubject<String>()
    
    init(todayUseCase: TodayUseCase) {
        self.todayUseCase = todayUseCase
    }
    
    func getTodaysData(date: DateInRegion? = nil) {
        let date = date ?? DateInRegion()
        todayUseCase.execute(param: APODParam(date: date.toString(.custom("yyyy-MM-dd")))).subscribe { resp in
            let data = ApodData(name: resp.title, date: resp.date, explanation: resp.explanation, imageUrl: resp.imageUrl)
            self.data.onNext(data)
        } onFailure: { error in
            self.errorMessage.onNext(error.localizedDescription)
        }.disposed(by: disposeBag)

    }
}

struct ApodData {
    var name: String
    var date: String
    var explanation: String
    var imageUrl: String
    
    init(name: String, date: String, explanation: String, imageUrl: String) {
        self.name = name
        self.date = date
        self.explanation = explanation
        self.imageUrl = imageUrl
    }
}
