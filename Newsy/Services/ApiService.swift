//
//  ApiService.swift
//  Newsy
//
//  Created by Lena Soroka on 25.09.2022.
//
import Foundation

protocol ApiServiceProtocol: class {
    var isPaginating: Bool { get }
    func getArticlesData(completion: @escaping (Result<[Article]?, Error>) -> ())
    func getNextDataPage(completion: @escaping (Result<[Article]?, Error>) -> ())
    func search(for word: String, completion: @escaping (Result<[Article]?, Error>) -> ())
}

class ApiService: ApiServiceProtocol {
    private enum ArticleFetchError: Error {
        case invalidURL
        case missingData
        case decodeError
    }
    
    private var apiKey: String = {
        guard let filePath = Bundle.main.path(forResource: "SecureKeys", ofType: "plist") else {
            fatalError(Constants.Error.keyNotAvailableError)
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let key = plist?.value(forKey: "API_KEY") as? String else {
            fatalError(Constants.Error.noKeyFound)
        }
        return key
    }()
    
    private var currentPage: Int = 1
    private var currentURL: URL?
    var isPaginating = false
    
    init() {
    }
    
    func getArticlesData(completion: @escaping (Result<[Article]?, Error>) -> ()) {
        let urlString = Constants.API.urlPaginatedString(currentPage, apiKey)
        guard let url = URL(string: urlString) else {
            completion(.failure(ArticleFetchError.invalidURL))
            return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                print(Constants.Error.fetchError)
                completion(.failure(ArticleFetchError.missingData))
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(ArticlesData.self, from: data)
                let articles = data.articles
                completion(.success(articles))
            } catch {
                print(Constants.Error.decodeError)
                completion(.failure(ArticleFetchError.decodeError))
            }
        }.resume()
    }
    
    func getNextDataPage(completion: @escaping (Result<[Article]?, Error>) -> ()) {
        let nextPage = currentPage + 1
        isPaginating = true
        let urlString = Constants.API.urlPaginatedString(nextPage, apiKey)
        guard let url = URL(string: urlString) else {
            completion(.failure(ArticleFetchError.invalidURL))
            return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                print(Constants.Error.fetchError)
                completion(.failure(ArticleFetchError.missingData))
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(ArticlesData.self, from: data)
                let articles = data.articles
                self?.currentPage += 1
                self?.isPaginating = false
                completion(.success(articles))
            } catch {
                print(Constants.Error.decodeError)
                completion(.failure(ArticleFetchError.decodeError))
            }
        }.resume()
    }
    
    func search(for word: String, completion: @escaping (Result<[Article]?, Error>) -> ()) {
        let urlString = Constants.API.urlSearchString(word, currentPage, apiKey)
        guard let url = URL(string: urlString) else {
            completion(.failure(ArticleFetchError.invalidURL))
            return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                print(Constants.Error.fetchError)
                completion(.failure(ArticleFetchError.missingData))
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(ArticlesData.self, from: data)
                let articles = data.articles
                completion(.success(articles))
            } catch {
                print(Constants.Error.decodeError)
                completion(.failure(ArticleFetchError.decodeError))
            }
        }.resume()
    }
}
