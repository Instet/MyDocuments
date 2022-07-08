//
//  MainViewController.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 05.07.2022.
//

import UIKit
import Photos
import PhotosUI

class MainViewController: UIViewController {

   var manager = FileManagerService()

    private var jpegFiles: [Document] = []

    var identifier = String(describing: MainTableViewCell.self)

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: identifier)
        configNavBar()
        setupTableView()
        getFiles()

    }

    private func setupTableView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

    }

    private func configNavBar() {
        title = "My Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showImagePicker))
    }

    private func getFiles() {

        jpegFiles.removeAll()
        guard let files = manager.getFiles() else { return }

        /// настройка атрибутов
        var atributes = [FileAttributeKey : Any]()
        for file in files {
            do {
                atributes = try FileManager.default.attributesOfItem(atPath: file.path)
            } catch {
                print(error.localizedDescription)
            }
            let image = UIImage(contentsOfFile: file.path)
            let date = atributes[.creationDate]
            let size = atributes[.size]
            let mb = Float(String(describing: size!))! / 1000000

            jpegFiles.append(Document(image: image ?? UIImage(),
                                      dateCreated: String(describing: date) ,
                                      size: "Size: \(String(describing: mb)) Mb",
                                      path: file.path))
        }

    }


}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jpegFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        cell.configCell(jpegFiles[indexPath.row])
        return cell
    }




}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let file = jpegFiles[indexPath.row].path

        if editingStyle == .delete {
            manager.remove(file) {
                self.jpegFiles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }


}

// MARK: - UIImagePickerControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @objc private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            manager.createFile(image) {
                self.getFiles()
                self.tableView.reloadData()
            }
        }
        picker.dismiss(animated: true)
    }

}

