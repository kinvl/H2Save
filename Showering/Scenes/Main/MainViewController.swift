//
//  MainViewController.swift
//  Showering
//
//  Created by Krzysztof Kinal on 08/10/2021.
//

import UIKit
import ShimmerSwift
import SPPermissions
import OnboardKit

class MainViewController: UIViewController {
    
    private let permissions: [SPPermissions.Permission] = [.microphone]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.H2Save.background
        setupViews()
        setupLayout()
        setupShimmer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupWaterLabels()
        drawChartAndLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        attemptOnboarding()
    }
    
    // MARK: - View controller presentation
    @objc private func presentShowerViewController() {
        let vc = ShowerViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func presentSettingsViewController() {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Views
    lazy var backgroundImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "wave")
        imageview.contentMode = .scaleAspectFill
        
        return imageview
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start shower", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.contrastingAccentColor
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(presentShowerViewController), for: .touchUpInside)
        
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.H2Save.ashenGray
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(presentSettingsViewController), for: .touchUpInside)
        
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [startButton, settingsButton])
        stackview.axis = .vertical
        stackview.spacing = 5
        stackview.distribution = .fillEqually
        
        return stackview
    }()
    
    lazy var chartBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var beautifulBarChart: BeautifulBarChart = {
        let barChart = BeautifulBarChart()
        barChart.backgroundColor = .white
        barChart.layer.cornerRadius = 12.69
        
        return barChart
    }()
    
    lazy var barChartNoDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No shower data yet"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
        return label
    }()
    
    lazy var labelShimmer: ShimmeringView = {
        let shimmer = ShimmeringView()
        
        
        return shimmer
    }()
    
    lazy var separatorView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0
        
        return progressView
    }()
    
    lazy var waterStackViewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 26
        
        return stackView
    }()
    
    lazy var waterSavedDecsriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Liters of water saved:"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    lazy var waterUsedDecsriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Liters of wated used:"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    lazy var waterSavedLabel: UILabel = {
        let label = UILabel()
        label.text = waterStatistic(statistic: .saved)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        return label
    }()
    
    lazy var waterUsedLabel: UILabel = {
        let label = UILabel()
        label.text = waterStatistic(statistic: .used)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        return label
    }()
    
    lazy var waterSavedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return stackView
    }()
    lazy var waterUsedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16)
        
        return stackView
    }()
    
    lazy var upperStackViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.H2Save.accentColor
        view.layer.cornerRadius = 12.69
        
        return view
    }()
    
    lazy var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    // MARK: - Setup methods
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(buttonsStackView)
        
        view.addSubview(upperStackView)
        upperStackView.insertSubview(upperStackViewBackgroundView, at: 0)
        view.addSubview(chartBackgroundView)
        chartBackgroundView.addSubview(beautifulBarChart)
        beautifulBarChart.addSubview(barChartNoDataLabel)
        view.addSubview(labelShimmer)
        view.addSubview(separatorView)
        
        upperStackView.addArrangedSubview(chartBackgroundView)
        upperStackView.addArrangedSubview(separatorView)
        upperStackView.addArrangedSubview(waterStackViewsStackView)
        waterStackViewsStackView.addArrangedSubview(waterSavedStackView)
        waterStackViewsStackView.addArrangedSubview(waterUsedStackView)
        waterSavedStackView.addArrangedSubview(waterSavedDecsriptionLabel)
        waterSavedStackView.addArrangedSubview(waterSavedLabel)
        
        waterUsedStackView.addArrangedSubview(waterUsedDecsriptionLabel)
        waterUsedStackView.addArrangedSubview(waterUsedLabel)
    }
    
    private func setupLayout() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 220),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        upperStackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upperStackViewBackgroundView.topAnchor.constraint(equalTo:  upperStackView.topAnchor),
            upperStackViewBackgroundView.bottomAnchor.constraint(equalTo:  upperStackView.bottomAnchor),
            upperStackViewBackgroundView.leadingAnchor.constraint(equalTo:  upperStackView.leadingAnchor),
            upperStackViewBackgroundView.trailingAnchor.constraint(equalTo:  upperStackView.trailingAnchor)
        ])
        
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upperStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            upperStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            upperStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        chartBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartBackgroundView.heightAnchor.constraint(equalToConstant: 251)
        ])
        
        beautifulBarChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            beautifulBarChart.topAnchor.constraint(equalTo:  chartBackgroundView.topAnchor, constant: 8),
            beautifulBarChart.bottomAnchor.constraint(equalTo:  chartBackgroundView.bottomAnchor, constant: -8),
            beautifulBarChart.leadingAnchor.constraint(equalTo:  chartBackgroundView.leadingAnchor, constant: 8),
            beautifulBarChart.trailingAnchor.constraint(equalTo:  chartBackgroundView.trailingAnchor, constant: -8),
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 4),
            separatorView.widthAnchor.constraint(equalTo:  upperStackView.widthAnchor)
        ])
        
        barChartNoDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barChartNoDataLabel.centerXAnchor.constraint(equalTo:  beautifulBarChart.centerXAnchor),
            barChartNoDataLabel.centerYAnchor.constraint(equalTo:  beautifulBarChart.centerYAnchor)
        ])
        
        labelShimmer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelShimmer.centerXAnchor.constraint(equalTo:  beautifulBarChart.centerXAnchor),
            labelShimmer.centerYAnchor.constraint(equalTo:  beautifulBarChart.centerYAnchor),
            labelShimmer.topAnchor.constraint(equalTo:  barChartNoDataLabel.topAnchor),
            labelShimmer.bottomAnchor.constraint(equalTo:  barChartNoDataLabel.bottomAnchor),
            labelShimmer.leadingAnchor.constraint(equalTo:  barChartNoDataLabel.leadingAnchor),
            labelShimmer.trailingAnchor.constraint(equalTo:  barChartNoDataLabel.trailingAnchor)
        ])
    }
    
    private func setupShimmer() {
        labelShimmer.contentView = barChartNoDataLabel
        labelShimmer.shimmerSpeed = 100
        labelShimmer.shimmerPauseDuration = 0.4
        labelShimmer.isShimmering = true
    }
    
    private func setupWaterLabels() {
        waterUsedLabel.text = waterStatistic(statistic: .used)
        waterSavedLabel.text = waterStatistic(statistic: .saved)
    }
}

