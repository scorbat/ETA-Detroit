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
    @Published var times = [Date]()

    var days = [String]()
    var directions = [String]()
    private var dirPointer = 0
    
    var selectedDay: String? = nil
    var selectedDirection: String? = nil
    
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
    func fetchStops(for route: Route) {
        var stops = [Stop]()
        
        let routeStopsTable = Table("route_stops")
        let routeID = Expression<Int>("route_id")
        let stopID = Expression<Int>("stop_id")
        let dayID = Expression<Int>("day_id")
        let directionID = Expression<Int>("direction_id")
        
        //stop view has additional parameters, grouped by day and direction
        var query = routeStopsTable.filter(routeID == route.id)
        
        if let safeDay = selectedDay {
            query = query.filter(dayID == getDayID(for: safeDay))
        }
        
        if let safeDirection = selectedDirection {
            query = query.filter(directionID == getDirectionID(for: safeDirection))
        }
        
        do {
            //get stops
            for routeStop in try db.prepare(query) {
                stops.append(
                    Stop(
                        stopID: routeStop[stopID],
                        day: getDayName(for: routeStop[dayID]),
                        direction: getDirectionName(for: routeStop[directionID]),
                        route: route
                    )
                )
            }
        } catch {
            print("Failed to perform query for fetching route stops, \(error)")
        }
        
        self.stops = stops
    }
    
    /**
     Fetches the relevant directions and days of operation for a given route
     */
    func fetchRouteData(for route: Route) {
        var days = [String]()
        var directions = [String]()
        
        let routeStopsTable = Table("route_stops")
        let routeID = Expression<Int>("route_id")
        let dayID = Expression<Int>("day_id")
        let directionID = Expression<Int>("direction_id")
        
        let baseQuery = routeStopsTable.filter(routeID == route.id)
        
        let dayQuery = baseQuery
            .select(dayID)
            .group(dayID)
        let directionQuery = baseQuery
            .select(directionID)
            .group(directionID)
        
        do {
            //get group of days
            for day in try db.prepare(dayQuery) {
                days.append(getDayName(for: day[dayID]))
            }
            
            //get group of directions
            for direction in try db.prepare(directionQuery) {
                directions.append(getDirectionName(for: direction[directionID]))
            }
        } catch {
            print("Failed fetching route data, \(error)")
        }
        
        self.days = days
        self.directions = directions
        
        //set defaults if they don't exist
        if selectedDay == nil {
            selectedDay = days[0]
        }
        
        if selectedDirection == nil {
            selectedDirection = directions[0]
        }
    }
    
    func fetchStopTimes(for stop: Stop) -> [Double] {
        var times = [Double]()
        
        let table = Table("trip_stops")
        let tripID = Expression<Int>("trip_id")
        let stopID = Expression<Int>("stop_id")
        let time = Expression<String>("arrival_time")
        
        let tripIDs = getTripIDs(for: stop.direction, on: stop.route)
        
        let query = table
            .filter(stopID == stop.stopID)
            .filter(tripIDs.contains(tripID))
            .order(time)
        
        do {
            for entry in try db.prepare(query) {
                let date = stringToDate(entry[time])
                
                if let diff = date?.compareTimeToNow() {
                    times.append(diff)
                }
            }
            
            times = times.sorted()
            
            //remove negative values
            times = times.filter { value in
                return value >= 0
            }
        } catch {
            print("Failed to fetch stop times, \(error)")
        }
        
        return times
    }
    
    /**
     Returns an array of trip ids that have the given direction
     */
    func getTripIDs(for direction: String, on route: Route) -> [Int] {
        var tripIDs = [Int]()
        
        let table = Table("trips")
        let tripIDColumn = Expression<Int>("id")
        let routeIDColumn = Expression<Int>("route_id")
        let directionColumn = Expression<Int>("direction_id")
        
        let directionID = getDirectionID(for: direction)
        
        let query = table
            .filter(routeIDColumn == route.id)
            .filter(directionColumn == directionID)
        
        do {
            for entry in try db.prepare(query) {
                tripIDs.append(entry[tripIDColumn])
            }
        } catch {
            print("Error fetching trip ids, \(error)")
        }
        
        return tripIDs
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
    
    func getDirectionID(for direction: String) -> Int {
        let directionsTable = Table("directions")
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        
        let query = directionsTable.filter(name == direction)
        
        let entry = try! db.pluck(query)!
        
        return entry[id]
    }
    
    func getDayName(for dayID: Int) -> String {
        let daysTable = Table("days_of_operation")
        let id = Expression<Int>("id")
        let name = Expression<String>("day")
        
        let query = daysTable.filter(id == dayID)
        
        let entry = try! db.pluck(query)!
        
        return entry[name]
    }
    
    func getDayID(for day: String) -> Int {
        let dayTable = Table("days_of_operation")
        let id = Expression<Int>("id")
        let name = Expression<String>("day")
        
        let query = dayTable.filter(name == day)
        
        let entry = try! db.pluck(query)!
        
        return entry[id]
    }
    
    //MARK: - Utility functions
    
    func toggleDirection() {
        dirPointer += 1
        
        if dirPointer == directions.count {
            dirPointer = 0
        }
        
        selectedDirection = directions[dirPointer]
    }
    
    func getDirectionIcon() -> String {
        if let direction = selectedDirection {
            switch direction {
            case K.DIRECTION_NORTH:
                return "up"
            case K.DIRECTION_SOUTH:
                return "down"
            case K.DIRECTION_WEST:
                return "left"
            case K.DIRECTION_EAST:
                return "right"
            default:
                return "left"
            }
        }
        
        return "left"
    }
    
    private func stringToDate(_ value: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: value)
    }
    
}
