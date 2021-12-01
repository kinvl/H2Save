//
//  BathroomSoundAnalyzer.swift
//  Showering
//
//  Created by Krzysztof Kinal on 16/07/2021.
//

import SoundAnalysis

class BathroomSoundAnalyzer {
    
    var audioEngine: AVAudioEngine?
    private var soundClassifier: BathroomSoundClassifier?
    
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    var resultsObserver: ResultsObserver?
    private let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    func startAudioEngine() {
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier!.model)
            try analyzer.add(request, withObserver: resultsObserver!)
        } catch {
            return
        }
        
        audioEngine!.inputNode.installTap(onBus: 0, bufferSize: 8000, format: inputFormat) { buffer, time in
                        self.analysisQueue.async {
                            self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                        }
                }

    do {
        try audioEngine!.start()
    } catch(_) {
        }
    }
    
    func stopAudioEngine() {
        audioEngine!.stop()
        soundClassifier = nil
        resultsObserver = nil
        audioEngine = nil
    }
    
    init() {
        audioEngine = AVAudioEngine()
        soundClassifier = BathroomSoundClassifier()
        resultsObserver = ResultsObserver()
    }
}
