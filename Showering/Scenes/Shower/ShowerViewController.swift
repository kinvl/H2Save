//
//  ShowerViewController.swift
//  Showering
//
//  Created by Krzysztof Kinal on 08/10/2021.
//

import UIKit
import CountdownLabel
import SoundAnalysis
import AVFoundation

class ShowerViewController: UIViewController {
    
    private var soundAnalyzer: BathroomSoundAnalyzer?
    private var shouldStopShower: Bool?
    private var shouldLowerAccuracy: Bool?
    private var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.H2Save.background
        setupViews()
        setupLayout()
        setupSoundAnalyzer()
        setupAccuracyLoweringPreferences()
    }
    
    deinit {
        print("shower deinited")
        soundAnalyzer = nil
        countdownLabel.delegate = nil
        audioPlayer = nil
    }
    
    // MARK: - View controller dismission
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
        soundAnalyzer!.stopAudioEngine()
    }
    
    // MARK: - Views
    lazy var backgroundImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "wave")
        imageview.contentMode = .scaleAspectFill
        
        return imageview
    }()
    
    lazy var startShowerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.contrastingAccentColor
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(startShower), for: .touchUpInside)
        
        return button
    }()
    
    lazy var goBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.H2Save.ashenGray
        button.layer.cornerRadius = 12.69
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        return button
    }()
    
    lazy var showerButtonsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [startShowerButton, goBackButton])
        stackview.axis = .vertical
        stackview.spacing = 5
        stackview.distribution = .fillEqually
        
        return stackview
    }()
    
    lazy var countdownLabel: CountdownLabel = {
        let label = CountdownLabel()
        label.text = "05: 00"
        label.textColor = .black
        label.timeFormat = "mm : ss"
        label.setCountDownTime(minutes: 5 * 60 )
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 32)
        label.animationType =  .Evaporate
        label.countdownDelegate = self
        label.pause()
        
        return label
    }()
    
    lazy var showerProgressView: LinearProgressView = {
        let progressView = LinearProgressView()
        progressView.barColor = UIColor.H2Save.ashenGray
        progressView.trackColor = UIColor.H2Save.accentColor
        progressView.isCornersRounded = true
        progressView.maximumValue = 300
        progressView.minimumValue = 0
        progressView.barInset = 4
        progressView.setProgress(300, animated: false)
        
        return progressView
    }()
    
    lazy var recognitionBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.H2Save.accentColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.69
        
        return view
    }()
    
    lazy var recognitionImage: UIImageView = {
        let imageview = UIImageView()
        let image = UIImage(named: "startW")
        imageview.image = image
        imageview.contentMode = .scaleAspectFit
        
        return imageview
    }()
    
    // MARK: - Setup methods
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(showerButtonsStackView)
        view.addSubview(recognitionBackground)
        recognitionBackground.addSubview(recognitionImage)
        view.addSubview(countdownLabel)
        view.addSubview(showerProgressView)
        
    }
    
    private func setupLayout() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 220),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        startShowerButton.translatesAutoresizingMaskIntoConstraints = false
        startShowerButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        showerButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showerButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            showerButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showerButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        recognitionBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recognitionBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            recognitionBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recognitionBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recognitionBackground.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        recognitionImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recognitionImage.centerXAnchor.constraint(equalTo: recognitionBackground.centerXAnchor),
            recognitionImage.centerYAnchor.constraint(equalTo: recognitionBackground.centerYAnchor),
            recognitionImage.heightAnchor.constraint(equalTo: recognitionImage.widthAnchor, multiplier: 38/45 ),
            recognitionImage.widthAnchor.constraint(equalTo: recognitionBackground.widthAnchor, multiplier: 38/45 )
        ])
        
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.topAnchor.constraint(equalTo: recognitionBackground.bottomAnchor, constant: 24)
        ])
        
        showerProgressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showerProgressView.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 5),
            showerProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showerProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            showerProgressView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupSoundAnalyzer() {
        soundAnalyzer = BathroomSoundAnalyzer()
        soundAnalyzer!.resultsObserver!.delegate = self
        soundAnalyzer!.inputFormat = soundAnalyzer!.audioEngine!.inputNode.inputFormat(forBus: 0)
        soundAnalyzer!.analyzer = SNAudioStreamAnalyzer(format: soundAnalyzer!.inputFormat)
    }
    
    private func setupAccuracyLoweringPreferences() {
        shouldLowerAccuracy = UD_REF.bool(forKey: Constants.shouldLowerRecognitionAccuracy)
    }
    
    // This is a temporary workaround until I come up with something better
    // This is necessary because if countdown label's .start() or .pause() is called too many times at once it will reset itself
    private var classificationTimeNotRecognized: Int = 0
    private var classificationTimeFound: Int = 0
    
    func timerServiceNotRecognized() {
        if classificationTimeNotRecognized >= 5 {
            switch countdownLabel.isPaused {
            case true:
                classificationTimeNotRecognized = 0
            case false:
                countdownLabel.pause()
                classificationTimeNotRecognized = 0
                classificationTimeFound = 0
            }
        }
        classificationTimeNotRecognized += 1
    }
    
    func timerServiceFound() {
        if classificationTimeFound >= 5 {
            switch countdownLabel.isPaused {
            case true:
                countdownLabel.start()
                classificationTimeFound = 0
                classificationTimeNotRecognized = 0
            case false:
                classificationTimeFound = 0
            }
        }
        classificationTimeFound += 1
    }
}

