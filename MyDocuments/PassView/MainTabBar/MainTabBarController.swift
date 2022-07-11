//
//  MainTabBarController.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 10.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    private lazy var documentsNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: DocumentsViewController())
        navigation.tabBarItem = UITabBarItem(
            title: "Documents",
            image: UIImage(systemName: "doc.on.doc"),
            selectedImage: UIImage(systemName: "doc.on.doc.fill"))
        navigation.navigationBar.topItem?.title = "My documents"
        return navigation
    }()

    private lazy var settingsNC: UINavigationController = {
        let navigation = UINavigationController(rootViewController: SettingsViewController())
        navigation.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape.2"),
            selectedImage: UIImage(systemName: "gearshape.2.fill"))
        navigation.navigationBar.topItem?.title = "Settings"
        return navigation
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemBlue
        viewControllers = [documentsNC, settingsNC]
    }

}
