import Auth
import BasicLocalStorage
import Calendar
import Courses
import Dashboard
import Database
import Foundation
import InstanceProvider
import UserSDK
import UserAccount
import SecureStorage
import Swinject

let instanceProvider: InstanceProvider = {
    let assemblies: [Assembly] = [
        InstanceProviderAssembly(),
        MainViewAssembly(),
        AuthAssembly(),
        UserSDKAssembly(),
        DatabaseAssembly(),
        BasicStorageAssembly(),
        SecureStorageAssembly(),
        ClassesAssembly(),
        CalendarAssembly(),
        DashboardAssembly(),
        UserAccountAssembly()
    ]
    
    let assembler = Assembler()
    assembler.apply(assemblies: assemblies)

    return assembler.resolver.resolve(InstanceProvider.self)!
}()

public struct AppStart {
    
    public init() {}
        
    func startApp() {
        print("tada")
        
    }
}

//public struct AppStart {
//
//    private var appAssemblies: [Assembly] = [
//        LoggerAssembly(),
//        InstanceProviderAssembly(),
//        CounterAssembly(),
//        CounterSelectionAssembly(),
//        CounterPreferencesAssembly()
//    ]
//
//    public init() { }
//
//    public func startApp<Instance>() -> Instance {
//        let assembler = Assembler()
//        assembler.apply(assemblies: appAssemblies)
//        return assembler.resolver.resolve(Instance.self)!
//    }
//}

