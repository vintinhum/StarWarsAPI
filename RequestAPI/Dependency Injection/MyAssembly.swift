//
//  MyAssembly.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import Swinject

class MyAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - FACTORY AND COORDINATOR
        
        container.register(Factory.self) { resolver in
            return Factory(resolver: resolver)
        }
        
        container.register(AppMainCoordinator.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(Factory.self)
            return AppMainCoordinator(navigationController: navigationController, factory: factory)
        }
        
        // MARK: - SERVICE
        
        container.register(NetworkingProtocol.self, name: "urlsession") { resolver in
            return URLSessionNetworking()
        }
        
        container.register(NetworkingProtocol.self, name: "alamofire") { resolver in
            return AlamofireNetworking()
        }
        
        // MARK: - USE CASES
        
        container.register(FetchCharacterWithURLSessionUseCaseProtocol.self) { (_, networking: NetworkingProtocol)  in
            return FetchCharacterWithURLSessionUseCase(networking: networking)
        }
        
        container.register(FetchCharacterWithAlamofireUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchCharacterWithAlamofireUseCase(networking: networking)
        }
        
        container.register(FetchHomeworldWithURLSessionUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchHomeworldWithURLSessionUseCase(networking: networking)
        }
        
        container.register(FetchHomeworldWithAlamofireUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchHomeworldWithAlamofireUseCase(networking: networking)
        }
        
        container.register(FetchFilmListWithURLSessionUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchFilmListWithURLSessionUseCase(networking: networking)
        }
        
        container.register(FetchFilmListWithAlamofireUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchFilmListWithAlamofireUseCase(networking: networking)
        }
        
        container.register(FetchStarshipListWithURLSessionUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchStarshipListWithURLSessionUseCase(networking: networking)
        }
        
        container.register(FetchStarshipListWithAlamofireUseCaseProtocol.self) { (_, networking: NetworkingProtocol) in
            return FetchStarshipListWithAlamofireUseCase(networking: networking)
        }
        
        // MARK: - VIEW MODELS
        
        container.register(CharacterDetailViewModel.self) { resolver in
            let urlSessionNetworking = resolver.resolveUnwrapping(NetworkingProtocol.self, name: "urlsession")
            let alamofireNetworking = resolver.resolveUnwrapping(NetworkingProtocol.self, name: "alamofire")
            let fetchCharacterWithURLSessionUseCase = resolver.resolveUnwrapping(FetchCharacterWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchCharacterWithAlamofireUseCase = resolver.resolveUnwrapping(FetchCharacterWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            let fetchHomeworldWithURLSessionUseCase = resolver.resolveUnwrapping(FetchHomeworldWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchHomeworldWithAlamofireUseCase = resolver.resolveUnwrapping(FetchHomeworldWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            return CharacterDetailViewModel(fetchCharacterWithURLUseCase: fetchCharacterWithURLSessionUseCase,
                                            fetchCharacterWithAlamofireUseCase: fetchCharacterWithAlamofireUseCase,
                                            fetchHomeworldWithURLSessionUseCase: fetchHomeworldWithURLSessionUseCase,
                                            fetchHomeworldWithAlamofireUseCase: fetchHomeworldWithAlamofireUseCase)
        }
        
        container.register(FilmListViewModel.self) { resolver in
            let urlSessionNetworking = resolver.resolveUnwrapping(NetworkingProtocol.self, name: "urlsession")
            let alamofireNetworking = resolver.resolveUnwrapping(NetworkingProtocol.self, name: "alamofire")
            let fetchFilmListWithURLSessionUseCase = resolver.resolveUnwrapping(FetchFilmListWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchFilmListWithAlamofireUseCase = resolver.resolveUnwrapping(FetchFilmListWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            return FilmListViewModel(fetchFilmListWithURLSessionUseCase: fetchFilmListWithURLSessionUseCase,
                                     fetchFilmListWithAlamofireUseCase: fetchFilmListWithAlamofireUseCase)
        }
        
        container.register(StarshipListViewModel.self) { resolver in
            let urlSessionNetworking = resolver.resolveUnwrapping(NetworkingProtocol.self, name: "urlsession")
            let alamofireNetworking = resolver.resolveUnwrapping(NetworkingProtocol.self, name: "alamofire")
            let fetchStarshipListWithURLSessionUseCase = resolver.resolveUnwrapping(FetchStarshipListWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchStarshipListWithAlamofireUseCase = resolver.resolveUnwrapping(FetchStarshipListWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            return StarshipListViewModel(fetchStarshipListWithURLSessionUseCase: fetchStarshipListWithURLSessionUseCase,
                                         fetchStarshipListWithAlamofireUseCase: fetchStarshipListWithAlamofireUseCase)
        }
        
        // MARK: - VIEW CONTROLLERS
        
        container.register(CharacterSelectionViewController.self) { _ in
            return CharacterSelectionViewController()
        }
        
        container.register(CharacterDetailCollectionViewController.self) { (resolver, requestType: RequestType, characterNumber: Int) in
            let viewModel = resolver.resolveUnwrapping(CharacterDetailViewModel.self)
            return CharacterDetailCollectionViewController(requestType: requestType, characterNumber: characterNumber, viewModel: viewModel)
        }
        
        container.register(FilmListTableViewController.self) { (resolver, requestType: RequestType, characterNumber: Int) in
            let viewModel = resolver.resolveUnwrapping(FilmListViewModel.self)
            return FilmListTableViewController(requestType: requestType, characterNumber: characterNumber, viewModel: viewModel)
        }
        
        container.register(StarshipListTableViewController.self) { (resolver, requestType: RequestType, characterNumber: Int) in
            let viewModel = resolver.resolveUnwrapping(StarshipListViewModel.self)
            return StarshipListTableViewController(requestType: requestType, characterNumber: characterNumber, viewModel: viewModel)
        }
    }
}
