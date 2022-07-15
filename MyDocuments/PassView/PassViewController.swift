//
//  PassViewController.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 08.07.2022.
//

import UIKit
import Security


class PassViewController: UIViewController {

    let service = "myDocuments"
    let user = "userKeychain"

    var state: AuthState = .hasPassword
    var isChange: Bool
    private let keychain = KeychainManager()
    private var tempPassword: String?
    private var passwordFromKeychain: String?

    private lazy var loginScrollView: UIScrollView = {
        let loginScrollView = UIScrollView()
        return loginScrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()

    private lazy var passwordTF: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.leftViewMode = .always
        password.placeholder = "Enter the password"
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.25
        password.layer.cornerRadius = 10
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: password.frame.height))
        password.isSecureTextEntry = true
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.returnKeyType = .done
        password.autocorrectionType = .no
        password.autocapitalizationType = .none
        password.addTarget(self, action: #selector(stateButton), for: .editingChanged)
        return password
    }()

    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = .gray
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.isEnabled = true
        loginButton.alpha = 0.5
        return loginButton
    }()

    init(isChange: Bool ) {
        self.isChange = isChange
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isChange {
            resetPassword()
            state = .newUser
            stateTitleButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        setupConstraints()
        checkPassword()
        stateIsNewUser()
        stateTitleButton()
    }

   func checkPassword(){
       do {
           passwordFromKeychain = try keychain.get(credentialsGet: service)
           print(passwordFromKeychain as Any)
       } catch {
           print("error")
       }

    }

    private func resetPassword() {
        guard let tempPassword = passwordFromKeychain else { return }
        do {
            try keychain.update(credentials: Credentials(user: self.user, service: self.service, password: tempPassword))
        } catch {
            showError(message: "\(error)")
        }
    }

    private func savePassword(_ password: String?) {
        guard let passwordText = password else { return }
        do {
            try keychain.save(credentials: Credentials(user: self.user, service: self.service, password: passwordText))
        } catch {
            print(error)
        }
    }

    private func stateTitleButton() {
        switch state{
        case .newUser:
            loginButton.setTitle("Создать пароль", for: .normal)
        case .hasPassword:
            loginButton.setTitle("Введите пароль", for: .normal)
        case .createPassword:
            loginButton.setTitle("Повторите пароль", for: .normal)
        }
    }

    private func stateIsNewUser() {
        if passwordFromKeychain == nil {
            state = .newUser
        } else {
            state = .hasPassword
        }
    }

    @objc private func pressButton() {
        switch state {
        case .newUser:
            tempPassword = passwordTF.text
            passwordTF.text = ""
            state = .createPassword
            stateTitleButton()
        case .hasPassword:
                checkPassword()
                if passwordFromKeychain == passwordTF.text {
                    DispatchQueue.main.async {
                        self.pushTabBar()
                        print("success")
                    }
            } else {
                showError(message: "Пароль не верный")
            }
        case .createPassword:
            if passwordTF.text == tempPassword {
                savePassword(passwordTF.text)
                state = .hasPassword
                passwordTF.text = ""
                stateTitleButton()
                if isChange {
                    isChange = false
                    dismiss(animated: true)
                }
            } else {
                showError(message: "Пароли не совпадают")
                state = .newUser
                passwordTF.text = ""
                stateTitleButton()

            }
        }

    }

    @objc private func stateButton() {
        guard let password = passwordTF.text else { return }
        loginButton.alpha = password.count >= 4 ? 1.0 : 0.5
        loginButton.isEnabled = password.count >= 4 ? true : false
    }


    private func setupConstraints() {
        view.backgroundColor = .white
        contentView.addSubviews(passwordTF, loginButton)
        loginScrollView.addSubviews(contentView)
        view.addSubviews(loginScrollView)

        NSLayoutConstraint.activate([
            loginScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: loginScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: loginScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: loginScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: loginScrollView.leadingAnchor),
            contentView.centerXAnchor.constraint(equalTo: loginScrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: loginScrollView.centerYAnchor),

            passwordTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTF.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200),
            passwordTF.heightAnchor.constraint(equalToConstant: 50),

            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

        ])
    }

}




extension PassViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !string.contains(where: {$0 == " " || $0 == "#"})
    }
}


extension PassViewController {

    private func showError(message: String) {
        let alert = UIAlertController(title: "Внимание",
                                     message: message,
                                     preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

     func pushTabBar() {
         let tabBar = MainTabBarController()
    
         self.navigationController?.pushViewController(tabBar, animated: true)
    }



}



