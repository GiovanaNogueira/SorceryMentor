//
//  SpeechRecognition.swift
//  SorceryMentor
//
//  Created by Giovana Nogueira on 26/02/24.
//

import Foundation
import Speech
import AVFoundation
import SwiftUI


class SpeechToText: ObservableObject {
    
    private enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    var language: String
    /// Palavras que você falou
    @Published private(set) var words: [String]
    @Published private(set) var currentWord: String
    
    /// Palavars que você busca
    @Published var buscadas: [String]
    
    func mudaFeitico(nomeDoFeiticoNovo: String) {
        self.buscadas = nomeDoFeiticoNovo.split(separator: " ").map { word in
            return "\(word)"
        }
    }
    
    /// Código nosso!
    func confere() {
//        print(buscadas.split(separator: " "))
        print("WORDS = \(words)")
        print("BUSCADAS = \(buscadas)")
        words.forEach{ word in
            let treatedWord = word.capitalized
            if buscadas.contains(treatedWord) {
                buscadas = buscadas.filter({$0 != treatedWord})
            }
        }
        print("BUSCADAS AFTER = \(buscadas)")
    }
    
//    func checkIfDesiredPhraseIsSpoken() async -> Bool {
//            let spokenPhrase = words.joined(separator: " ")
//
//            // Verifique se a frase desejada foi dita (ignorando maiúsculas/minúsculas)
//            return spokenPhrase.lowercased().contains("lumos")
//        }
//    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    init(language: String,
         words: [String],
         currentWord: String,
         audioEngine: AVAudioEngine? = nil,
         request: SFSpeechAudioBufferRecognitionRequest? = nil,
         task: SFSpeechRecognitionTask? = nil,
         recognizer: SFSpeechRecognizer?) {
        self.language = language
        self.words = words /*+ ["i"]*/
        self.currentWord = currentWord
        self.audioEngine = audioEngine
        self.request = request
        self.task = task
        self.recognizer = recognizer
        self.buscadas = "lumos".split(separator: " ").map { word in
            return "\(word)"
        }
    }
    
    convenience init(language: String) {
        self.init(language: language, words: [], currentWord: "", recognizer: SFSpeechRecognizer(locale: Locale(identifier: language)))
        guard recognizer != nil else { transcribe(RecognizerError.nilRecognizer); return }
        
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
    }
    
    func startTranscribing() {
        Task {
            await transcribe()
        }
    }
    
   func resetTranscript() {
        Task {
            await reset()
        }
    }
    
    func stopTranscribing() {
        Task {
            await reset()
        }
    }

    private func transcribe() async {
        guard let recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            }
        } catch {
            await self.reset()
            self.transcribe(error)
        }
    }
    
    private func reset() async {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
      //  request.shouldReportPartialResults = true
        //request.requiresOnDeviceRecognition = true // TESTE
       // request.
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if let result {
            transcribe(result.bestTranscription.formattedString)
            
        }
    }
    
    
    private func transcribe(_ message: String) {
        Task { @MainActor in
            let word = extractLastWord(from: message)
            words.append(word)
            currentWord = word
            confere()
        }
    }
    
    private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
    }
    
    func extractLastWord(from inputString: String) -> String {
        let words = inputString.components(separatedBy: .whitespaces)
        if let lastWord = words.last {
            return lastWord
        }
        return ""
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}


extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}


