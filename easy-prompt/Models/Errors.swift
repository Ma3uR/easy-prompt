//
//  Errors.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

enum GenerationError: LocalizedError {
    case invalidInput
    case networkError
    case aiServiceError(String)
    case storageError
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Please fill in all fields"
        case .networkError:
            return "Check your internet connection"
        case .aiServiceError(let message):
            return message
        case .storageError:
            return "Failed to save content"
        }
    }
    
    static func from(_ error: Error) -> GenerationError {
        if let genError = error as? GenerationError {
            return genError
        } else if let urlError = error as? URLError {
            return .networkError
        } else {
            return .aiServiceError(error.localizedDescription)
        }
    }
}

enum AppError: LocalizedError {
    case network(URLError)
    case decoding(DecodingError)
    case api(APIError)
    case validation(ValidationError)
    case storage(StorageError)
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .decoding:
            return "Failed to process response"
        case .api(let error):
            return error.message
        case .validation(let error):
            return error.message
        case .storage:
            return "Failed to save data"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .network:
            return "Check your internet connection and try again"
        case .api(let error) where error.code == 429:
            return "Too many requests. Please wait a moment"
        default:
            return "Please try again"
        }
    }
}

struct APIError: LocalizedError {
    let code: Int
    let message: String
    
    var errorDescription: String? {
        return message
    }
}

struct ValidationError: LocalizedError {
    let message: String
    
    var errorDescription: String? {
        return message
    }
}

struct StorageError: LocalizedError {
    let message: String
    
    var errorDescription: String? {
        return message
    }
}