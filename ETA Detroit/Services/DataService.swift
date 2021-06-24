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
        let companiesTable = Table(K.COMPANIES_TABLE)
        let nameColumn = Expression<String>(K.COMPANIES_NAME)
        let imageURLColumn = Expression<String>(K.COMPANIES_IMAGE_URL)
        let color = Expression<String>(K.COMPANIES_COLOR)
        let id = Expression<Int>(K.GENERAL_ID)
        
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
        
        let routesTable = Table(K.ROUTES_TABLE)
        let number = Expression<Int>(K.ROUTES_NUMBER)
        let name = Expression<String>(K.ROUTES_NAME)
        let description = Expression<String?>(K.ROUTES_DESCRIPTION)
        let id = Expression<Int>(K.GENERAL_ID)
        let companyID = Expression<Int>(K.ROUTES_COMPANY_ID)
        
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
        
        let routeStopsTable = Table(K.ROUTE_STOPS_TABLE)
        let routeID = Expression<Int>(K.ROUTE_STOPS_ROUTE_ID)
        let stopID = Expression<Int>(K.ROUTE_STOPS_STOP_ID)
        let dayID = Expression<Int>(K.ROUTE_STOPS_DAY_ID)
        let directionID = Expression<Int>(K.ROUTE_STOPS_DIRECTION_ID)
        
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
                //get data from separate table about name, coordinates
                guard let stopInfo = getStopInfo(for: routeStop[stopID]) else {
                    return
                }
                
                stops.append(
                    Stop(
                        stopID: routeStop[stopID],
                        name: stopInfo.name,
                        latitude: stopInfo.latitude,
                        longitude: stopInfo.longitude,
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
        
        let routeStopsTable = Table(K.ROUTE_STOPS_TABLE)
        let routeID = Expression<Int>(K.ROUTE_STOPS_ROUTE_ID)
        let dayID = Expression<Int>(K.ROUTE_STOPS_DAY_ID)
        let directionID = Expression<Int>(K.ROUTE_STOPS_DIRECTION_ID)
        
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
    
    func fetchStopTimes(for stop: Stop) -> [Date] {
        var times = [Date]()
        
        let table = Table(K.TRIP_STOPS_TABLE)
        let tripID = Expression<Int>(K.TRIP_STOPS_TRIP_ID)
        let stopID = Expression<Int>(K.TRIP_STOPS_STOP_ID)
        let time = Expression<String?>(K.TRIP_STOPS_ARRIVAL_TIME) //some arrival times are null
        
        let tripIDs = getTripIDs(for: stop, on: stop.route)
        
        let query = table
            .filter(stopID == stop.stopID)
            .filter(tripIDs.contains(tripID))
            .order(time)
        
        do {
            for entry in try db.prepare(query) {
                if let arrival = entry[time], let date = DateService.stringToDate(arrival) {
                    times.append(date)
                }
            }
            
            //sort by nearest time to furthest
            times.sort { date1, date2 in
                return date1.compareTimeToNow() < date2.compareTimeToNow()
            }
            
            //remove times that already happened
            times = times.filter { value in
                return value.compareTimeToNow() >= 0
            }
        } catch {
            print("Failed to fetch stop times, \(error)")
        }
        
        return times
    }
    
    /**
     Returns an array of trip ids that have the given direction
     */
    func getTripIDs(for stop: Stop, on route: Route) -> [Int] {
        //use two arrays since these data are stored in separate tables
        var tripIDsByDirection = [Int]()
        var tripsIDsByDay = [Int]()
        
        let tripsTable = Table(K.TRIPS_TABLE)
        let tripsDaysTable = Table(K.TRIPS_DAYS_TABLE)
        let dayIDColumn = Expression<Int>(K.TRIP_DAYS_DAY_ID)
        let tripDayIDColumn = Expression<Int>(K.TRIP_DAYS_DAY_ID)
        let tripIDColumn = Expression<Int>(K.GENERAL_ID)
        let routeIDColumn = Expression<Int>(K.TRIPS_ROUTE_ID)
        let directionColumn = Expression<Int>(K.TRIPS_DIRECTION_ID)
        
        let directionID = getDirectionID(for: stop.direction)
        
        //want trips only in correct direction
        let directionQuery = tripsTable
            .filter(routeIDColumn == route.id)
            .filter(directionColumn == directionID)
        
        //query to get trips on correct day
        let dayID = getDayID(for: stop.day)
        let dayQuery = tripsDaysTable
            .filter(dayIDColumn == dayID)
        
        do {
            //get trip ids for given direction
            for entry in try db.prepare(directionQuery) {
                tripIDsByDirection.append(entry[tripIDColumn])
            }
            
            //get trip ids for given day
            for entry in try db.prepare(dayQuery) {
                tripsIDsByDay.append(entry[tripDayIDColumn])
            }
        } catch {
            print("Error fetching trip ids, \(error)")
        }
        
        //return intersection of the two arrays
        return tripIDsByDirection.filter(tripsIDsByDay.contains)
    }
    
    /**
     returns the info for a given stop based on the stop id
     info returned includes the name and coordinates of the stop
     */
    func getStopInfo(for stopID: Int) -> (name: String, latitude: Double, longitude: Double)? {
        let stopsTable = Table(K.STOPS_TABLE)
        let id = Expression<Int>(K.STOPS_STOP_ID)
        let name = Expression<String>(K.STOPS_NAME)
        let latitude = Expression<Double>(K.STOPS_LATITUDE)
        let longitude = Expression<Double>(K.STOPS_LONGITUDE)
        
        let query = stopsTable.filter(id == stopID)
        
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
        let directionsTable = Table(K.DIRECTIONS_TABLE)
        let id = Expression<Int>(K.GENERAL_ID)
        let name = Expression<String>(K.DIRECTIONS_NAME)
        
        let query = directionsTable.filter(id == directionID)
        
        let entry = try! db.pluck(query)!
        
        return entry[name]
    }
    
    func getDirectionID(for direction: String) -> Int {
        let directionsTable = Table(K.DIRECTIONS_TABLE)
        let id = Expression<Int>(K.GENERAL_ID)
        let name = Expression<String>(K.DIRECTIONS_NAME)
        
        let query = directionsTable.filter(name == direction)
        
        let entry = try! db.pluck(query)!
        
        return entry[id]
    }
    
    func getDayName(for dayID: Int) -> String {
        let daysTable = Table(K.DAYS_TABLE)
        let id = Expression<Int>(K.GENERAL_ID)
        let name = Expression<String>(K.DAYS_OF_OPERATION_NAME)
        
        let query = daysTable.filter(id == dayID)
        
        let entry = try! db.pluck(query)!
        
        return entry[name]
    }
    
    func getDayID(for day: String) -> Int {
        let dayTable = Table(K.DAYS_TABLE)
        let id = Expression<Int>(K.GENERAL_ID)
        let name = Expression<String>(K.DAYS_OF_OPERATION_NAME)
        
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
    
}
