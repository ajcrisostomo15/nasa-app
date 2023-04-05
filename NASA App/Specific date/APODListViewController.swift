//
//  APODListViewController.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/5/23.
//

import UIKit
import SwiftDate
import RxSwift

class APODListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 45
        tableView.register(APODListTableViewCell.self, forCellReuseIdentifier: "APODListTableViewCell")
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private lazy var endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private lazy var showListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.configuration = .filled()
        
        return button
    }()
    
    private lazy var datesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [datePicker, endDatePicker, showListButton])
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.text = "Please select two dates"
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1
        
        return view
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
        view.addSubview(headerLabel)
        view.addSubview(containerView)
        containerView.addSubview(datesStackView)
        view.addSubview(tableView)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        datesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(datesStackView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        showListButton.rx.tap.bind {
            self.showInfoForDatePicked()
        }.disposed(by: self.disposeBag)
        
        viewModel.apodDataSource.bind(to: tableView.rx.items(cellIdentifier: "APODListTableViewCell", cellType: APODListTableViewCell.self)) {_, model, cell in
            cell.setupCell(forAPOD: model)
        }.disposed(by: self.disposeBag)
        
        viewModel.showActivity.subscribe(onNext: {
            self.view.makeToastActivity(.center)
        }).disposed(by: self.disposeBag)
        
        viewModel.hideActivity.subscribe(onNext: {
            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        }).disposed(by: self.disposeBag)
    }
    
    private func showInfoForDatePicked() {
        self.view.makeToastActivity(.center)
        let date = DateInRegion(datePicker.date, region: Region.local)
        let endDate = DateInRegion(endDatePicker.date, region: Region.local)
        viewModel.getAPOD(fromDates: date, endDate: endDate)
    }
    
    private func navigateToNextScreen(withData data: ApodData) {
        let service = NASAService()
        let gateway = APODGateway(service: service)
        let todayUseCase = TodayUseCase(gateWay: gateway)
        let setDatesUseCase = SetDatesUseCase(gateWay: gateway)
        let viewModel = ApodViewModel(todayUseCase: todayUseCase, setDatesUseCase: setDatesUseCase)
        viewModel.shouldShowDatePicker = false
        viewModel.data.accept(data)
        let vc = APODViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension APODListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToNextScreen(withData: viewModel.getData(fromIndex: indexPath.row))
    }
}
