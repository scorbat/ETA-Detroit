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
        
        do {
            for company in try db.prepare(companiesTable) {
                companies.append(
                    Company(
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
    
}
