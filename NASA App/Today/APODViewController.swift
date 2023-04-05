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
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.text = "Astronomy Picture of the day"
        return label
    }()
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
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private lazy var showPhotoTodayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.configuration = .filled()
        
        return button
    }()
    
    private lazy var datesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [datePicker, showPhotoTodayButton])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
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
    }
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        if viewModel.shouldShowDatePicker {
            view.addSubview(datesStackView)
            datesStackView.snp.makeConstraints { make in
                make.top.equalTo(welcomeLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
            }
        }
        
        view.addSubview(headerLabel)
        view.addSubview(photoImageView)
        view.addSubview(explanationLabel)
    
        headerLabel.snp.makeConstraints { make in
            if self.viewModel.shouldShowDatePicker {
                make.top.equalTo(datesStackView.snp.bottom).offset(16)
            } else {
                make.top.equalTo(welcomeLabel.snp.bottom).offset(16)
            }
            
            make.centerX.equalToSuperview()
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.top.equalTo(explanationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupBindings() {
        viewModel.data.subscribe { data in
            guard let data = data else { return }
            self.populateFields(withData: data)
        }.disposed(by: self.disposeBag)
        
        viewModel.errorMessage.subscribe { message in
            self.view.makeToast(message, duration: 3.0, position: .bottom)
        }.disposed(by: self.disposeBag)
        
        showPhotoTodayButton.rx.tap.bind {
            self.showInfoForDatePicked()
        }.disposed(by: self.disposeBag)
        
        viewModel.showActivity.subscribe(onNext: {
            self.view.makeToastActivity(.center)
        }).disposed(by: self.disposeBag)
        
        viewModel.hideActivity.subscribe(onNext: {
            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        }).disposed(by: self.disposeBag)
    }
    
    private func populateFields(withData data: ApodData) {
        self.headerLabel.text = data.name
        self.dateLabel.text = "searched date: " + data.date
        self.explanationLabel.text = data.explanation
        self.photoImageView.kf.setImage(with: URL(string: data.imageUrl))
    }
    
    private func showInfoForDatePicked() {
        let date = DateInRegion(datePicker.date, region: Region.local)
        viewModel.getTodaysData(date: date)
    }
}
