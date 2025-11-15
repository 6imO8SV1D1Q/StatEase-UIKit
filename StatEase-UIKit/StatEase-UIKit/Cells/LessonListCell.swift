//
//  LessonListCell.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import UIKit

class LessonListCell: UITableViewCell {
    static let identifier = "LessonListCell"

    // UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let completionBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(difficultyLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(completionBadge)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: completionBadge.leadingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            difficultyLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            difficultyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            difficultyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),

            timeLabel.leadingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor, constant: 12),
            timeLabel.centerYAnchor.constraint(equalTo: difficultyLabel.centerYAnchor),

            completionBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            completionBadge.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }

    func configure(with lesson: Lesson, isCompleted: Bool) {
        titleLabel.text = lesson.title
        descriptionLabel.text = lesson.description
        difficultyLabel.text = lesson.difficulty
        timeLabel.text = "\(lesson.estimatedMinutes)分"
        completionBadge.text = isCompleted ? "✓" : ""
    }
}
