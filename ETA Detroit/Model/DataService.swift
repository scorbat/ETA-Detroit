//
//  DataService.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import Foundation
import SQLite

class DataService {
    
    //singleton structure so multiple connections aren't made
    public static let shared = DataService()
    
    private let db: Connection
    
    init() {
        do {
            let path = Bundle.main.path(forResource: K.SQLITE_FILE_NAME, ofType: "sqlite")!
            db = try Connection(path, readonly: true)
        } catch {
            fatalError("Error making database connection, \(error)")
        }
    }
    
    //fetches the list of companies monitored by the app
    func fetchCompanies() -> [Company] {
        var companies = [Company]()
        //create elements for query
        let companiesTable = Table("companies")
        let nameColumn = Expression<String>("name")
        let imageURLColumn = Expression<String>("bus_image_url")
        let id = Expression<Int>("id")
        
        do {
            for company in try db.prepare(companiesTable) {
                companies.append(
                    Company(
                        id: company[id],
                        name: company[nameColumn],
                        imageURL: company[imageURLColumn]
                    )
                )
            }
        } catch {
            print("Failed to perform query for companies, \(error)")
        }
        
        return companies
    }
    
    /**
        Fetches routes for a given company and returns an array of route models
     */
    func fetchRoutes(for company: Company) -> [Route] {
        var routes = [Route]()
        
        let routesTable = Table("routes")
        let number = Expression<Int>("route_number")
        let name = Expression<String>("route_name")
        let description = Expression<String?>("route_description")
        let id = Expression<Int>("id")
        let companyID = Expression<Int>("company_id")
        
        //select * from routes where id == company.id
        let query = routesTable.filter(companyID == company.id)
        
        do {
            for route in try db.prepare(query) {
                //create routes from row results
                routes.append(
                    Route(
                        id: route[id],
                        number: route[number],
                        name: route[name],
                        description: route[description]
                    )
                )
            }
        } catch {
            print("Failed to perform query for routes, \(error)")
        }
        
        return routes
    }
    
    /**
            Fetches stops from the database for a given route, and returns an
                array of Stop models
     */
    func fetchStops(for route: Route) -> [Stop] {
        var stops = [Stop]()
        
        let routeStopsTable = Table("route_stops")
        let routeID = Expression<Int>("route_id")
        let stopID = Expression<Int>("stop_id")
        
        let stopsTable = Table("stops")
        let name = Expression<String>("name")
        let latitude = Expression<Double>("latitude")
        let longitude = Expression<Double>("longitude")
        
        var query = routeStopsTable.filter(routeID == route.id)
        
        do {
            //store stop ids associated with given route
            var stopIDs = [Int]()
            
            for routeStop in try db.prepare(query) {
                stopIDs.append(routeStop[stopID])
            }
            
            //query the stops table to get other stop information
            query = stopsTable.filter(stopIDs.contains(stopID))
            for stop in try db.prepare(query) {
                stops.append(Stop(
                                id: stop[stopID],
                                name: stop[name],
                                latitude: stop[latitude],
                                longitude: stop[longitude]
                ))
            }
            
            print(stops)
        } catch {
            print("Failed to perform query for fetching route stops, \(error)")
        }
        
        return stops
    }
    
}
