

import Foundation

protocol IRouteDetailsViewModel {
    var vehicles:[Vehicle] {get set}
    var liveVehicleLocationsService: ILiveVehicleLocationsService { get }
    var routeDetailsOutput : RouteDetailsOutput? { get }
    
    func fetchVehiclesInRoute(service:Service, route:Route)
    func setDelegate(output: RouteDetailsOutput)
}

final class RouteDetailsViewModel:IRouteDetailsViewModel {
    var routeDetailsOutput: RouteDetailsOutput?
    var vehicles: [Vehicle] = []
    let liveVehicleLocationsService: ILiveVehicleLocationsService
    
    init(){
        liveVehicleLocationsService = LiveVehicleLocationsService()
    }
    
    func fetchVehiclesInRoute(service:Service, route:Route) {
        liveVehicleLocationsService.fetchVehiclesInRoute(service:service, route: route) { [weak self] (response) in
            self?.vehicles = response ?? []
            self?.routeDetailsOutput?.saveVehicles(values: self?.vehicles ?? [])
        }
    }
    
    func setDelegate(output: RouteDetailsOutput) {
        routeDetailsOutput = output
    }
}
