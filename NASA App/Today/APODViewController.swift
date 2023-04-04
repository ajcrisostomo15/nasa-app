//
//  TodayViewController.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import UIKit
import RxSwift
import Kingfisher
import Toast_Swift
import SwiftDate

class APODViewController: UIViewController {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    
    private lazy var photoImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let action = UIAction { _ in
            self.showInfoForDatePicked()
        }
        let datePicker = UIDatePicker(frame: .zero, primaryAction: action)
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private let disposeBag = DisposeBag()
    private var viewModel: ApodViewModel!
    
    convenience init(viewModel: ApodViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupBindings()
        viewModel.getTodaysData()
    }
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(datePicker)
        view.addSubview(headerLabel)
        view.addSubview(dateLabel)
        view.addSubview(photoImageView)
        view.addSubview(explanationLabel)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.height.equalTo(350)
            make.top.equalTo(explanationLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.data.subscribe { data in
            self.populateFields(withData: data)
        }.disposed(by: self.disposeBag)
        
        viewModel.errorMessage.subscribe { message in
            self.view.makeToast(message, duration: 3.0, position: .bottom)
        }.disposed(by: self.disposeBag)
    }
    
    private func populateFields(withData data: ApodData) {
        self.headerLabel.text = data.name
        self.dateLabel.text = "searched date: " + data.date
        self.explanationLabel.text = data.explanation
        self.photoImageView.kf.setImage(with: URL(string: data.imageUrl))
    }
    
    private func showInfoForDatePicked() {
        print("Selected date/time:", datePicker.date)
        let date = DateInRegion(datePicker.date, region: Region.local)
        viewModel.getTodaysData(date: date)
    }
}
