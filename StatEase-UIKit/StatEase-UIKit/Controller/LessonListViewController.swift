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
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        return table
    }()

    private let lessonRepository: LessonRepositoryProtocol
    private let userProgress = UserProgress.shared

    private var lessons: [Lesson] = []
    private var groupedLessons: [(category: String, lessons: [Lesson])] = []
    private var expandedSections: Set<String> = [] // 開いているセクション（category）

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
            lessons.sort { $0.id < $1.id }

            // category（大項目）ごとにグループ化
            let grouped = Dictionary(grouping: lessons, by: { $0.category })
            groupedLessons = grouped.sorted { categoryOrder($0.key) < categoryOrder($1.key) }
                .map { ($0.key, $0.value.sorted { $0.id < $1.id }) }

            // 全セクションを開いた状態にする
            expandedSections = Set(groupedLessons.map { $0.category })

            tableView.reloadData()
        } catch {
            showError(error)
        }
    }

    // カテゴリの並び順を定義
    private func categoryOrder(_ category: String) -> Int {
        let order = [
            "data_source", "data_distribution", "central_tendency", "dispersion", "center_dispersion_app",
            "scatter_correlation", "categorical_data", "regression_simple", "timeseries",
            "observation_experiment",
            "probability", "random_variable", "probability_distribution", "sampling_distribution",
            "inference_1pop", "inference_2pop", "chi_square_test",
            "regression_multiple", "experimental_design",
            "statistical_software"
        ]
        return order.firstIndex(of: category) ?? Int.max
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedLessons.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = groupedLessons[section].category
        // セクションが開いている場合のみ行を表示
        return expandedSections.contains(category) ? groupedLessons[section].lessons.count : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = groupedLessons[section].category
        let isExpanded = expandedSections.contains(category)

        let headerView = UIView()
        headerView.backgroundColor = .systemGroupedBackground

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = section
        button.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = categoryTitle(for: category)
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .secondaryLabel

        let chevronImageView = UIImageView()
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.image = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right")
        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.contentMode = .scaleAspectFit

        button.addSubview(titleLabel)
        button.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])

        headerView.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    @objc private func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        let category = groupedLessons[section].category

        if expandedSections.contains(category) {
            expandedSections.remove(category)
        } else {
            expandedSections.insert(category)
        }

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LessonListCell.reuseIdentifier,
            for: indexPath
        ) as? LessonListCell else {
            return UITableViewCell()
        }

        let lesson = groupedLessons[indexPath.section].lessons[indexPath.row]
        let isCompleted = userProgress.isLessonCompleted(lessonId: lesson.id)

        cell.configure(with: lesson, isCompleted: isCompleted)
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    private func categoryTitle(for category: String) -> String {
        switch category {
        // 1変数データ
        case "data_source":
            return "データソース"
        case "data_distribution":
            return "データの分布"
        case "central_tendency":
            return "中心傾向の指標"
        case "dispersion":
            return "散らばりなどの指標"
        case "center_dispersion_app":
            return "中心と散らばりの活用"

        // 2変数以上のデータ
        case "scatter_correlation":
            return "散布図と相関"
        case "categorical_data":
            return "カテゴリカルデータ"
        case "regression_simple":
            return "単回帰と予測"
        case "timeseries":
            return "時系列データの処理"

        // 推測のためのデータ収集法
        case "observation_experiment":
            return "観察研究と実験研究"

        // 確率モデルの導入
        case "probability":
            return "確率"
        case "random_variable":
            return "確率変数"
        case "probability_distribution":
            return "確率分布"
        case "sampling_distribution":
            return "推測統計の基礎"

        // 推測
        case "inference_1pop":
            return "推定・検定（1母集団）"
        case "inference_2pop":
            return "推定・検定（2母集団）"
        case "chi_square_test":
            return "適合度検定と独立性の検定"

        // 線形モデル
        case "regression_multiple":
            return "回帰分析（重回帰含む）"
        case "experimental_design":
            return "実験計画法"

        // 活用
        case "statistical_software":
            return "統計ソフトウェアの活用"

        default:
            return category
        }
    }
}

// MARK: - UITableViewDelegate

extension LessonListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let lesson = groupedLessons[indexPath.section].lessons[indexPath.row]

        // レッスン詳細画面への遷移
        let detailVC = LessonDetailViewController(lesson: lesson)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
