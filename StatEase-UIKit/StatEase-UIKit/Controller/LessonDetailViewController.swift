//
//  LessonDetailViewController.swift
//  StatEase-UIKit
//
//  Created by Claude Code - Week 2
//

import UIKit

class LessonDetailViewController: UIViewController {

    private let lesson: Lesson
    private var currentStepIndex: Int = 0
    private var completedStepIds: Set<String> = []

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .systemGroupedBackground
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false

        // セルの登録
        table.register(StepTextCell.self, forCellReuseIdentifier: StepTextCell.identifier)
        table.register(StepImageCell.self, forCellReuseIdentifier: StepImageCell.identifier)
        table.register(StepVideoCell.self, forCellReuseIdentifier: StepVideoCell.identifier)

        return table
    }()

    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progressTintColor = .systemBlue
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var quizButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "確認問題に挑戦"
        config.cornerStyle = .medium
        config.baseBackgroundColor = .systemBlue

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(quizButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProgress()
        updateProgress()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveProgress()
    }

    private func setupUI() {
        title = lesson.title
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(progressView)
        view.addSubview(progressLabel)
        view.addSubview(tableView)
        view.addSubview(quizButton)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 4),

            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: quizButton.topAnchor, constant: -8),

            quizButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quizButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            quizButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            quizButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func loadProgress() {
        if let progress = UserDefaultsStore.shared.fetchProgress(for: lesson.id) {
            completedStepIds = progress.completedSteps
        }
    }

    private func saveProgress() {
        var progress = UserDefaultsStore.shared.fetchProgress(for: lesson.id) ?? UserProgress(lessonId: lesson.id)
        progress.completedSteps = completedStepIds
        progress.isCompleted = completedStepIds.count == lesson.steps.count
        progress.lastAccessedDate = Date()

        UserDefaultsStore.shared.saveProgress(progress)
    }

    private func updateProgress() {
        let totalSteps = lesson.steps.count
        let completedSteps = completedStepIds.count
        let progressValue = totalSteps > 0 ? Float(completedSteps) / Float(totalSteps) : 0

        progressView.setProgress(progressValue, animated: true)
        progressLabel.text = "\(completedSteps) / \(totalSteps) ステップ完了"

        // すべてのステップが完了したらクイズボタンを表示
        if completedSteps == totalSteps && lesson.quizId != nil {
            quizButton.isHidden = false
        }
    }

    @objc private func quizButtonTapped() {
        guard let quizId = lesson.quizId else { return }

        let result = QuizRepository.shared.fetchQuiz(by: quizId)
        switch result {
        case .success(let quiz):
            let quizVC = QuizViewController(quiz: quiz, lessonId: lesson.id)
            navigationController?.pushViewController(quizVC, animated: true)
        case .failure(let error):
            print("Failed to load quiz: \(error)")
            showErrorAlert(message: "クイズの読み込みに失敗しました")
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension LessonDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson.steps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let step = lesson.steps[indexPath.row]

        switch step.type {
        case .text, .formula:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StepTextCell.identifier,
                for: indexPath
            ) as? StepTextCell else {
                return UITableViewCell()
            }
            cell.configure(with: step)
            return cell

        case .image:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StepImageCell.identifier,
                for: indexPath
            ) as? StepImageCell else {
                return UITableViewCell()
            }
            cell.configure(with: step)
            return cell

        case .video:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StepVideoCell.identifier,
                for: indexPath
            ) as? StepVideoCell else {
                return UITableViewCell()
            }
            cell.configure(with: step)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension LessonDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // スクロール完了検知
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let step = lesson.steps[indexPath.row]

                // セルが完全に表示されたらステップを完了としてマーク
                let cellRect = tableView.rectForRow(at: indexPath)
                let visibleRect = scrollView.bounds

                if visibleRect.contains(cellRect) {
                    if !completedStepIds.contains(step.id) {
                        completedStepIds.insert(step.id)
                        updateProgress()
                    }
                }
            }
        }
    }
}
