//
//  StepImageCell.swift
//  StatEase-UIKit
//
//  Created by Claude Code - Week 2
//

import UIKit

class StepImageCell: UITableViewCell {
    static let identifier = "StepImageCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var imageHeightConstraint: NSLayoutConstraint?

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
        containerView.addSubview(contentLabel)
        containerView.addSubview(stepImageView)

        imageHeightConstraint = stepImageView.heightAnchor.constraint(equalToConstant: 200)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            stepImageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            stepImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stepImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stepImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            imageHeightConstraint!
        ])
    }

    func configure(with step: Step) {
        titleLabel.text = step.title
        contentLabel.text = step.content

        // タイトルがない場合は非表示
        titleLabel.isHidden = step.title == nil || step.title?.isEmpty == true

        // 画像を読み込み
        if let imageName = step.imageName {
            stepImageView.image = UIImage(named: imageName)

            // 画像が存在しない場合はプレースホルダー
            if stepImageView.image == nil {
                stepImageView.backgroundColor = .systemGray5
            }
        } else {
            stepImageView.image = nil
            stepImageView.backgroundColor = .systemGray5
        }
    }
}
