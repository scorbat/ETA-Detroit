//
//  DataService.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import SwiftUI
import SQLite

class DataService: ObservableObject {
    
    @Published var companies = [Company]()
    @Published var routes = [Route]()
    @Published var stops = [Stop]()
    
    var weekdayStops: [Stop] {
        return runStopFilter(.weekday)
    }
    
    var saturdayStops: [Stop] {
        return runStopFilter(.saturday)
    }
    
    var sundayStops: [Stop] {
        return runStopFilter(.sunday)
    }
    
    var everydayStops: [Stop] {
        return runStopFilter(.everyday)
    }
    
    private let db: Connection
    
    init() {
        do {
            let path = Bundle.main.path(forResource: K.SQLITE_FILE_NAME, ofType: "sqlite")!
            db = try Connection(path, readonly: true)
        } catch {
            fatalError("Error making database connection, \(error)")
        }
    }
    
    //MARK: - Database Methods
    
    //fetches the list of companies monitored by the app
    func fetchCompanies() {
        var companies = [Company]()
        //create elements for query
        let companiesTable = Table("companies")
        let nameColumn = Expression<String>("name")
        let imageURLColumn = Expression<String>("bus_image_url")
        let color = Expression<String>("brand_color")
        let id = Expression<Int>("id")
        
        do {
            for company in try db.prepare(companiesTable) {
                //get color using extension for hex init
                let hexColor = Color(hex: company[color]) ?? Color.purple //default purple
                
                companies.append(
                    Company(
                        id: company[id],
                        name: company[nameColumn],
                        imageURL: company[imageURLColumn],
                        color: hexColor
                    )
                )
            }
        } catch {
            print("Failed to perform query for companies, \(error)")
        }
        
        self.companies = companies
    }
    
    /**
        Fetches routes for a given company and returns an array of route models
     */
    func fetchRoutes(for company: Company) {
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
        
        self.routes = routes
    }
    
    /**
            Fetches stops from the database for a given route, and returns an
                array of Stop models
     */
    func fetchStops(for route: Route, filter: StopFilter) {
        var stops = [Stop]()
        
        let routeStopsTable = Table("route_stops")
        let routeID = Expression<Int>("route_id")
        let stopID = Expression<Int>("stop_id")
        let dayID = Expression<Int>("day_id")
        let directionID = Expression<Int>("direction_id")
        
        let query = routeStopsTable.filter(routeID == route.id)
        
        do {
            for routeStop in try db.prepare(query) {
                stops.append(
                    Stop(
                        stopID: routeStop[stopID],
                        day: getDayName(for: routeStop[dayID]),
                        direction: getDirectionName(for: routeStop[directionID])
                    )
                )
            }
        } catch {
            print("Failed to perform query for fetching route stops, \(error)")
        }
        
        self.stops = stops
    }
    
    /**
     Fetches table of days of operation from database
     */
    private func fetchDaysOfOperation() -> [Int : String] {
        var days = [Int : String]()
        
        let daysTable = Table("days_of_operation")
        let id = Expression<Int>("id")
        let name = Expression<String>("day")
        
        for day in try! db.prepare(daysTable) {
            days[day[id]] = day[name]
        }
      
        return days
    }
    
    /**
     returns the info for a given stop based on the stop id
     info returned includes the name and coordinates of the stop
     */
    func getStopInfo(for stop: Stop) -> (name: String, latitude: Double, longitude: Double)? {
        let stopsTable = Table("stops")
        let id = Expression<Int>("stop_id")
        let name = Expression<String>("name")
        let latitude = Expression<Double>("latitude")
        let longitude = Expression<Double>("longitude")
        
        let query = stopsTable.filter(id == stop.stopID)
        
        if let entry = try? db.pluck(query) {
            return (
                name: entry[name],
                latitude: entry[latitude],
                longitude: entry[longitude]
            )
        }
        
        return nil
    }
    
    /**
     returns the name of a given direction ID from the database
     */
    func getDirectionName(for directionID: Int) -> String {
        let directionsTable = Table("directions")
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        
        let query = directionsTable.filter(id == directionID)
        
        let entry = try! db.pluck(query)!
        
        return entry[name]
    }
    
    func getDayName(for dayID: Int) -> String {
        let daysTable = Table("days_of_operation")
        let id = Expression<Int>("id")
        let name = Expression<String>("day")
        
        let query = daysTable.filter(id == dayID)
        
        let entry = try! db.pluck(query)!
        
        return entry[name]
    }
    
    //MARK: - Utility functions
    
    private func runStopFilter(_ filter: StopFilter) -> [Stop] {
        return stops.filter(filter.filterMethod)
    }
    
    func availableDays() -> Int {
        var count = 0
        
        //if a list is empty, then it is not an available day
        count += weekdayStops.isEmpty ? 0 : 1
        count += saturdayStops.isEmpty ? 0 : 1
        count += sundayStops.isEmpty ? 0 : 1
        count += everydayStops.isEmpty ? 0 : 1
        
        return count
    }
    
}

//MARK: - Stop Filter Type

/**
 Represents a day filter to apply to Stop arrays.  Essentially a wrapper for a filter method to allow easier readability
 where the filters are used. E.g. the ability to use .none or .weekday in code
 */
struct StopFilter {
    
    let filterMethod: (Stop) -> Bool
    
    static let none = StopFilter { _ in
        return true
    }
    
    static let weekday = StopFilter { stop in
        return compareIgnoreCase(stop.day, to: K.DAY_WEEKDAY)
    }
    
    static let saturday = StopFilter { stop in
        return compareIgnoreCase(stop.day, to: K.DAY_SATURDAY)
    }
    
    static let sunday = StopFilter { stop in
        return compareIgnoreCase(stop.day, to: K.DAY_SUNDAY)
    }
    
    static let everyday = StopFilter { stop in
        return compareIgnoreCase(stop.day, to: K.DAY_EVERYDAY)
    }
    
}
