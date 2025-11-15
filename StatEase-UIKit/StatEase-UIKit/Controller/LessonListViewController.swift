//
//  LessonListViewController.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import UIKit

/// レッスン一覧画面
class LessonListViewController: UIViewController {

    // MARK: - Properties

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        return table
    }()

    private let lessonRepository: LessonRepositoryProtocol
    private let userProgress = UserProgress.shared

    private var lessons: [Lesson] = []

    // MARK: - Initialization

    init(lessonRepository: LessonRepositoryProtocol = LessonRepository()) {
        self.lessonRepository = lessonRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.lessonRepository = LessonRepository()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadLessons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面が表示されるたびにテーブルを更新（完了状態の反映のため）
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "StatEase"
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonListCell.self, forCellReuseIdentifier: LessonListCell.reuseIdentifier)
    }

    // MARK: - Data Loading

    private func loadLessons() {
        do {
            lessons = try lessonRepository.fetchAllLessons()
            // 章ごと、または ID でソート（必要に応じて）
            lessons.sort { $0.id < $1.id }
            tableView.reloadData()
        } catch {
            showError(error)
        }
    }

    // MARK: - Error Handling

    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "エラー",
            message: "レッスンの読み込みに失敗しました。\n\(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension LessonListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LessonListCell.reuseIdentifier,
            for: indexPath
        ) as? LessonListCell else {
            return UITableViewCell()
        }

        let lesson = lessons[indexPath.row]
        let isCompleted = userProgress.isLessonCompleted(lessonId: lesson.id)

        cell.configure(with: lesson, isCompleted: isCompleted)
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate

extension LessonListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let lesson = lessons[indexPath.row]

        // レッスン詳細画面への遷移（Week 2で実装）
        let detailVC = LessonDetailViewController(lesson: lesson)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
