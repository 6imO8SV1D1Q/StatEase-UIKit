//
//  StepImageCell.swift
//  StatEase-UIKit
//
//  Created by Claude Code - Week 2
//

import UIKit

class StepImageCell: UITableViewCell {
    static let identifier = "StepImageCell"

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
        containerView.addSubview(contentLabel)
        containerView.addSubview(stepImageView)

        imageHeightConstraint = stepImageView.heightAnchor.constraint(equalToConstant: 200)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            contentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
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
        if let markdown = makeMarkdown(from: step.body) {
            contentLabel.attributedText = markdown
        } else {
            contentLabel.text = step.body
        }

        if let media = step.media, media.type == "image" {
            let image = loadImage(named: media.assetName) ?? placeholderImage(for: media.assetName)
            stepImageView.image = image
            stepImageView.isHidden = (image == nil)
            imageHeightConstraint?.constant = image == nil ? 0 : 220
            stepImageView.backgroundColor = image == nil ? .systemGray5 : .clear
        } else {
            stepImageView.image = nil
            stepImageView.backgroundColor = .systemGray5
            stepImageView.isHidden = true
            imageHeightConstraint?.constant = 0
        }
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

    private func loadImage(named assetName: String) -> UIImage? {
        if let image = UIImage(named: assetName) {
            return image
        }

        let ext = (assetName as NSString).pathExtension
        let baseName = (assetName as NSString).deletingPathExtension

        if let urls = Bundle.main.urls(forResourcesWithExtension: ext.isEmpty ? nil : ext, subdirectory: "content") {
            if let matched = urls.first(where: { $0.lastPathComponent == assetName }) {
                return UIImage(contentsOfFile: matched.path)
            }
        }

        if let url = Bundle.main.url(forResource: baseName, withExtension: ext) {
            return UIImage(contentsOfFile: url.path)
        }

        return nil
    }

    private func placeholderImage(for assetName: String) -> UIImage? {
        let size = CGSize(width: 600, height: 320)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.secondarySystemBackground.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
                .foregroundColor: UIColor.label
            ]

            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]

            let title = "図版がまだ登録されていません"
            let subtitle = assetName

            let titleSize = title.size(withAttributes: titleAttributes)
            let subtitleSize = subtitle.size(withAttributes: subtitleAttributes)

            let totalHeight = titleSize.height + 8 + subtitleSize.height
            let startY = (size.height - totalHeight) / 2

            title.draw(
                at: CGPoint(x: (size.width - titleSize.width) / 2, y: startY),
                withAttributes: titleAttributes
            )

            subtitle.draw(
                at: CGPoint(x: (size.width - subtitleSize.width) / 2, y: startY + titleSize.height + 8),
                withAttributes: subtitleAttributes
            )
        }
    }
}
