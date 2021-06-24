//
//  Constants.swift
//  ETA Detroit
//
//  Created by admin on 6/4/21.
//

import SwiftUI

struct K {
    
    //MARK: - Database Constants
    
    public static let SQLITE_FILE_NAME = "eta_detroit"
    
    public static let DATABASE_TIME_FORMAT = "HH:mm:ss"
    public static let DISPLAY_TIME_FORMAT = "hh:mm"
    
    //MARK: Table Names
    
    public static let COMPANIES_TABLE = "companies"
    public static let DAYS_TABLE = "days_of_operation"
    public static let DIRECTIONS_TABLE = "directions"
    public static let ROUTE_STOPS_TABLE = "route_stops"
    public static let ROUTES_TABLE = "routes"
    public static let STOPS_TABLE = "stops"
    public static let TRIPS_DAYS_TABLE = "trip_days_of_operation"
    public static let TRIP_STOPS_TABLE = "trip_stops"
    public static let TRIPS_TABLE = "trips"
    
    //MARK: Column Names
    
    public static let GENERAL_ID = "id" //this is the name for all id columns
    
    public static let COMPANIES_NAME = "name"
    public static let COMPANIES_IMAGE_URL = "bus_image_url"
    public static let COMPANIES_COLOR = "brand_color"
    
    public static let DAYS_OF_OPERATION_NAME = "day"
    
    public static let DIRECTIONS_NAME = "name"
    
    public static let ROUTES_NUMBER = "route_number"
    public static let ROUTES_COMPANY_ID = "company_id"
    public static let ROUTES_NAME = "route_name"
    public static let ROUTES_DESCRIPTION = "route_description"
    
    public static let ROUTE_STOPS_ROUTE_ID = "route_id"
    public static let ROUTE_STOPS_STOP_ID = "stop_id"
    public static let ROUTE_STOPS_DIRECTION_ID = "direction_id"
    public static let ROUTE_STOPS_DAY_ID = "day_id"
    
    public static let TRIPS_TRIP_ID = "trip_id"
    public static let TRIPS_ROUTE_ID = "route_id"
    public static let TRIPS_DIRECTION_ID = "direction_id"
    
    public static let TRIP_DAYS_DAY_ID = "operation_day_id"
    public static let TRIP_DAYS_TRIP_ID = "trip_id"
    
    public static let TRIP_STOPS_TRIP_ID = "trip_id"
    public static let TRIP_STOPS_STOP_ID = "stop_id"
    public static let TRIP_STOPS_ARRIVAL_TIME = "arrival_time"
    
    public static let STOPS_STOP_ID = "stop_id"
    public static let STOPS_NAME = "name"
    public static let STOPS_LATITUDE = "latitude"
    public static let STOPS_LONGITUDE = "longitude"
    
    //MARK: Value Constants
    
    public static let DAY_WEEKDAY = "weekday"
    public static let DAY_SATURDAY = "saturday"
    public static let DAY_SUNDAY = "sunday"
    public static let DAY_EVERYDAY = "everyday"
    
    public static let DIRECTION_SOUTH = "Southbound"
    public static let DIRECTION_NORTH = "Northbound"
    public static let DIRECTION_WEST = "Westbound"
    public static let DIRECTION_EAST = "Eastbound"
    public static let DIRECTION_ONEWAY = "Oneway"
    
    //MARK: - Map Constants
    
    public static let DETROIT_LATITUDE = 42.3314
    public static let DETROIT_LONGITUDE = -83.0458
    public static let LATITUDE_DELTA = 0.005
    public static let LONGITUDE_DELTA = 0.005
    
    //MARK: - Preview Constants
    
    public static let PREVIEW_COMPANY = Company(id: 2, name: "DDOT", imageURL: "ddot-logo", color: Color(hex: "#054839") ?? Color.purple)
    public static let PREVIEW_ROUTE = Route(id: 53, number: 1, name: "VERNOR", description: nil)
    public static let PREVIEW_STOP = Stop(stopID: 246, name: "Test stop", latitude: DETROIT_LATITUDE, longitude: DETROIT_LONGITUDE, day: "Test Stop", direction: "Westbound", route: PREVIEW_ROUTE)
    
}