// MARK: - Shower related methods
extension ShowerViewController {
    @objc func startShower() {
        guard let soundAnalyzer = soundAnalyzer else { return }
        
        if shouldStopShower == true {
            countdownLabel.start()
            writeCurrentSessionWaterStatisticsToUD(timeCounted: countdownLabel.timeCounted)
            let showerSaver = ShowerDictionarySaver()
            showerSaver.saveDictionaryWithShowerTimeElapsed(time: countdownLabel.timeRemaining)
            self.dismiss(animated: true, completion: nil)
            soundAnalyzer.stopAudioEngine()
        } else {
            self.goBackButton.isEnabled = false
            self.startShowerButton.isEnabled = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35) {
                    self.goBackButton.alpha = 0
                    self.startShowerButton.backgroundColor = .red
                    self.startShowerButton.setTitle("STOP", for: .normal)
                }
            }
            soundAnalyzer.startAudioEngine()
            countdownLabel.start(completion: nil)
            startShowerButton.isEnabled = true
            shouldStopShower = true
        }
    }
    
    private func writeCurrentSessionWaterStatisticsToUD(timeCounted: TimeInterval) {
        let liters = Double(timeCounted) * 0.133
        var totalWaterUsed = UD_REF.double(forKey: Constants.waterUsed)
        var totalWaterSaved = UD_REF.double(forKey: Constants.waterSaved)
        
        totalWaterUsed += liters
        totalWaterSaved += (39.9 - liters)
        
        totalWaterUsed = round(1000 * totalWaterUsed) / 1000
        totalWaterSaved = round(1000 * totalWaterSaved) / 1000
        
        UD_REF.set(totalWaterUsed, forKey: Constants.waterUsed)
        UD_REF.set(totalWaterSaved, forKey: Constants.waterSaved)
    }
    
    private func playNotificationAudio() {
        guard let path = Bundle.main.path(forResource: "notification", ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch _ {
        }
        audioPlayer.play()
    }
}

// MARK: - Bathroom classifier delegate
extension ShowerViewController: BathroomClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double) {
        print(identifier, confidence)
        switch shouldLowerAccuracy {
        case true:
            DispatchQueue.main.async {
                if identifier == "Shower" || identifier == "Sink" {
                    self.timerServiceFound()
                    UIView.animate(withDuration: 0.15) { [weak self] in
                        self?.recognitionBackground.backgroundColor = UIColor.H2Save.accentColor
                        self?.recognitionImage.image = UIImage(named: "shower")
                    }
                } else {
                    self.timerServiceNotRecognized()
                    UIView.animate(withDuration: 0.15) { [weak self] in
                        self?.recognitionBackground.backgroundColor = UIColor.H2Save.ashenGray
                        self?.recognitionImage.image = UIImage(named: "questionmarkB")
                    }
                }
            }
            
        case false:
            DispatchQueue.main.async {
                if identifier == "Shower" {
                    self.timerServiceFound()
                    UIView.animate(withDuration: 0.15) { [weak self] in
                        self?.recognitionBackground.backgroundColor = UIColor.H2Save.accentColor
                        self?.recognitionImage.image = UIImage(named: "shower")
                    }
                } else {
                    self.timerServiceNotRecognized()
                    UIView.animate(withDuration: 0.15) { [weak self] in
                        self?.recognitionBackground.backgroundColor = UIColor.H2Save.ashenGray
                        self?.recognitionImage.image = UIImage(named: "questionmarkB")
                    }
                }
            }
        default:
            ()
        }
    }
}

// MARK: - Countdown label delegate
extension ShowerViewController: CountdownLabelDelegate {
    func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        print("counting timeCounted:", timeCounted, " and remaining", timeRemaining)
        showerProgressView.setProgress(Float(timeRemaining), animated: true)
        switch timeRemaining {
        case 45:
            playNotificationAudio()
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35) {
                    self.countdownLabel.textColor = .red
                    self.showerProgressView.trackColor = .red
                }
            }
            
        default:
            ()
        }
    }
}
