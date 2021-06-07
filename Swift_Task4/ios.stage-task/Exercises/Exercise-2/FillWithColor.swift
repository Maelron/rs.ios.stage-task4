import Foundation

final class FillWithColor {
    
    var visited: [[Bool]] = [[]]
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        let rowsCount = image.count
        let columnsCount = image[0].count
        
        if (image.first == nil || row >= rowsCount || column >= columnsCount || row < 0 || column < 0) {
            return image
        }
        
        var resultImage = image
        let initialColor = image[row][column]
        
        visited = Array(repeating: Array(repeating: false, count: columnsCount), count: rowsCount)
        visited[row][column] = true
        resultImage[row][column] = newColor
        checkNeighbor(&resultImage, row, column, initialColor, newColor)
        
        return resultImage
    }
    
    func checkNeighbor(_ image: inout [[Int]], _ row: Int, _ column: Int, _ initialColor: Int, _ newColor: Int) {
        
//        check top neighbor
        if row != 0 {
            if (!visited[row - 1][column] && image[row - 1][column] == initialColor) {
                image[row - 1][column] = newColor
                checkNeighbor(&image, row - 1, column, initialColor, newColor)
            }
        }
        
//        check bottom neighbor
        if row < image.count - 1 {
            if (!visited[row + 1][column] && image[row + 1][column] == initialColor) {
                image[row + 1][column] = newColor
                checkNeighbor(&image, row + 1, column, initialColor, newColor)
            }
        }
        
//        check left neighbor
        if column != 0 {
            if (!visited[row][column - 1] && image[row][column - 1] == initialColor) {
                image[row][column - 1] = newColor
                checkNeighbor(&image, row, column - 1, initialColor, newColor)
            }
        }
        
//        check right neighbor
        if column < image[0].count - 1 {
            if (!visited[row][column + 1] && image[row][column + 1] == initialColor) {
                image[row][column + 1] = newColor
                checkNeighbor(&image, row, column + 1, initialColor, newColor)
            }
        }
        
    }
    
}
