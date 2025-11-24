//
//  LessonDetailViewController.swift
//  StatEase-UIKit
//
//  Created by Claude Code - Week 2
//

import UIKit

class LessonDetailViewController: UIViewController {

    private let lesson: Lesson
    private let quizRepository: QuizRepositoryProtocol
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

    private lazy var chatButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "message.fill")
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemBlue

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        return button
    }()

    init(lesson: Lesson, quizRepository: QuizRepositoryProtocol = QuizRepository()) {
        self.lesson = lesson
        self.quizRepository = quizRepository
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
        view.addSubview(chatButton)

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
            quizButton.heightAnchor.constraint(equalToConstant: 50),

            chatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            chatButton.widthAnchor.constraint(equalToConstant: 56),
            chatButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func loadProgress() {
        if let progress = UserDefaultsStore.shared.fetchProgress(for: lesson.id) {
            completedStepIds = progress.completedSteps
        }
    }

    private func saveProgress() {
        var progress = UserDefaultsStore.shared.fetchProgress(for: lesson.id) ?? UserProgressRecord(lessonId: lesson.id)
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

        let hasQuiz = lesson.quizId != nil
        let shouldShowQuiz = completedSteps == totalSteps && hasQuiz
        quizButton.isHidden = !shouldShowQuiz
    }

    @objc private func quizButtonTapped() {
        guard let quizId = lesson.quizId else {
            showErrorAlert(message: "このレッスンに対応するクイズが見つかりません。")
            return
        }

        do {
            if let quiz = try quizRepository.fetchQuiz(id: quizId) {
                let quizVC = QuizViewController(quiz: quiz, lessonId: lesson.id)
                navigationController?.pushViewController(quizVC, animated: true)
            } else {
                showErrorAlert(message: "クイズデータが見つかりません。")
            }
        } catch {
            print("Failed to load quiz: \(error)")
            showErrorAlert(message: "クイズの読み込みに失敗しました")
        }
    }

    @objc private func chatButtonTapped() {
        let chatVC = ChatViewController(lesson: lesson)
        navigationController?.pushViewController(chatVC, animated: true)
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
        return lesson.steps.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let step = lesson.steps[indexPath.section]

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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGroupedBackground

        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = lesson.steps[section].title

        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16)
        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // スクロール完了検知
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let step = lesson.steps[indexPath.section]

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
