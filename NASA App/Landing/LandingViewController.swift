//
//  LandingViewController.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/4/23.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

enum ScreenType {
    case landing
    case today
    case specificDay
    case rangeOfDates
}
class LandingViewController: UIViewController {
    // MARK: - UIs
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Welcome to NASA APOD"
        return label
    }()
    
    private lazy var subHeaderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Astronomy Picture of the Day"
        return label
    }()
    
    private lazy var dateTextfield: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private lazy var todayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("See photo of the day", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private lazy var specificDayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("See a photo of a specific date", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private lazy var browseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Browse list of photo from set of dates", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todayButton, specificDayButton, browseButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupBindings()
    }
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(subHeaderLabel)
        view.addSubview(buttonStackView)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        subHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setupBindings() {
        todayButton.rx.tap.bind {
            self.navigateTo(screen: .today)
        }.disposed(by: self.disposeBag)
    }
    
    private func navigateTo(screen: ScreenType) {
        switch screen {
        case .today:
            let service = NASAService()
            let gateway = APODGateway(service: service)
            let usecase = TodayUseCase(gateWay: gateway)
            let viewModel = ApodViewModel(todayUseCase: usecase)
            let vc = APODViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
