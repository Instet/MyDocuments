//
//  DocumentsTableViewCell.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 06.07.2022.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private lazy var nameFiles: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var size: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewElements() {
        contentView.addSubviews(image, nameFiles, size)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),

            nameFiles.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameFiles.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            nameFiles.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            size.topAnchor.constraint(equalTo: nameFiles.bottomAnchor, constant: 10),
            size.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            size.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func configCell(_ file: Document) {
        image.image = file.image
        nameFiles.text = file.name
        size.text = file.size
    }



    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


