import InstanceProvider
import Swinject
import Auth

public struct AppStart {
    
    private var assemblies: [Assembly] = [
        InstanceProviderAssembly(),
        MainViewAssembly(),
        AuthAssembly()
    ]
    
    public init() {}
    
    func startApp<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: assemblies)
        
        return assembler.resolver.resolve(Instance.self)!
    }
}
