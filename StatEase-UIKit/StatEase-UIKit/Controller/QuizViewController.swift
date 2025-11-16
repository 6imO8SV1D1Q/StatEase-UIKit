//
//  QuizViewController.swift
//  StatEase-UIKit
//
//  Created by Claude Code - Week 2
//

import UIKit

class QuizViewController: UIViewController {

    private let quiz: Quiz
    private let lessonId: String
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var isAnswered: Bool = false

    private lazy var questionNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var optionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var explanationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var explanationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nextButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "次へ"
        config.cornerStyle = .medium
        config.baseBackgroundColor = .systemBlue

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(quiz: Quiz, lessonId: String) {
        self.quiz = quiz
        self.lessonId = lessonId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayQuestion()
    }

    private func setupUI() {
        title = quiz.title
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(questionNumberLabel)
        contentView.addSubview(questionLabel)
        contentView.addSubview(optionsStackView)
        contentView.addSubview(explanationContainerView)

        explanationContainerView.addSubview(explanationTitleLabel)
        explanationContainerView.addSubview(explanationLabel)

        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            questionNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            questionNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 12),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            optionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            explanationContainerView.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 24),
            explanationContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            explanationContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            explanationContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            explanationTitleLabel.topAnchor.constraint(equalTo: explanationContainerView.topAnchor, constant: 16),
            explanationTitleLabel.leadingAnchor.constraint(equalTo: explanationContainerView.leadingAnchor, constant: 16),
            explanationTitleLabel.trailingAnchor.constraint(equalTo: explanationContainerView.trailingAnchor, constant: -16),

            explanationLabel.topAnchor.constraint(equalTo: explanationTitleLabel.bottomAnchor, constant: 8),
            explanationLabel.leadingAnchor.constraint(equalTo: explanationContainerView.leadingAnchor, constant: 16),
            explanationLabel.trailingAnchor.constraint(equalTo: explanationContainerView.trailingAnchor, constant: -16),
            explanationLabel.bottomAnchor.constraint(equalTo: explanationContainerView.bottomAnchor, constant: -16),

            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func displayQuestion() {
        guard currentQuestionIndex < quiz.questions.count else {
            showResults()
            return
        }

        let question = quiz.questions[currentQuestionIndex]
        isAnswered = false

        questionNumberLabel.text = "問題 \(currentQuestionIndex + 1) / \(quiz.questions.count)"
        questionLabel.text = question.prompt

        // 選択肢をクリア
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 選択肢ボタンを作成
        for choice in question.choices {
            let button = createOptionButton(for: choice)
            optionsStackView.addArrangedSubview(button)
        }

        // 解説を非表示
        explanationContainerView.isHidden = true
        nextButton.isHidden = true
    }

    private func createOptionButton(for option: QuizChoice) -> UIButton {
        var config = UIButton.Configuration.bordered()
        config.title = option.text
        config.cornerStyle = .medium
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .secondarySystemGroupedBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        config.titleAlignment = .leading
        config.titleLineBreakMode = .byWordWrapping

        let button = UIButton(configuration: config)
        button.tag = option.isCorrect ? 1 : 0
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    @objc private func optionButtonTapped(_ sender: UIButton) {
        guard !isAnswered else { return }

        isAnswered = true
        let isCorrect = sender.tag == 1

        if isCorrect {
            correctAnswers += 1
            sender.configuration?.baseBackgroundColor = .systemGreen
            sender.configuration?.baseForegroundColor = .white
            explanationTitleLabel.text = "正解！"
            explanationTitleLabel.textColor = .systemGreen
        } else {
            sender.configuration?.baseBackgroundColor = .systemRed
            sender.configuration?.baseForegroundColor = .white
            explanationTitleLabel.text = "不正解"
            explanationTitleLabel.textColor = .systemRed

            // 正解の選択肢を緑色に
            for view in optionsStackView.arrangedSubviews {
                if let button = view as? UIButton, button.tag == 1 {
                    button.configuration?.baseBackgroundColor = .systemGreen
                    button.configuration?.baseForegroundColor = .white
                }
            }
        }

        // すべてのボタンを無効化
        for view in optionsStackView.arrangedSubviews {
            if let button = view as? UIButton {
                button.isEnabled = false
            }
        }

        // 解説を表示
        let question = quiz.questions[currentQuestionIndex]
        explanationLabel.text = question.explanation
        explanationContainerView.isHidden = false
        nextButton.isHidden = false
    }

    @objc private func nextButtonTapped() {
        currentQuestionIndex += 1
        displayQuestion()
    }

    private func showResults() {
        let score = (correctAnswers * 100) / quiz.questions.count
        let percentage = "\(correctAnswers) / \(quiz.questions.count)"

        // 進捗を保存
        var progress = UserDefaultsStore.shared.fetchProgress(for: lessonId) ?? UserProgressRecord(lessonId: lessonId)
        progress.quizScore = score
        progress.isCompleted = true
        UserDefaultsStore.shared.saveProgress(progress)

        let alert = UIAlertController(
            title: "クイズ完了！",
            message: "正解数: \(percentage)\nスコア: \(score)点",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
