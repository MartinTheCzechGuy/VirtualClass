import InstanceProvider
import Swinject
import Login

public struct AppStart {
    
    private var assemblies: [Assembly] = [
        InstanceProviderAssembly(),
        LoginAssembly()
    ]
    
    public init() {}
    
    func startApp<Instance>() -> Instance {
        let assembler = Assembler()
        assembler.apply(assemblies: assemblies)
        
        return assembler.resolver.resolve(Instance.self)!
    }
}
