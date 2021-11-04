//
//  ResultsObserver.swift
//  Showering
//
//  Created by Krzysztof Kinal on 16/07/2021.
//

import SoundAnalysis

protocol BathroomClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double)
}

class ResultsObserver: NSObject, SNResultsObserving {
    
    var delegate: BathroomClassifierDelegate?
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        let confidence = classification.confidence * 100.0
        
        if confidence > 80 {
            delegate?.displayPredictionResult(identifier: classification.identifier, confidence: confidence)
        }
    }
}
