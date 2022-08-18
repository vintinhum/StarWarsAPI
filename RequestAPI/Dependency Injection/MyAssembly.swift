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
        
        // MARK: - FACTORY
        
        container.register(Factory.self) { resolver in
            return Factory(resolver: resolver)
        }
        
        // MARK: - COORDINATOR
        
        container.register(AppMainCoordinator.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(Factory.self)
            return AppMainCoordinator(navigationController: navigationController, factory: factory)
        }
        
        // MARK: - SERVICE
        
        container.register(ServiceProtocol.self, name: "urlsession") { resolver in
            return URLSessionService()
        }
        
        container.register(ServiceProtocol.self, name: "alamofire") { resolver in
            return AlamofireService()
        }
        
        // MARK: - USE CASES
        
        container.register(FetchCharacterWithURLSessionUseCaseProtocol.self) { (_, service: ServiceProtocol)  in
            return FetchCharacterWithURLSessionUseCase(service: service)
        }
        
        container.register(FetchCharacterWithAlamofireUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchCharacterWithAlamofireUseCase(service: service)
        }
        
        container.register(FetchHomeworldWithURLSessionUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchHomeworldWithURLSessionUseCase(service: service)
        }
        
        container.register(FetchHomeworldWithAlamofireUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchHomeworldWithAlamofireUseCase(service: service)
        }
        
        container.register(FetchFilmListWithURLSessionUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchFilmListWithURLSessionUseCase(service: service)
        }
        
        container.register(FetchFilmListWithAlamofireUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchFilmListWithAlamofireUseCase(service: service)
        }
        
        container.register(FetchStarshipListWithURLSessionUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchStarshipListWithURLSessionUseCase(service: service)
        }
        
        container.register(FetchStarshipListWithAlamofireUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchStarshipListWithAlamofireUseCase(service: service)
        }
        
        container.register(FetchAllCharactersDataUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchAllCharactersDataUseCase(service: service)
        }
        
        container.register(FetchAllCharactersDataWithURLUseCaseProtocol.self) { (_, service: ServiceProtocol) in
            return FetchAllCharactersDataWithURLUseCase(service: service)
        }
        
        // MARK: - CharacterSelectionViewController
        
        container.register(CharacterSelectionViewController.self) { _ in
            return CharacterSelectionViewController()
        }
        
        // MARK: - CharacterDetailViewController
        
        container.register(CharacterDetailViewModelProtocol.self) { (resolver, model: CharacterDetailModel) in
            let urlSessionNetworking = resolver.resolveUnwrapping(ServiceProtocol.self, name: "urlsession")
            let alamofireNetworking = resolver.resolveUnwrapping(ServiceProtocol.self, name: "alamofire")
            let fetchCharacterWithURLSessionUseCase = resolver.resolveUnwrapping(FetchCharacterWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchCharacterWithAlamofireUseCase = resolver.resolveUnwrapping(FetchCharacterWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            let fetchHomeworldWithURLSessionUseCase = resolver.resolveUnwrapping(FetchHomeworldWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchHomeworldWithAlamofireUseCase = resolver.resolveUnwrapping(FetchHomeworldWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            return CharacterDetailViewModel(model: model,
                                            fetchCharacterWithURLUseCase: fetchCharacterWithURLSessionUseCase,
                                            fetchCharacterWithAlamofireUseCase: fetchCharacterWithAlamofireUseCase,
                                            fetchHomeworldWithURLSessionUseCase: fetchHomeworldWithURLSessionUseCase,
                                            fetchHomeworldWithAlamofireUseCase: fetchHomeworldWithAlamofireUseCase)
        }
        
        container.register(CharacterDetailViewControllerProtocol.self) { (resolver, model: CharacterDetailModel) in
            let viewModel = resolver.resolveUnwrapping(CharacterDetailViewModelProtocol.self, argument: model)
            return CharacterDetailViewController(viewModel: viewModel)
        }
        
        // MARK: - CharacterListViewController
        
        container.register(CharacterListViewModelProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(ServiceProtocol.self, name: "urlsession")
            let fetchAllCharactersUseCase = resolver.resolveUnwrapping(FetchAllCharactersDataUseCaseProtocol.self, argument: service)
            let fetchAllCharactersWithURLUseCase = resolver.resolveUnwrapping(FetchAllCharactersDataWithURLUseCaseProtocol.self, argument: service)
            let fetchHomeworldDataUseCase = resolver.resolveUnwrapping(FetchHomeworldWithURLSessionUseCaseProtocol.self, argument: service)
            return CharacterListViewModel(fetchAllCharactersUseCase: fetchAllCharactersUseCase,
                                          fetchAllCharactersWithURLUseCase: fetchAllCharactersWithURLUseCase,
                                          fetchHomeworldDataUseCase: fetchHomeworldDataUseCase)
        }
        
        container.register(CharacterListViewControllerProtocol.self) { resolver in
            let viewModel = resolver.resolveUnwrapping(CharacterListViewModelProtocol.self)
            return CharacterListViewController(viewModel: viewModel)
        }
        
        // MARK: - StarshipListViewController
        
        container.register(StarshipListViewModelProtocol.self) { (resolver, model: StarshipListModel) in
            let urlSessionNetworking = resolver.resolveUnwrapping(ServiceProtocol.self, name: "urlsession")
            let alamofireNetworking = resolver.resolveUnwrapping(ServiceProtocol.self, name: "alamofire")
            let fetchStarshipListWithURLSessionUseCase = resolver.resolveUnwrapping(FetchStarshipListWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchStarshipListWithAlamofireUseCase = resolver.resolveUnwrapping(FetchStarshipListWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            return StarshipListViewModel(model: model,
                                         fetchStarshipListWithURLSessionUseCase: fetchStarshipListWithURLSessionUseCase,
                                         fetchStarshipListWithAlamofireUseCase: fetchStarshipListWithAlamofireUseCase)
        }
        
        container.register(StarshipListViewControllerProtocol.self) { (resolver, model: StarshipListModel) in
            let viewModel = resolver.resolveUnwrapping(StarshipListViewModelProtocol.self, argument: model)
            return StarshipListViewController(viewModel: viewModel)
        }
        
        // MARK: - FilmListViewController
        
        container.register(FilmListViewModelProtocol.self) { (resolver, model: FilmListModel) in
            let urlSessionNetworking = resolver.resolveUnwrapping(ServiceProtocol.self, name: "urlsession")
            let alamofireNetworking = resolver.resolveUnwrapping(ServiceProtocol.self, name: "alamofire")
            let fetchFilmListWithURLSessionUseCase = resolver.resolveUnwrapping(FetchFilmListWithURLSessionUseCaseProtocol.self, argument: urlSessionNetworking)
            let fetchFilmListWithAlamofireUseCase = resolver.resolveUnwrapping(FetchFilmListWithAlamofireUseCaseProtocol.self, argument: alamofireNetworking)
            return FilmListViewModel(model: model,
                                     fetchFilmListWithURLSessionUseCase: fetchFilmListWithURLSessionUseCase,
                                     fetchFilmListWithAlamofireUseCase: fetchFilmListWithAlamofireUseCase)
        }
        
        container.register(FilmListViewControllerProtocol.self) { (resolver, model: FilmListModel) in
            let viewModel = resolver.resolveUnwrapping(FilmListViewModelProtocol.self, argument: model)
            return FilmListViewController(viewModel: viewModel)
        }
    }
}
