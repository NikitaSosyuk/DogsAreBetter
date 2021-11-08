//
//  RootViewController.swift
//  DogsAreBetter
//
//  Created by Nikita Sosyuk on 08.11.2021.
//

import UIKit
import Combine
import SnapKit

final class RootViewController: UIViewController {

    enum Constants {
        static let moreButtonHeight: CGFloat = 40
        static let scoreLabelHeight: CGFloat = 46
        static let buttonCornerRadius: CGFloat = 20
        static let contentViewHeight: CGFloat = 205
        static let contentViewsBorderWidth: CGFloat = 1
        static let contentViewsCornerRadius: CGFloat = 10

        // ЛОЛ 🙂
        static let contentInsets = UIEdgeInsets(top: 41, left: 19, bottom: 18, right: 12.63)
        static let segmentControlInsets = UIEdgeInsets(top: 27, left: 95, bottom: 41, right: 84)
        static let moreButtonInsets = UIEdgeInsets(top: 12.63, left: 121, bottom: 19, right: 110)
        static let scoreLabelInsets = UIEdgeInsets(top: 19, left: 22, bottom: 0, right: 38)
    }

    // MARK: - Private Properties

    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Cats", "Dogs"])
        segment.selectedSegmentIndex = 0

        return segment
    }()

    private let contentTextView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = Constants.contentViewsBorderWidth
        view.layer.cornerRadius = Constants.contentViewsCornerRadius
        return view
    }()

    private let contentImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = false
        view.layer.borderWidth = Constants.contentViewsBorderWidth
        view.layer.cornerRadius = Constants.contentViewsCornerRadius
        return view
    }()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("More", for: .normal)
        button.backgroundColor = .moreButtonColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        return button
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private var cancellable = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviews()
        self.setupConstraints()
        self.setupNavigationBar()
        self.view.backgroundColor = .white
    }

    // MARK: - Private Methods

    private func addSubviews() {
        self.view.addSubview(moreButton)
        self.view.addSubview(contentTextView)
        self.view.addSubview(segmentedControl)
        self.view.addSubview(contentImageView)
        self.view.addSubview(scoreLabel)
    }

    private func setupConstraints() {
        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.segmentControlInsets.top)
            make.leading.equalToSuperview().offset(Constants.segmentControlInsets.left)
            make.trailing.equalToSuperview().inset(Constants.segmentControlInsets.right)
        }

        self.contentImageView.snp.makeConstraints { make in
            make.height.equalTo(Constants.contentViewHeight)
            make.leading.equalToSuperview().offset(Constants.contentInsets.left)
            make.trailing.equalToSuperview().inset(Constants.contentInsets.right)
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(Constants.contentInsets.top)
        }

        self.contentTextView.snp.makeConstraints { make in
            make.height.equalTo(Constants.contentViewHeight)
            make.leading.equalToSuperview().offset(Constants.contentInsets.left)
            make.trailing.equalToSuperview().inset(Constants.contentInsets.right)
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(Constants.contentInsets.top)
        }

        self.moreButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.moreButtonHeight)
            make.leading.equalToSuperview().offset(Constants.moreButtonInsets.left)
            make.trailing.equalToSuperview().inset(Constants.moreButtonInsets.right)
            make.top.equalTo(contentImageView.snp.bottom).offset(13)
        }

        self.scoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.scoreLabelInsets.left)
            make.trailing.equalToSuperview().inset(Constants.scoreLabelInsets.right)
            make.top.equalTo(self.moreButton.snp.bottom).offset(Constants.scoreLabelInsets.top)
        }
    }

    private func setupNavigationBar() {
        self.title = "Cats and dogs"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

