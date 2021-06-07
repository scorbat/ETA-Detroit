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
    
}