// MARK: - Chart
extension MainViewController {
    private func chartDataEntries() -> [DataEntry] {
        var dataEntries: [DataEntry] = []
        
        for weekday in weekdays {
            if let dataDictionary = UserDefaults.standard.dictionary(forKey: weekday) {
                guard let r = dataDictionary["r"] as? CGFloat else { continue }
                guard let g = dataDictionary["g"] as? CGFloat else { continue }
                guard let b = dataDictionary["b"] as? CGFloat else { continue }
                guard let a = dataDictionary["a"] as? CGFloat else { continue }
                guard let height = dataDictionary["height"] as? Double else { continue }
                guard let textValue = dataDictionary["textValue"] as? String else { continue }
                guard let title = dataDictionary["title"] as? String else { continue }
                
                let dataEntry = DataEntry(color: UIColor(red: r, green: g, blue: b, alpha: a), height: height, textValue: textValue, title: title)
                dataEntries.append(dataEntry)
            }
        }
        
        return dataEntries
    }
    
    private func drawChartAndLabel() {
        barChartNoDataLabel.isHidden = true
        labelShimmer.isHidden = true
        
        let dataEntries = chartDataEntries()
        switch dataEntries.isEmpty {
        case false:
            beautifulBarChart.updateDataEntries(dataEntries: dataEntries, animated: true)
        case true:
            beautifulBarChart.updateDataEntries(dataEntries: [], animated: true)
            UIView.animate(withDuration: 0.35) {
                self.barChartNoDataLabel.isHidden = false
                self.labelShimmer.isHidden = false
            }
        }
    }
}

// MARK: - Water statistics
extension MainViewController {
    private func waterStatistic(statistic: WaterStatistic ) -> String {
        let waterUsed = UD_REF.double(forKey: Constants.waterUsed)
        let waterSaved = UD_REF.double(forKey: Constants.waterSaved)
        
        switch statistic {
        case .used:
            return String(waterUsed)
        case .saved:
            return String(waterSaved)
        }
    }
}

// MARK: - Permisssions
extension MainViewController {
    private func setupPermissions() {
        let controller = SPPermissions.dialog(permissions)
        if !SPPermissions.Permission.microphone.authorized {
            controller.present(on: self)
        }
    }
}

// MARK: - Onboarding
extension MainViewController {
    @objc private func attemptOnboarding() {
        if UD_REF.bool(forKey: Constants.hasSeenOnboarding) == false {
            let boldTitleFont = UIFont.systemFont(ofSize: 32.0, weight: .bold)
            let configuration = OnboardViewController.AppearanceConfiguration(titleFont: boldTitleFont)
            let onboardingVC = OnboardViewController(pageItems: guidePages, appearanceConfiguration: configuration, completion: { [weak self] in
                self?.setupPermissions()
                UD_REF.set(true, forKey: Constants.hasSeenOnboarding)
            })
            onboardingVC.modalPresentationStyle = .fullScreen
            onboardingVC.presentFrom(self, animated: true)
            
        }
    }
}
