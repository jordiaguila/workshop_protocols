//
//  EditDistanceTests.swift
//  workshop_protocols
//
//  Created by Jordi Aguila on 28/11/16.
//  Copyright © 2016 Napptilus. All rights reserved.
//

import XCTest
@testable import workshop_protocols

class EditDistanceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDistance() {
        var str1 = "dog"
        var str2 = "dogs"
        
        //la distancia es 1 porque podemos insertar una "s" al final de "dog"
        //para obtener "dogs"
        XCTAssertEqual(EditDistance.distance(x: str1, y: str2), 1)
        
        str1 = "puppy"
        str2 = "lucky"
        
        //la distancia es 3 porque podemos intercambiar la "l" por la primera
        //"p", la "c" por la segunda "p" y la "k" por la tercera "p"
        XCTAssertEqual(EditDistance.distance(x: str1, y: str2), 3)
        
        str2 = ""
        XCTAssertEqual(EditDistance.distance(x: str1, y: str2), 5)
        
        str1 = ""
        XCTAssertEqual(EditDistance.distance(x: str1, y: str2), 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let cities = ["Barcelona", "Madrid", "Hospitalet de Llobregat",
                          "A Coruña"]
            
            //buscamos la ciudad más parecida a "L'Hospitalet"
            var city = "L'Hospitalet de Llobregat"
            var bestMatch : String?
            var bestDistance = Int.max
            for c in cities {
                let d = EditDistance.distance(x: c, y: city)
                
                if(d < bestDistance) {
                    bestDistance = d
                    bestMatch = c
                }
            }
            
            XCTAssertEqual(bestMatch, "Hospitalet de Llobregat")
            
            //buscamos la ciudad más parecida a "La Coruña"
            city = "La Coruña"
            bestMatch = nil
            bestDistance = Int.max
            for c in cities {
                let d = EditDistance.distance(x: c, y: city)
                
                if(d < bestDistance) {
                    bestDistance = d
                    bestMatch = c
                }
            }
            
            XCTAssertEqual(bestMatch, "A Coruña")
        }
    }
}
