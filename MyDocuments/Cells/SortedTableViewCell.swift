//
//  SortedTableViewCell.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 08.07.2022.
//

import UIKit

class SortedTableViewCell: UITableViewCell {

    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(toggleOn), for: .valueChanged)
        return switcher
    }()

    private lazy var labelSort: UILabel = {
        let label = UILabel()
        label.text = "Sort Z to A"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.addSubviews(labelSort, switcher)

        NSLayoutConstraint.activate([
            labelSort.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            labelSort.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

    }

    @objc func toggleOn() {
        UserDefaults.standard.setValue(switcher.isOn, forKey: "sorted")
    }

}
