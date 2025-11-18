//
//  ChatViewController.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import UIKit

class ChatViewController: UIViewController {

    private let lesson: Lesson
    private let aiService: AIServiceProtocol
    private var messages: [ChatMessage] = []

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        table.keyboardDismissMode = .interactive
        return table
    }()

    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "質問を入力..."
        textField.font = .systemFont(ofSize: 16)
        textField.returnKeyType = .send
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var sendButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "paperplane.fill")
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemBlue

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private var inputContainerBottomConstraint: NSLayoutConstraint!

    init(lesson: Lesson, aiService: AIServiceProtocol = GeminiService()) {
        self.lesson = lesson
        self.aiService = aiService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        addWelcomeMessage()

        // pushで表示するので閉じるボタンは不要
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        // キーボードが出ていない場合のみSafeAreaを反映
        if inputTextField.isFirstResponder == false {
            inputContainerBottomConstraint.constant = -view.safeAreaInsets.bottom
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    private func setupUI() {
        title = "AIアシスタント"
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(inputTextField)
        inputContainerView.addSubview(sendButton)
        inputContainerView.addSubview(activityIndicator)

        inputContainerBottomConstraint = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)

        NSLayoutConstraint.activate([
            // TableView
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),

            // InputContainer
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerBottomConstraint,
            inputContainerView.heightAnchor.constraint(equalToConstant: 60),

            // TextField
            inputTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: 40),

            // SendButton
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40),

            // ActivityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor)
        ])
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        // キーボードの高さをそのまま使う（view.bottomAnchorに対する制約なので）
        inputContainerBottomConstraint.constant = -keyboardFrame.height

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        // キーボードが消えたらSafeArea分だけ上に（ホームインジケーターを避ける）
        inputContainerBottomConstraint.constant = -view.safeAreaInsets.bottom

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func addWelcomeMessage() {
        let welcomeText = """
        こんにちは！「\(lesson.title)」について、わからないことがあれば何でも質問してください。
        """
        let welcomeMessage = ChatMessage(role: .assistant, content: welcomeText)
        messages.append(welcomeMessage)
        tableView.reloadData()
    }

    private func buildLessonContext() -> String {
        var context = """
        タイトル: \(lesson.title)
        サブタイトル: \(lesson.subtitle)
        概要: \(lesson.summary)

        学習内容:
        """

        for (index, step) in lesson.steps.enumerated() {
            context += "\n\n【\(index + 1). \(step.title)】"
            context += "\n\(step.body)"

            if let paragraphs = step.paragraphs {
                for paragraph in paragraphs {
                    if let title = paragraph.title {
                        context += "\n\n\(title)"
                    }
                    context += "\n\(paragraph.body)"
                }
            }
        }

        return context
    }

    @objc private func sendButtonTapped() {
        sendMessage()
    }

    private func sendMessage() {
        guard let text = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }

        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)

        inputTextField.text = ""
        sendButton.isHidden = true
        activityIndicator.startAnimating()
        tableView.reloadData()
        scrollToBottom()

        let context = buildLessonContext()
        aiService.sendMessage(text, context: context) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.sendButton.isHidden = false
                self.activityIndicator.stopAnimating()

                switch result {
                case .success(let responseText):
                    let assistantMessage = ChatMessage(role: .assistant, content: responseText)
                    self.messages.append(assistantMessage)
                    self.tableView.reloadData()
                    self.scrollToBottom()

                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    private func handleError(_ error: GeminiError) {
        var message = ""

        switch error {
        case .invalidAPIKey:
            message = "APIキーが設定されていません。Config/APIKey.swift を作成してGemini APIキーを設定してください。"
        case .networkError:
            message = "ネットワークエラーが発生しました。インターネット接続を確認してください。"
        case .invalidResponse:
            message = "APIからの応答が不正です。"
        case .decodingError:
            message = "応答の解析に失敗しました。"
        case .apiError(let apiMessage):
            message = "APIエラー: \(apiMessage)"
        }

        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: 0, section: messages.count - 1)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatMessageCell.identifier,
            for: indexPath
        ) as? ChatMessageCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.section]
        cell.configure(with: message)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
