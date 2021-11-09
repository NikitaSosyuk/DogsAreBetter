//
//  RootViewModel.swift
//  DogsAreBetter
//
//  Created by Nikita Sosyuk on 08.11.2021.
//

import Foundation
import Combine

final class RootViewModel {

    // MARK: - Internal Properties

    @Published
    var dog: DogMessage?

    @Published
    var cat: CatFact?

    @Published
    var scores: (dogScore: Int, catScore: Int) = (0, 0)

    // MARK: - Private Properties

    private let catRandomFactURL = URL(string: "https://catfact.ninja/fact")! // this is fine 🙂
    private let dogRandomImageURL = URL(string: "https://dog.ceo/api/breeds/image/random")! // this is fine 🙂

    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var cancellableSet = Set<AnyCancellable>()

    // MARK: - Internal Methods

    func downloadCatRandomFact() {
        urlSession.dataTaskPublisher(for: catRandomFactURL)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                          throw URLError(.badServerResponse)
                      }
                return element.data
            }
            .decode(type: CatFact.self, decoder: self.decoder)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { cat in
                    self.cat = cat
                    self.scores.catScore += 1
                }
            )
            .store(in: &cancellableSet)
    }

    func downloadDogRandomImage() {
        urlSession.dataTaskPublisher(for: dogRandomImageURL)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                          throw URLError(.badServerResponse)
                      }
                return element.data
            }
            .decode(type: DogMessage.self, decoder: self.decoder)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { dog in
                    self.dog = dog
                    self.scores.dogScore += 1
                }
            )
            .store(in: &cancellableSet)
    }

    func resetScores() {
        self.scores = (0, 0)
    }
}
