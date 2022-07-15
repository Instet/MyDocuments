//
//  SettingsViewController.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 08.07.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    private var identifier = String(describing: SortedTableViewCell.self)


    private lazy var tableSettings: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .white
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableSettings.delegate = self
        tableSettings.dataSource = self
        tableSettings.register(SortedTableViewCell.self,
                               forCellReuseIdentifier: identifier)

        setupConstraints()

    }

    private func setupConstraints() {
        view.addSubviews(tableSettings)

        NSLayoutConstraint.activate([
            tableSettings.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableSettings.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableSettings.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableSettings.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])
    }


}

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SortedTableViewCell else { return UITableViewCell() }
            return cell

        } else if indexPath.row == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var content = cell.defaultContentConfiguration()
            content.text = "Изменить пароль"
            content.textProperties.alignment = .justified
            cell.contentConfiguration = content
            return cell
        }
        return UITableViewCell()
    }


}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let pass = PassViewController(isChange: true)
            pass.modalPresentationStyle = .fullScreen
            present(pass, animated: true)

        }

    }

}
