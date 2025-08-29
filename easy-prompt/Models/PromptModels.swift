//
//  PromptModels.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

// MARK: - Image Prompt Models
struct ImagePrompt: Codable, Hashable {
    let prompt: ImagePromptStructure
    let negativePrompt: String
    let parameters: ImageParameters
    
    var asJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let jsonStructure: [String: Any] = [
            "instances": [
                [
                    "prompt": "\(prompt.subject) in \(prompt.environment), \(prompt.style), \(prompt.lighting), shot with \(prompt.camera.lens ?? "professional camera"), \(prompt.camera.angle) angle, \(prompt.camera.distance) shot, color palette: \(prompt.colorPalette.joined(separator: ", ")), 8K, photorealistic, highly detailed"
                ]
            ],
            "parameters": [
                "sampleCount": parameters.sampleCount,
                "aspectRatio": parameters.aspectRatio,
                "negativePrompt": negativePrompt,
                "seed": parameters.seed as Any
            ]
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: jsonStructure, options: [.prettyPrinted, .sortedKeys]),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "{}"
    }
}

struct ImagePromptStructure: Codable, Hashable {
    let subject: String
    let environment: String
    let style: String
    let lighting: String
    let camera: CameraSettings
    let colorPalette: [String]
}

struct ImageParameters: Codable, Hashable {
    let model: String = "imagen-4"
    let aspectRatio: String = "16:9"
    let sampleCount: Int = 2
    let seed: Int?
}

struct CameraSettings: Codable, Hashable {
    let angle: String
    let distance: String
    let lens: String?
}

// MARK: - Video Prompt Models
struct VideoPrompt: Codable, Hashable {
    let promptName: String
    let coreContent: String
    let details: VideoDetails
    let negativePrompt: String
    let visualRules: String
    
    var asJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let jsonStructure: [String: Any] = [
            "prompt_name": promptName,
            "version": 1.0,
            "target_ai_model": "VEO3",
            "core_concept": coreContent,
            "details": [
                "scene_environment": [
                    "setting": details.sceneEnvironment.setting,
                    "features": details.sceneEnvironment.features,
                    "mood": details.sceneEnvironment.mood
                ],
                "subject": [
                    "description": details.subject.description,
                    "wardrobe": details.subject.wardrobe as Any,
                    "character_consistency": details.subject.characterConsistency
                ],
                "visual_style": [
                    "aesthetic": details.visualStyle.aesthetic,
                    "resolution": details.visualStyle.resolution,
                    "lighting": details.visualStyle.lighting
                ],
                "camera_work": [
                    "composition": details.cameraWork.composition,
                    "camera_motion": details.cameraWork.cameraMotion,
                    "positioning": details.cameraWork.positioning
                ],
                "audio": [
                    "dialogue": details.audio.dialogue as Any,
                    "primary_sounds": details.audio.primarySounds,
                    "ambient": details.audio.ambient,
                    "music": details.audio.music as Any
                ]
            ],
            "negative_prompt": negativePrompt,
            "visual_rules": visualRules
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: jsonStructure, options: [.prettyPrinted, .sortedKeys]),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "{}"
    }
}

struct VideoDetails: Codable, Hashable {
    let sceneEnvironment: SceneEnvironment
    let subject: SubjectDescription
    let visualStyle: VisualStyle
    let cameraWork: CameraWork
    let audio: AudioLayers
}

struct SceneEnvironment: Codable, Hashable {
    let setting: String
    let features: String
    let mood: String
}

struct SubjectDescription: Codable, Hashable {
    let description: String
    let wardrobe: String?
    let characterConsistency: String
}

struct VisualStyle: Codable, Hashable {
    let aesthetic: String
    let resolution: String = "720p"
    let lighting: String
}

struct CameraWork: Codable, Hashable {
    let composition: String
    let cameraMotion: String
    let positioning: String // Must include "(thats where the camera is)"
}

struct AudioLayers: Codable, Hashable {
    let dialogue: String?
    let primarySounds: String
    let ambient: String
    let music: String?
}