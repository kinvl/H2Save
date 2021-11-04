//
//  SettingsViewController.swift
//  Showering
//
//  Created by Krzysztof Kinal on 10/10/2021.
//

import UIKit
import OnboardKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.H2Save.background
        setupViews()
        setupLayout()
        setInitialSwitchState()
    }
    
    // MARK: - Selectors and methods
    private func setInitialSwitchState() {
        showerFixSwitch.isOn = UD_REF.bool(forKey: Constants.shouldLowerRecognitionAccuracy) ? true : false
    }
    
    @objc private func writeShowerFixSettingsToUserDefaults(_ sender: UISwitch) {
        UD_REF.set(sender.isOn, forKey: Constants.shouldLowerRecognitionAccuracy)
    }
    
    @objc private func resetChartData() {
        for weekday in weekdays {
            UD_REF.removeObject(forKey: weekday)
        }
    }
    
    @objc private func resetWaterStatistics() {
        UD_REF.set(0, forKey: Constants.waterSaved)
        UD_REF.set(0, forKey: Constants.waterUsed)
    }
    
    @objc private func replayGuide() {
        let boldTitleFont = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        let configuration = OnboardViewController.AppearanceConfiguration(titleFont: boldTitleFont)
        let onboardingVC = OnboardViewController(pageItems: guidePages, appearanceConfiguration: configuration)
        onboardingVC.modalPresentationStyle = .pageSheet
        onboardingVC.presentFrom(self, animated: true)
    }
    
    @objc private func presentAboutViewController() {
        let vc = AboutViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Views
    lazy var backgroundImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "wave")
        imageview.contentMode = .scaleAspectFill
        
        return imageview
    }()
    
    lazy var aboutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("About", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.H2Save.ashenGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(presentAboutViewController), for: .touchUpInside)
        
        return button
    }()
    
    lazy var goBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.contrastingAccentColor
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [aboutButton, goBackButton])
        stackview.axis = .vertical
        stackview.spacing = 5
        stackview.distribution = .fillEqually
        
        return stackview
    }()
    
    lazy var showerFixSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.addTarget(self, action: #selector(writeShowerFixSettingsToUserDefaults), for: .valueChanged)
        
        return uiswitch
    }()
    
    lazy var resetChartDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RESET CHART DATA", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.accentColor
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(resetChartData), for: .touchUpInside)
        
        return button
    }()
    
    lazy var resetWaterStatisticsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RESET WATER STATISTICS", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.accentColor
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(resetWaterStatistics), for: .touchUpInside)
        
        return button
    }()
    
    lazy var replayGuideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("REPLAY GUIDE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.accentColor
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(replayGuide), for: .touchUpInside)
        
        return button
    }()
    
    lazy var upperButtonsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [resetChartDataButton, resetWaterStatisticsButton, replayGuideButton])
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fillEqually
        
        return stackview
    }()
    
    lazy var showerFixLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Shower not recognized fix"
        label.textColor = .black
        
        return label
    }()
    
    lazy var showerFixDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = """
        Turn this on if your shower can't be recognized.
        This will lower accuracy.
        """
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var showerFixInnerStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [showerFixLabel, showerFixDescriptionLabel])
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fillProportionally
        stackview.alignment = .center
        
        return stackview
    }()
    
    lazy var showerFixOuterStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [showerFixInnerStackView, showerFixSwitch])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        
        return stackview
    }()
    
    // MARK: - Setup methods
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(buttonsStackView)
        view.addSubview(upperButtonsStackView)
        view.addSubview(showerFixOuterStackView)
    }
    
    private func setupLayout() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 220),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        showerFixOuterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showerFixOuterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            showerFixOuterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showerFixOuterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        resetChartDataButton.translatesAutoresizingMaskIntoConstraints = false
        resetChartDataButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        resetWaterStatisticsButton.translatesAutoresizingMaskIntoConstraints = false
        resetWaterStatisticsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        replayGuideButton.translatesAutoresizingMaskIntoConstraints = false
        replayGuideButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        upperButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upperButtonsStackView.topAnchor.constraint(equalTo: showerFixOuterStackView.bottomAnchor, constant: 32),
            upperButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            upperButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
