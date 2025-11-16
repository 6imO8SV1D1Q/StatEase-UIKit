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
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .systemOrange
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
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
        contentView.addSubview(durationLabel)
        contentView.addSubview(completionIcon)

        NSLayoutConstraint.activate([
            // 所要時間ラベル（タイトルの右側）
            durationLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: completionIcon.leadingAnchor, constant: -8),
            durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            durationLabel.heightAnchor.constraint(equalToConstant: 20),

            // タイトルラベル
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -8),

            // 説明ラベル
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

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
        descriptionLabel.text = lesson.subtitle
        durationLabel.text = "\(lesson.estimatedMinutes)分"
        completionIcon.isHidden = !isCompleted
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        durationLabel.text = nil
        completionIcon.isHidden = true
    }
}
