//
//  StepTextCell.swift
//  StatEase-UIKit
//
//  Created by Claude Code - Week 2
//

import UIKit

class StepTextCell: UITableViewCell {
    static let identifier = "StepTextCell"

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        containerView.addSubview(contentLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            contentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with step: Step) {
        if let attributedParagraphs = makeParagraphs(from: step) {
            contentLabel.attributedText = attributedParagraphs
            return
        }

        if let markdown = makeMarkdown(from: step.body) {
            contentLabel.attributedText = markdown
        } else {
            contentLabel.text = step.body
        }
    }

    private func makeParagraphs(from step: Step) -> NSAttributedString? {
        guard let paragraphs = step.paragraphs, !paragraphs.isEmpty else {
            return nil
        }

        let attributed = NSMutableAttributedString()
        let bodyFont = UIFont.systemFont(ofSize: 16)
        let titleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)

        for (index, paragraph) in paragraphs.enumerated() {
            if let title = paragraph.title, !title.isEmpty {
                let titleText = NSAttributedString(
                    string: title + "\n",
                    attributes: [
                        .font: titleFont,
                        .foregroundColor: UIColor.label
                    ]
                )
                attributed.append(titleText)
            }

            let bodyText = NSAttributedString(
                string: paragraph.body,
                attributes: [
                    .font: bodyFont,
                    .foregroundColor: UIColor.label
                ]
            )
            attributed.append(bodyText)

            if index < paragraphs.count - 1 {
                attributed.append(NSAttributedString(string: "\n\n"))
            }
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.paragraphSpacing = 10
        attributed.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributed.length)
        )
        return attributed
    }

    private func makeMarkdown(from text: String) -> NSAttributedString? {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        var options = AttributedString.MarkdownParsingOptions()
        options.interpretedSyntax = .full

        guard let attributed = try? AttributedString(markdown: text, options: options) else {
            return nil
        }

        let mutable = NSMutableAttributedString(attributedString: NSAttributedString(attributed))
        let range = NSRange(location: 0, length: mutable.length)
        mutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: range)
        mutable.addAttribute(.foregroundColor, value: UIColor.label, range: range)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.paragraphSpacing = 10
        mutable.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return mutable
    }
}
