//
//  LessonListViewController.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import UIKit

class LessonListViewController: UIViewController {

    private var lessons: [Lesson] = []
    private var progressMap: [String: UserProgress] = [:]

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemGroupedBackground
        table.delegate = self
        table.dataSource = self
        table.register(LessonListCell.self, forCellReuseIdentifier: LessonListCell.identifier)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProgress()
        tableView.reloadData()
    }

    private func setupUI() {
        title = "StatEase"
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadData() {
        let result = LessonRepository.shared.fetchAllLessons()
        switch result {
        case .success(let fetchedLessons):
            lessons = fetchedLessons
            tableView.reloadData()
        case .failure(let error):
            print("Failed to load lessons: \(error)")
            showErrorAlert()
        }
    }

    private func loadProgress() {
        let allProgress = UserDefaultsStore.shared.fetchAllProgress()
        progressMap = Dictionary(uniqueKeysWithValues: allProgress.map { ($0.lessonId, $0) })
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "エラー",
            message: "レッスンデータの読み込みに失敗しました",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension LessonListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LessonListCell.identifier,
            for: indexPath
        ) as? LessonListCell else {
            return UITableViewCell()
        }

        let lesson = lessons[indexPath.row]
        let isCompleted = progressMap[lesson.id]?.isCompleted ?? false
        cell.configure(with: lesson, isCompleted: isCompleted)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension LessonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lesson = lessons[indexPath.row]
        let detailVC = LessonDetailViewController(lesson: lesson)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
