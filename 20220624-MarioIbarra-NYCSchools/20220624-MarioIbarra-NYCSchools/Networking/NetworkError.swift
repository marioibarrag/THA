import Foundation

enum NetworkError: String, Error {
    case badURL = "There was an error creating the request to the server."
    case badDecode = "The data received from the server was invalid."
    case badResponse = "Invalid response from the server."
    case other = "Unable to complete your request. Please check your internet connection."
}

