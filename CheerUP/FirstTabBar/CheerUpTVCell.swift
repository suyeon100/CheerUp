//
//  CheerUpTVCell.swift
//  CheerUP
//
//  Created by 박수연 on 11/27/24.
//

import UIKit

class CheerUpTVCell: UITableViewCell {
    var cheerUpLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        cheerUpLabel = UILabel()
        guard let cheerUpLabel = cheerUpLabel else { return }
        
        cheerUpLabel.translatesAutoresizingMaskIntoConstraints = false
        cheerUpLabel.textAlignment = .left
        cheerUpLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(cheerUpLabel)
        
        NSLayoutConstraint.activate([
            cheerUpLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cheerUpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cheerUpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
