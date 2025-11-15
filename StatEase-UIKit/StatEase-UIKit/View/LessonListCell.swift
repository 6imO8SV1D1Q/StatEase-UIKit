//
//  LessonListCell.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import UIKit

/// レッスン一覧のセル
class LessonListCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "LessonListCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let completionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(difficultyLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(completionIcon)

        NSLayoutConstraint.activate([
            // タイトルラベル
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: completionIcon.leadingAnchor, constant: -8),

            // 説明ラベル
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // 難易度ラベル
            difficultyLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            difficultyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            difficultyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            // 所要時間ラベル
            durationLabel.leadingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor, constant: 12),
            durationLabel.centerYAnchor.constraint(equalTo: difficultyLabel.centerYAnchor),

            // 完了アイコン
            completionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completionIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completionIcon.widthAnchor.constraint(equalToConstant: 24),
            completionIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // MARK: - Configuration

    /// セルを設定する
    /// - Parameters:
    ///   - lesson: レッスンデータ
    ///   - isCompleted: 完了済みかどうか
    func configure(with lesson: Lesson, isCompleted: Bool) {
        titleLabel.text = lesson.title
        descriptionLabel.text = lesson.description
        difficultyLabel.text = lesson.difficulty
        durationLabel.text = "約\(lesson.durationMinutes)分"
        completionIcon.isHidden = !isCompleted
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        difficultyLabel.text = nil
        durationLabel.text = nil
        completionIcon.isHidden = true
    }
}
