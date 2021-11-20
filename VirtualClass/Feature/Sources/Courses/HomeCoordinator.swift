//
//  HomeCoordinator.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import Foundation
import InstanceProvider
import UserSDK

final class HomeCoordinator: ObservableObject {
    
    enum ActiveScreen: Hashable, Identifiable {
        case courseDetail(CourseDetailViewModel)
        case addingClass
        
        var id: Self {
            self
        }
    }
    
    // MARK: - Coordinator to View
    
    @Published var activeScreen: ActiveScreen? = nil
        
    // MARK: - Private
    
    @Published var classCardViewModel: CourseCardsOverviewViewModel
    @Published private var classDetailViewModel: CourseDetailViewModel?
    @Published private var classSearchViewModel: CourseSearchViewModel?
        
    private let instanceProvider: InstanceProvider
    
    private var bag = Set<AnyCancellable>()
    private var classSearchBag = Set<AnyCancellable>()
    private var classDetailBag = Set<AnyCancellable>()

    init(instanceProvider: InstanceProvider, classCardViewModel: CourseCardsOverviewViewModel) {
        self.instanceProvider = instanceProvider
        self.classCardViewModel = classCardViewModel
        
        setupBindings()
    }
    
    private func setupBindings() {
        classCardViewModel.addClassButtonTap
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.classSearchViewModel = self.instanceProvider.resolve(CourseSearchViewModel.self)
                self.activeScreen = .addingClass
            })
            .store(in: &bag)
        
        classCardViewModel.classCardTap
            .sink(receiveValue: { [weak self] course in
                guard let self = self else { return }
                
                let courseDetailModel = course.asCourseDetailModel
                let viewModel = CourseDetailViewModel(
                    removeCourseFromStudiedUseCase: self.instanceProvider.resolve(RemoveCourseFromStudiedUseCaseType.self),
                    markCourseCompleteUseCase: self.instanceProvider.resolve(MarkCourseCompleteUseCaseType.self),
                    courseDetail: courseDetailModel
                )
                
                self.classDetailViewModel = viewModel
                self.activeScreen = .courseDetail(viewModel)
            })
            .store(in: &bag)
        
        $classSearchViewModel
            .compactMap { $0 }
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classSearchBag.removeAll()
                    
                    viewModel.goBackTap
                        .merge(with: viewModel.classedAddedSuccessfully)
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.classSearchViewModel = nil
                            self.activeScreen = .none
                        })
                        .store(in: &self.classSearchBag)
                }
            )
            .store(in: &bag)
        
        $classDetailViewModel
            .compactMap { $0 }
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.classDetailBag.removeAll()
                    
                    viewModel.goBackTap
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.classDetailViewModel = nil
                            self.activeScreen = .none
                        })
                        .store(in: &self.classDetailBag)
                }
            )
            .store(in: &bag)
    }
}

extension GenericCourse {
    var asCourseDetailModel: CourseDetailModel {
        CourseDetailModel(
            ident: self.ident,
            name: self.name,
            description: self.description,
            lecturers: self.teachers.asClassDetailModel,
            lessons: self.lessons.asClassDetailModel,
            credits: self.credits
        )
    }
}

extension Set where Element == Date {
    var asClassDetailModel: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM, HH:mm"
        
        return map(dateFormatter.string)
    }
}

extension Set where Element == GenericTeacher {
    var asClassDetailModel: [String] {
        map(\.name)
    }
}
