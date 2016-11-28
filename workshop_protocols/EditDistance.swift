//
//  EditDistance.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 24/11/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//


import Foundation


/**
 Clase de utilidad que permite calcular la distancia de Levenshtein (número
 de sustituciones/modificaciones entre dos arrays o strings.
 La distancia de Levenshtein es una medida de comparación aproximada que tiene
 en cuenta el número de modificaciones, elementos añadidos o eliminados que se
 requieren para hacer que dos colecciones de elementos sean iguales. Por lo
 tanto, esta medida de distancia es apropiada para comparar Strings similares
 pero no exactamente iguales (para tener en cuenta errores tipográficos, de
 ortografía, etc).
 */
public class EditDistance {
    
    /**
     Calcula la distance de Levenshtein entre dos Strings.
     - param x: el primer String.
     - param y: el segundo String.
     - returns: la distancia de Levenshtein.
     */
    public static func distance(x: String, y: String) -> Int {
        return internalDistance(x: x, y: y)
    }
    
    /**
     Método interno que calcula la distancia de Levenshtein entre dos
     EditDistanceMeasurable.
     Se puede utilizar este método con cualquier tipo de datos que implemente
     el protocolo EditDistanceMeasurable.
     - param x: el primer EditDistanceMeasurable.
     - param y: el segundo EditDistanceMeasurable.
     - returns: la distancia de Levenshtein.
     */
    internal static func internalDistance(x: EditDistanceMeasurable,
                                          y: EditDistanceMeasurable) -> Int {
        
        //obtenemos la longitud de ambos. Si uno de los dos es 0, devolvemos
        //la longitud del otro, puesto que se requerirá ese número de
        //inserciones
        let n = x.count(), m = y.count()
        
        if n == 0 {
            return m
        }
        if m == 0 {
            return n
        }
        
        //en lugar de mantener una matriz entera (lo cual requeriría un espacio
        //en memoria O(n*m)) simplemente se guarda la fila actual y la
        //siguiente, cada una de las cuales tiene una longitud m+1, así sólo
        //hace falta una cantidad de espacio O(m).
        
        //Inicializa la fila actual
        var curRow = 0, nextRow = 1
        var rows = [[Int](repeating: 0, count: m + 1),
                    [Int](repeating: 0, count: m+1)]
        for j in 0...m {
            rows[curRow][j] = j
        }
        
        //para cada fila virtual (puesto que sólo almacenamos dos)
        for i in 1...n {
            //rellena los valores de la fila
            rows[nextRow][0] = i
            for j in 1...m {
                let dist1 = rows[curRow][j] + 1
                let dist2 = rows[nextRow][j - 1] + 1
                let dist3 = rows[curRow][j - 1] +
                    (x.equalsAtPositions(other: y, posX: i - 1, posY: j - 1) ?
                        0 : 1)
                
                rows[nextRow][j] = min(dist1, min(dist2, dist3))
            }
            
            //intercambia la fila actual y la siguiente
            if curRow == 0 {
                curRow = 1
                nextRow = 0
            } else {
                curRow = 0
                nextRow = 1
            }
        }
        
        //devuelve la distancia calculada
        return rows[curRow][m]
    }
}


/**
 Protocolo que permite comprar elementos de un string.
 Todos los strings utilizados por EditDistance deben seguir este protocolo.
 */
internal protocol EditDistanceMeasurable {
    
    /**
     Obtiene la longitud del String a medir.
     */
    func count() -> Int
    
    /**
     Compara este EditDistanceMeasurable con otro proporcionado en las
     posiciones indicadas.
     - param other: otro string a comparar con este.
     - param posX: posición en este EditDistanceMeasurable que debe compararse.
     - param posY: posición en el otro EditDistanceMeasurable que debe
     compararse.
     - returns: true si ambos EditDistanceMeasurable son iguales en las
     posiciones indicadas.
     */
    func equalsAtPositions(other: EditDistanceMeasurable, posX: Int, posY: Int)
        -> Bool
}


/**
 * Extensión para hacer que un String pueda utilizarse con EditDistance.
 */
extension String : EditDistanceMeasurable {
    
    /**
     Obtiene la longitud del String a medir.
     */
    internal func count() -> Int {
        return self.characters.count
    }
    
    /**
     Compara este MeasurableString con otro proporcionado en las posiciones
     indicadas.
     - param other: otro string a comparar con este.
     - param posX: posición en este MeasurableString que debe compararse.
     - param posY: posición en el otro MeasurableString que debe compararse.
     - returns: true si ambos MeasurableStrings son iguales en las posiciones
     indicadas.
     */
    internal func equalsAtPositions(other: EditDistanceMeasurable, posX: Int,
                                    posY: Int) -> Bool {
        guard other is String else {
            return false
        }
        
        let otherString = other as! String
        
        let index1 = self.characters.index(self.startIndex, offsetBy: posX)
        let index2 = otherString.index(otherString.startIndex, offsetBy: posY)
        let c1 = self[index1]
        let c2 = otherString[index2]
        
        return c1 == c2
    }
    
}
