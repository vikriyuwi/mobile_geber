import Foundation
@testable import geber

class MockSwiftDataService {
    public var vehicles: [VehicleModel] = []
    
    func fetch() -> [VehicleModel] {
        return vehicles
    }
    
    func add(_ vehicle: VehicleModel) {
        vehicles.append(vehicle)
    }
    
    func remove(_ vehicle: VehicleModel) {
        vehicles.removeAll { $0.model == vehicle.model && $0.plateNumber == vehicle.plateNumber && $0.color == vehicle.color }
    }
}
