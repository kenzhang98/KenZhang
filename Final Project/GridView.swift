//
//  GridView.swift
//  Final Project
//
//  Created by Ken Zhang on 7/26/16.
//  Copyright © 2016 Ken Zhang. All rights reserved.
//

import Foundation
import UIKit

var lastTouch: Position = (0,0)

class GridView: UIView{
    
    //@IBinspectable is not mandatory in this assignment
    
    //set up variables
    
    var points:[(Int,Int)]? {
        get{
            var newValue: [(Int,Int)] = []
            _ = StandardEngine.sharedInstance.grid.cells.map{
                switch $0.state{
                case .Alive: newValue.append($0.position)
                case .Born: newValue.append($0.position)
                default: break
                }
            }
            return newValue
        }
        set(newValue){
            let rows = StandardEngine.sharedInstance.grid.rows
            let cols = StandardEngine.sharedInstance.grid.cols
            StandardEngine.sharedInstance.grid = Grid(rows,cols, cellInitializer: {_ in .Empty})
            if let points = newValue {
                _ = points.map{
                    StandardEngine.sharedInstance.grid[$0.0, $0.1] = .Alive
                }
            }
        }
        
    }
    
    var livingColor: UIColor = UIColor(red: 0/255, green: 239/255, blue:22/255, alpha: 1)
    var emptyColor: UIColor = UIColor.grayColor()
    var bornColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
    var diedColor: UIColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7)
    var gridColor: UIColor = UIColor.blackColor()
    var gridWidth: CGFloat = 2.0
    //instead of taking rows and cols as variables, replace them with StandardEngine.sharedInstance.rows and StandardEngine.sharedInstance.cols
    
    //override drawRect function
    override func drawRect(rect: CGRect){
        
        //set up the width and length variables for the vertical strokes
        let verHeight = gridWidth
        let verLength = bounds.height
        
        //create the path
        let verPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        verPath.lineWidth = verHeight
        
        //move the point of the path to the start of the vertical strokes with a for loop
        for x in 0...StandardEngine.sharedInstance.rows{
            verPath.moveToPoint(CGPoint(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth/2), y: 0))
            //add a point to the path at the end of vertical each stroke
            verPath.addLineToPoint(CGPoint(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth/2), y: verLength))
        }
        
        //set up the width and length variables for the horizontal strokes
        let horHeight = gridWidth
        let horLength = bounds.width
        
        //create the path
        let horPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        horPath.lineWidth = horHeight
        
        //move the point of the path to the start of the horizontal strokes with a for loop
        for y in 0...StandardEngine.sharedInstance.cols{
            horPath.moveToPoint(CGPoint(x: 0, y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth/2)))
            //add a point to the path at the end of each horizontal stroke
            horPath.addLineToPoint(CGPoint(x: horLength, y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth/2)))
        }
        
        //set the stroke color
        gridColor.setStroke()
        //draw the stroke
        verPath.stroke()
        horPath.stroke()

        
        switch (StandardEngine.sharedInstance.shape){
        case "Circle":
                //set up the tiny rectangles and then draw the circles
                for x in 0..<StandardEngine.sharedInstance.rows{
                    for y in 0..<StandardEngine.sharedInstance.cols{
                        let rectangle = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                        let path = UIBezierPath(ovalInRect: rectangle)
                        switch StandardEngine.sharedInstance.grid[(x,y)]{
                        case .Alive:
                            livingColor.setFill()
                        case .Born:
                            livingColor.setFill()
                            path.fill()
                            bornColor.setFill()
                        case .Died:
                            livingColor.setFill()
                            path.fill()
                            diedColor.setFill()
                        case .Empty:
                            emptyColor.setFill()
                        }
                        path.fill()
                    }
            }
        case "Triangle":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let triPath = UIBezierPath()
                    triPath.moveToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    triPath.addLineToPoint(CGPoint(x: container.maxX, y: container.maxY))
                    triPath.addLineToPoint(CGPoint(x: container.minX, y: container.maxY))
                    triPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        triPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        triPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    triPath.fill()
                }
            }
        case "Square":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let squPath = UIBezierPath()
                    squPath.moveToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    squPath.addLineToPoint(CGPoint(x: container.maxX, y: container.minY + h/2))
                    squPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.maxY))
                    squPath.addLineToPoint(CGPoint(x: container.minX, y: container.minY + h*0.5))
                    squPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        squPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        squPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    squPath.fill()
                }
            }
        case "Pentagon":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let penPath = UIBezierPath()
                    penPath.moveToPoint(CGPoint(x: container.minX, y: container.minY + h*0.381966))
                    penPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    penPath.addLineToPoint(CGPoint(x: container.maxX, y: container.minY + h*0.381966))
                    penPath.addLineToPoint(CGPoint(x: container.maxX - w*0.200811, y: container.maxY))
                    penPath.addLineToPoint(CGPoint(x: container.minX + w*0.200811, y: container.maxY))
                    penPath.addLineToPoint(CGPoint(x: container.minX, y: container.minY + h*0.381966))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        penPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        penPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    penPath.fill()
                }
            }
        case "Hexagon":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let hexPath = UIBezierPath()
                    hexPath.moveToPoint(CGPoint(x: container.minX, y: container.minY + h*0.250))
                    hexPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    hexPath.addLineToPoint(CGPoint(x: container.maxX, y: container.minY + h*0.250))
                    hexPath.addLineToPoint(CGPoint(x: container.maxX, y: container.maxY - h*0.250))
                    hexPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.maxY))
                    hexPath.addLineToPoint(CGPoint(x: container.minX, y: container.maxY  - h*0.250))
                    hexPath.addLineToPoint(CGPoint(x: container.minX, y: container.minY + h*0.250))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        hexPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        hexPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    hexPath.fill()
                }
            }
        case "Heptagon":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let hepPath = UIBezierPath()
                    hepPath.moveToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    hepPath.addLineToPoint(CGPoint(x: container.minX + w/2 + w * 0.41128, y: container.minY + container.height * 0.198064))
                    hepPath.addLineToPoint(CGPoint(x: container.maxX, y: container.maxY - h*0.32))
                    hepPath.addLineToPoint(CGPoint(x: container.maxX - w*0.32, y: container.maxY))
                    hepPath.addLineToPoint(CGPoint(x: container.minX + w*0.32, y: container.maxY))
                    hepPath.addLineToPoint(CGPoint(x: container.minX, y: container.maxY - h*0.32))
                    hepPath.addLineToPoint(CGPoint(x: container.minX + w/2 - w * 0.41128, y: container.minY + container.height * 0.198064))
                    hepPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        hepPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        hepPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    hepPath.fill()
                }
            }
        case "Octagon":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let octPath = UIBezierPath()
                    octPath.moveToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    octPath.addLineToPoint(CGPoint(x: container.maxX - w*0.146447, y: container.minY + h*0.146447))
                    octPath.addLineToPoint(CGPoint(x: container.maxX, y: container.minY + h*0.5))
                    octPath.addLineToPoint(CGPoint(x: container.maxX - w*0.146447, y: container.maxY - h*0.146447))
                    octPath.addLineToPoint(CGPoint(x: container.minX + w*0.5, y: container.maxY))
                    octPath.addLineToPoint(CGPoint(x: container.minX + w*0.146447, y: container.maxY - h*0.146447))
                    octPath.addLineToPoint(CGPoint(x: container.minX, y: container.minY + h * 0.5))
                    octPath.addLineToPoint(CGPoint(x: container.minX + w*0.146447, y: container.minY + h*0.146447))
                    octPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        octPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        octPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    octPath.fill()
                }
            }
        case "Nanogon":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let nonPath = UIBezierPath()
                    nonPath.moveToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w/2 + w*0.331386, y: container.minY + h*0.120615))
                    nonPath.addLineToPoint(CGPoint(x: container.maxX, y: container.minY + h*0.5))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w/2 + w*0.4, y: container.maxY - h*0.2))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w*0.5 + w*0.176327, y: container.maxY))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w*0.5 - w*0.176327, y: container.maxY))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w/2 - w*0.4, y: container.maxY - h*0.2))
                    nonPath.addLineToPoint(CGPoint(x: container.minX, y: container.minY + h*0.5))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w/2 - w*0.331386, y: container.minY + h*0.120615))
                    nonPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        nonPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        nonPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    nonPath.fill()
                }
            }
        case "Decagon":
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    //define the container
                    let container = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let w = container.width
                    let h = container.height
                    let decPath = UIBezierPath()
                    decPath.moveToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    decPath.addLineToPoint(CGPoint(x: container.minX + w/2 + w*0.2938926, y: container.minY + h*0.095492))
                    decPath.addLineToPoint(CGPoint(x: container.maxX, y: container.minY + h*0.345492))
                    decPath.addLineToPoint(CGPoint(x: container.maxX, y: container.maxY - h*0.345492))
                    decPath.addLineToPoint(CGPoint(x: container.minX + w/2 + w*0.2938926, y: container.maxY - h*0.095492))
                    decPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.maxY))
                    decPath.addLineToPoint(CGPoint(x: container.minX + w/2 - w*0.2938926, y: container.maxY - h*0.095492))
                    decPath.addLineToPoint(CGPoint(x: container.minX, y: container.maxY - h*0.345492))
                    decPath.addLineToPoint(CGPoint(x: container.minX, y: container.minY + h*0.345492))
                    decPath.addLineToPoint(CGPoint(x: container.minX + w/2 - w*0.2938926, y: container.minY + h*0.095492))
                    decPath.addLineToPoint(CGPoint(x: container.minX + w/2, y: container.minY))
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        decPath.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        decPath.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    decPath.fill()
                }
            }
        default:
            //set up the tiny rectangles and then draw the circles
            for x in 0..<StandardEngine.sharedInstance.rows{
                for y in 0..<StandardEngine.sharedInstance.cols{
                    let rectangle = CGRect(x: CGFloat(x) * (bounds.width - gridWidth) / CGFloat(StandardEngine.sharedInstance.rows) + CGFloat(gridWidth), y: CGFloat(y) * (bounds.height - gridWidth) / CGFloat(StandardEngine.sharedInstance.cols) + CGFloat(gridWidth), width: bounds.width / CGFloat(StandardEngine.sharedInstance.rows) - CGFloat(gridWidth), height: bounds.height / CGFloat(StandardEngine.sharedInstance.cols) - CGFloat(gridWidth))
                    let path = UIBezierPath(ovalInRect: rectangle)
                    switch StandardEngine.sharedInstance.grid[(x,y)]{
                    case .Alive:
                        livingColor.setFill()
                    case .Born:
                        livingColor.setFill()
                        path.fill()
                        bornColor.setFill()
                    case .Died:
                        livingColor.setFill()
                        path.fill()
                        diedColor.setFill()
                    case .Empty:
                        emptyColor.setFill()
                    }
                    path.fill()
                }
            }
        }
    }
    //drawRec function finishes here
    
    
    
    //implement touch handling function of Problem 5
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
            let point = touch.locationInView(self)
            let cellWidth = Double(bounds.width) / Double(StandardEngine.sharedInstance.rows)
            let cellHeight = Double(bounds.height) / Double(StandardEngine.sharedInstance.cols)
            let xCo = Int(floor(Double(point.x) / cellWidth))
            let yCo = Int(floor(Double(point.y) / cellHeight))
            lastTouch = (xCo,yCo)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            let point = touch.locationInView(self)
            let cellWidth = Double(bounds.width) / Double(StandardEngine.sharedInstance.rows)
            let cellHeight = Double(bounds.height) / Double(StandardEngine.sharedInstance.cols)
            let xCo = Int(floor(Double(point.x) / cellWidth))
            let yCo = Int(floor(Double(point.y) / cellHeight))
            let newPoint: Position = (xCo,yCo)
            
            if newPoint != lastTouch{
                self.processTouch(touch)
                lastTouch = newPoint
            }
        }
    }
    
    
    func processTouch(touch: UITouch) {
        let point = touch.locationInView(self)
        let cellWidth = Double(bounds.width) / Double(StandardEngine.sharedInstance.rows)
        let cellHeight = Double(bounds.height) / Double(StandardEngine.sharedInstance.cols)
        let xCo = Int(floor(Double(point.x) / cellWidth))
        let yCo = Int(floor(Double(point.y) / cellHeight))
        
        // if the point is not out of boundaries, then toggle the cell that user picks
        if xCo <= StandardEngine.sharedInstance.rows-1 && yCo <= StandardEngine.sharedInstance.cols-1 && xCo >= 0 && yCo >= 0 {
            StandardEngine.sharedInstance.grid[xCo, yCo] = CellState.toggle(StandardEngine.sharedInstance.grid[xCo, yCo])
            
            //save the cells that user just editted so that user can undo and redo later
            let col = StandardEngine.sharedInstance.cols
            let cellToBeChanged = StandardEngine.sharedInstance.grid.cells[xCo * col + yCo]
            StandardEngine.sharedInstance.undoCells.append(cellToBeChanged.position)
        }
        let gridToBeChanged = CGRect(x: CGFloat(Double(xCo) * cellWidth), y: CGFloat(Double(yCo) * cellHeight), width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        
        NSNotificationCenter.defaultCenter().postNotificationName("setEngineStatisticsNotification", object: nil, userInfo: nil)
        
        self.setNeedsDisplayInRect(gridToBeChanged)
    }
}

