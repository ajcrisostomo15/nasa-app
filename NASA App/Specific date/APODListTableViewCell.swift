//
//  APODListTableViewCell.swift
//  NASA App
//
//  Created by Allen Jeffrey Crisostomo on 4/5/23.
//

import UIKit

class APODListTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInterface() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(4)
            make.right.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func setupCell(forAPOD data: ApodData) {
        self.titleLabel.text = data.name
    }
}
