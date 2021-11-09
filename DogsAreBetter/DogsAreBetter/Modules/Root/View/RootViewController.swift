//
//  RootViewController.swift
//  DogsAreBetter
//
//  Created by Nikita Sosyuk on 08.11.2021.
//

import UIKit
import Combine

import SnapKit
import Kingfisher

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

    // MARK: - Internal Properties

    var viewModel: RootViewModel?

    // MARK: - Private Properties

    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Cats", "Dogs"])
        segment.selectedSegmentIndex = 0

        return segment
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "iOS is the best 🥺"
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.layer.borderWidth = Constants.contentViewsBorderWidth
        textView.layer.cornerRadius = Constants.contentViewsCornerRadius
        return textView
    }()

    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = Constants.contentViewsBorderWidth
        imageView.layer.cornerRadius = Constants.contentViewsCornerRadius
        return imageView
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


    @Published
    private var catFact = CatFact(fact: "none.")
    @Published
    private var dogMessage = DogMessage(message: "none.")

    private var cancellableSet = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.addSubviews()
        self.setupConstraints()
        self.setupNavigationBar()
        self.sinkUI()
        self.sinkViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.contentTextView.setCenteredText()
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
            make.top.equalTo(contentImageView.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(Constants.moreButtonInsets.left)
            make.trailing.equalToSuperview().inset(Constants.moreButtonInsets.right)
        }

        self.scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.scoreLabelHeight)
            make.top.equalTo(self.moreButton.snp.bottom).offset(Constants.scoreLabelInsets.top)
        }
    }

    private func setupNavigationBar() {
        self.title = "Cats and dogs"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonAction))

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    private func sinkViewModel() {
        viewModel?.$scores
            .receive(on: DispatchQueue.main)
            .sink { scoreTuple in
                self.scoreLabel.text = "Score: \(scoreTuple.catScore) cats and \(scoreTuple.dogScore) dogs"
            }
            .store(in: &cancellableSet)

        viewModel?.$dog
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {  _ in },
                receiveValue: { dog in
                    guard
                        let dog = dog,
                        let imageURL = URL(string: dog.message)
                    else { return }

                    self.contentImageView.kf.setImage(with: imageURL)
                }
            )
            .store(in: &cancellableSet)

        viewModel?.$cat
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {  _ in },
                receiveValue: { cat in
                    guard let cat = cat else { return }

                    self.contentTextView.text = cat.fact
                    self.contentTextView.setCenteredText()
                }
            )
            .store(in: &cancellableSet)
    }

    private func sinkUI() {
        self.segmentedControl
            .publisher(for: \.selectedSegmentIndex)
            .sink { value in
                switch value {
                case 0:
                    self.viewModel?.downloadCatRandomFact()
                    self.contentTextView.isHidden = false
                    self.contentImageView.isHidden = true
                case 1:
                    self.viewModel?.downloadDogRandomImage()
                    self.contentTextView.isHidden = true
                    self.contentImageView.isHidden = false
                default:
                    break
                }
            }
            .store(in: &cancellableSet)

        self.moreButton.publisher(for: .touchUpInside)
            .sink { _ in
                switch self.segmentedControl.selectedSegmentIndex {
                case 0:
                    self.viewModel?.downloadCatRandomFact()
                case 1:
                    self.viewModel?.downloadDogRandomImage()
                default:
                    break
                }
            }
            .store(in: &cancellableSet)
    }

    @objc private func resetButtonAction() {
        viewModel?.resetScores()
    }
}

