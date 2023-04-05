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
    private let todayUseCase: TodayUseCase
    private let setDatesUseCase: SetDatesUseCase
    
    let data = BehaviorRelay<ApodData?>(value: nil)
    let apodDataSource = BehaviorRelay<[ApodData]>(value: [])
    let errorMessage = PublishSubject<String>()
    let hideActivity = PublishSubject<Void>()
    let showActivity = PublishSubject<Void>()
    var shouldShowDatePicker = false
    
    init(todayUseCase: TodayUseCase, setDatesUseCase: SetDatesUseCase) {
        self.todayUseCase = todayUseCase
        self.setDatesUseCase = setDatesUseCase
    }
    
    func getTodaysData(date: DateInRegion? = nil) {
        self.showActivity.onNext(())
        let date = date ?? DateInRegion()
        todayUseCase.execute(param: APODParam(date: date.toString(.custom("yyyy-MM-dd")))).subscribe { event in
            switch event {
            case .next(let resp):
                self.hideActivity.onNext(())
                let data = ApodData(name: resp.title, date: resp.date, explanation: resp.explanation, imageUrl: resp.imageUrl)
                self.data.accept(data)
            case .error(let error):
                self.hideActivity.onNext(())
                if let error = error as? ServiceError {
                    switch error {
                    case .invalidDate:
                        self.errorMessage.onNext(error.errorDescription ?? "")
                    }
                }
            case .completed:
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getAPOD(fromDates startDate: DateInRegion, endDate: DateInRegion) {
        self.showActivity.onNext(())
        let sDate = startDate.toString(.custom("yyyy-MM-dd"))
        let eDate = endDate.toString(.custom("yyyy-MM-dd"))
        let param = APODSetDatesParam(startDate: sDate, endDate: eDate)
        setDatesUseCase.execute(param: param).subscribe { event in
            switch event {
            case .next(let resp):
                self.hideActivity.onNext(())
                let list = self.convertTo(APODData: resp)
                self.apodDataSource.accept(list)
            case .error(let error):
                self.hideActivity.onNext(())
                if let error = error as? ServiceError {
                    switch error {
                    case .invalidDate:
                        self.errorMessage.onNext(error.errorDescription ?? "")
                    }
                }
            case .completed:
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func convertTo(APODData data: [APODResp]) -> [ApodData] {
        return data.map { resp in
            return ApodData(name: resp.title, date: resp.date, explanation: resp.explanation, imageUrl: resp.imageUrl)
        }
    }
    
    func getData(fromIndex index: Int) -> ApodData {
        return apodDataSource.value[index]
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
