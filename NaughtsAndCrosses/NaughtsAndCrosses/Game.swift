//
//  Game.swift
//  NaughtsAndCrosses
//
//  Created by Brian McCarthy on 04/12/2017.
//  Copyright © 2017 Brian McCarthy. All rights reserved.
//

import Foundation
import SpriteKit

class Human {
    var playerID: Int
    
    init() {
        playerID = Constants.player1_ID
    }
}

enum STATE {
    case PLAYING, PLAYER_1_WON, PLAYER_2_WON, DRAW
}

enum SLOT {
    case EMPYT, PLAYER_1, PLAYER_2
}

protocol Game {
    static func hasWon(player: SLOT, board: [[SLOT]]) -> Bool
    
    func getMove()
    func move(index: Int) -> Bool
    func getBoard() -> [[SLOT]]
    func getCurrentUser() -> SLOT
    func hasWon() -> Bool
    func gameOver() -> Bool
    func toString() -> String
    func getState() -> STATE
}



struct BoardBox {
    var bounds: CGRect
    var slot: SLOT
    var isDrawn: Bool
    
    init(bounds: CGRect) {
        self.bounds = bounds
        slot = SLOT.EMPYT
        isDrawn = false
    }
    
    func overlap(boardBox: BoardBox) -> Bool {
        return bounds.contains(boardBox.bounds)
    }
    
    func overlap(point: CGPoint) -> Bool {
        return bounds.contains(point)
    }
}

class Computer {
    var playerID: Int
    var skill: Int
    
    init() {
        playerID = Constants.player2_ID
        skill = 5
    }
    
    func getMove(board: inout [[SLOT]], hasWon: (_: SLOT, _: [[SLOT]]) -> Bool) -> (row: Int, col: Int) {
        return miniMax(mySymbol: playerID, oppenentSymbol: Constants.player1_ID, depth: 0, board: &board, hasWon: hasWon)
    }
    
    func miniMax(mySymbol: Int, oppenentSymbol: Int, depth:Int, board: inout [[SLOT]], hasWon: (_: SLOT, _: [[SLOT]]) -> Bool) -> (row: Int, col: Int) {
        var score: Float
        var maxScore: Float = -1000000
        var row: Int = -1
        var col: Int = -1
        
        for r in 0 ... 2 {
            for c in 0 ... 2 {
                
                if (board[r][c] == SLOT.EMPYT) {
                    board[r][c] = (mySymbol == playerID) ? SLOT.PLAYER_2 : SLOT.PLAYER_1
                    
                    if (hasWon(mySymbol == playerID ? SLOT.PLAYER_2: SLOT.PLAYER_1, board)) {
                        score = Constants.WIN_SCORE
                    } else if (Constants.gameOver(board: board)) {
                        score = Constants.DRAW_SCORE
                    } else {
                        let (tempRow, _) = (depth < skill) ? miniMax(mySymbol: oppenentSymbol, oppenentSymbol: mySymbol, depth: depth+1, board: &board, hasWon: hasWon) : (0, 0)
                        score = (Float) (-tempRow)
                    }
                    
                    if (abs(score-maxScore) < 1.0E-5 && drand48() < 0.1) {
                        maxScore = score
                        row = r
                        col = c
                    } else if (score > maxScore) {
                        maxScore = score
                        row = r
                        col = c
                    }
                    board[r][c] = SLOT.EMPYT
                    
                }
            }
        }
        
        return (depth == 0 ? row : Int(maxScore), col)
    }
}

class Normal : Game {
    var board: [[SLOT]] = [[SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                           [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                           [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT]]
    
    var player1: Human = Human()
    var player2: Computer = Computer()
    var state: STATE = STATE.PLAYING
    
    var curPlayer: SLOT = SLOT.PLAYER_1
    
    func getState() -> STATE {
        return state
    }
    
    func getCurrentUser() -> SLOT {
        return curPlayer
    }
    
    func getBoard() -> [[SLOT]] {
        return board
    }
    
    func hasWon() -> Bool {
        return Normal.hasWon(player: curPlayer, board: board)
    }
    
    func gameOver() -> Bool {
        return Constants.gameOver(board: board) || state != STATE.PLAYING
    }
    
    func move(index: Int) -> Bool {
        
        if (index == -1) { return false }
        
        if (board[index/3][index%3] == SLOT.EMPYT) {
            board[index/3][index%3] = SLOT.PLAYER_1
            getMove()
            return true
        }
        return false
    }
    
    static func hasWon(player: SLOT, board: [[SLOT]]) -> Bool {
        
        for row in 0 ... 2 {
            if (board[row][0] == player && board[row][1] == player && board[row][2] == player) {
                return true
            }
        }
        
        for col in 0 ... 2 {
            if (board[0][col] == player && board[1][col] == player && board[2][col] == player) {
                return true
            }
        }
        
        return (board[0][0] == player && board[1][1] == player && board[2][2] == player) || (board[0][2] == player && board[1][1] == player && board[2][0] == player)
    }
    
    func getMove() {
        
        if (curPlayer == SLOT.PLAYER_1) {
            let _ = hasWon()
        } else {
            let (row, col) = player2.getMove(board: &board, hasWon: Normal.hasWon(player:board:))
            board[row][col] = SLOT.PLAYER_2;
        }
        
        if (Normal.hasWon(player: curPlayer, board: board)) {
            state = curPlayer == SLOT.PLAYER_1 ? STATE.PLAYER_1_WON : STATE.PLAYER_2_WON
        } else if (Constants.gameOver(board: board)) {
            state = STATE.DRAW
        } else {
            curPlayer = curPlayer == SLOT.PLAYER_1 ? SLOT.PLAYER_2 : SLOT.PLAYER_1
        }
        
    }
    
    func toString() -> String {
        var boardString: String = "\(curPlayer == SLOT.PLAYER_1 ? "Player 1" : "Player 2")\n"
        
        for row in 0 ... 2 {
            for col in 0 ... 2 {
                switch (board[row][col]) {
                case .EMPYT:
                    boardString += "0"
                    break
                case .PLAYER_1:
                    boardString += "1"
                    break
                case .PLAYER_2:
                    boardString += "2"
                    break
                }
            }
            boardString += "\n"
        }
        switch state {
        case .PLAYING:
            boardString += "\tPlaying\n"
            break
        case .PLAYER_1_WON:
            boardString += "\tPlayer 1 won\n"
            break
        case .PLAYER_2_WON:
            boardString += "\tPlayer 2 won\n"
            break
        case .DRAW:
            boardString += "\tDraw\n"
            break
        }
        
        return boardString
    }
    
}

class Misere : Game {
    
    var board: [[SLOT]] = [[SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                           [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                           [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT]]
    
    var player1: Human = Human()
    var player2: Computer = Computer()
    var state: STATE = STATE.PLAYING
    
    var curPlayer: SLOT = SLOT.PLAYER_1
    
    static func hasWon(player: SLOT, board: [[SLOT]]) -> Bool {
        
        let otherPlayer: SLOT = (player == SLOT.PLAYER_1) ? SLOT.PLAYER_2 : SLOT.PLAYER_1
        
        for row in 0 ... 2 {
            if (board[row][0] == otherPlayer && board[row][1] == otherPlayer && board[row][2] == otherPlayer) {
                return true
            }
        }
        
        for col in 0 ... 2 {
            if (board[0][col] == otherPlayer && board[1][col] == otherPlayer && board[2][col] == otherPlayer) {
                return true
            }
        }
        
        return (board[0][0] == otherPlayer && board[1][1] == otherPlayer && board[2][2] == otherPlayer) || (board[0][2] == otherPlayer && board[1][1] == otherPlayer && board[2][0] == otherPlayer)
    }
    
    func getMove() {
        if (curPlayer == SLOT.PLAYER_1) {
            let _ = hasWon()
        } else {
            let (row, col) = player2.getMove(board: &board, hasWon: Misere.hasWon(player:board:))
            board[row][col] = SLOT.PLAYER_2;
        }
        
        if (Normal.hasWon(player: curPlayer, board: board)) {
            state = curPlayer == SLOT.PLAYER_1 ? STATE.PLAYER_2_WON : STATE.PLAYER_1_WON
        } else if (Constants.gameOver(board: board)) {
            state = STATE.DRAW
        } else {
            curPlayer = curPlayer == SLOT.PLAYER_1 ? SLOT.PLAYER_2 : SLOT.PLAYER_1
        }
    }
    
    func move(index: Int) -> Bool {
        if (index == -1) { return false }
        
        if (board[index/3][index%3] == SLOT.EMPYT) {
            board[index/3][index%3] = SLOT.PLAYER_1
            getMove()
            return true
        }
        return false
    }
    
    func getBoard() -> [[SLOT]] {
        return board
    }
    
    func getCurrentUser() -> SLOT {
        return curPlayer
    }
    
    func hasWon() -> Bool {
        return Misere.hasWon(player: curPlayer, board: board)
    }
    
    func gameOver() -> Bool {
        return Constants.gameOver(board: board) || state != STATE.PLAYING
    }
    
    func toString() -> String {
        var boardString: String = "\(curPlayer == SLOT.PLAYER_1 ? "Player 1" : "Player 2")\n"
        
        for row in 0 ... 2 {
            for col in 0 ... 2 {
                switch (board[row][col]) {
                case .EMPYT:
                    boardString += "0"
                    break
                case .PLAYER_1:
                    boardString += "1"
                    break
                case .PLAYER_2:
                    boardString += "2"
                    break
                }
            }
            boardString += "\n"
        }
        switch state {
        case .PLAYING:
            boardString += "\tPlaying\n"
            break
        case .PLAYER_1_WON:
            boardString += "\tPlayer 1 won\n"
            break
        case .PLAYER_2_WON:
            boardString += "\tPlayer 2 won\n"
            break
        case .DRAW:
            boardString += "\tDraw\n"
            break
        }
        
        return boardString
    }
    
    func getState() -> STATE {
        return state
    }
}

class Numerical {
}

class Sos {
}

class Revenge : Game {
    var board: [[SLOT]] = [[SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                           [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                           [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT]]
    
    var player1: Human = Human()
    var player2: Computer = Computer()
    var state: STATE = STATE.PLAYING
    var curPlayer: SLOT = SLOT.PLAYER_1
    
    func getState() -> STATE {
        return state
    }
    
    func getCurrentUser() -> SLOT {
        return curPlayer
    }
    
    func getBoard() -> [[SLOT]] {
        return board
    }
    
    func hasWon() -> Bool {
        return Revenge.hasWon(player: curPlayer, board: board)
    }
    
    func gameOver() -> Bool {
        return Constants.gameOver(board: board) || state != STATE.PLAYING
    }
    
    func move(index: Int) -> Bool {
        
        if (index == -1) { return false }
        
        if (board[index/3][index%3] == SLOT.EMPYT) {
            board[index/3][index%3] = SLOT.PLAYER_1
            getMove()
            return true
        }
        return false
    }
    
    static func canWin(player: SLOT, board: inout [[SLOT]], depth: Int) -> Bool {
        
        var win: Bool = false
        
        // check that the current player placed there symbol in three rows, cols or diagonal
        // for all possible moves the other player can place
        //          check if they can win with said move
        //              if yes
        //                  then game is still playing
        //              else
        //                  other player has won
        
        for row in 0 ... 2 {
            if (board[row][0] == player && board[row][1] == player && board[row][2] == player) {
                win = true
            }
        }
        
        if (!win) {
            for col in 0 ... 2 {
                if (board[0][col] == player && board[1][col] == player && board[2][col] == player) {
                    win = true
                }
            }
        }
        
        if (!win) {
            win = (board[0][0] == player && board[1][1] == player && board[2][2] == player) || (board[0][2] == player && board[1][1] == player && board[2][0] == player)
        }
        
        if (!win) {
            return win
        }
        
        if (depth == 0) {
            for r in 0 ... 2 {
                for c in 0 ... 2 {
                    if (board[r][c] == SLOT.EMPYT) {
                        board[r][c] = player == SLOT.PLAYER_1 ? SLOT.PLAYER_2 : SLOT.PLAYER_1
                        win = canWin(player: player == SLOT.PLAYER_1 ? SLOT.PLAYER_2 : SLOT.PLAYER_1, board: &board, depth: depth + 1)
                        if (win) {
                            return false
                        }
                        board[r][c] = SLOT.EMPYT
                    }
                }
            }
        }
        
        return true
    }
    
    static func hasWon(player: SLOT, board: [[SLOT]]) -> Bool {
        
        var tBoard: [[SLOT]] = [[SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                                [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT],
                                [SLOT.EMPYT, SLOT.EMPYT, SLOT.EMPYT]]
        
        for r in 0 ... 2 {
            for c in 0 ... 2 {
                tBoard[r][c] = board[r][c]
            }
        }
        
        return canWin(player: player, board: &tBoard, depth: 0)
        
    }
    
    func getMove() {
        
        if (curPlayer == SLOT.PLAYER_1) {
            let _ = hasWon()
        } else {
            let (row, col) = player2.getMove(board: &board, hasWon: Normal.hasWon(player:board:))
            board[row][col] = SLOT.PLAYER_2;
            // print("\tDEBUG \(row), \(col)")
        }
        
        if (Normal.hasWon(player: curPlayer, board: board)) {
            state = curPlayer == SLOT.PLAYER_1 ? STATE.PLAYER_1_WON : STATE.PLAYER_2_WON
        } else if (Constants.gameOver(board: board)) {
            state = STATE.DRAW
        } else {
            curPlayer = curPlayer == SLOT.PLAYER_1 ? SLOT.PLAYER_2 : SLOT.PLAYER_1
        }
        
    }
    
    func toString() -> String {
        var boardString: String = "\(curPlayer == SLOT.PLAYER_1 ? "Player 1" : "Player 2")\n"
        
        for row in 0 ... 2 {
            for col in 0 ... 2 {
                switch (board[row][col]) {
                case .EMPYT:
                    boardString += "0"
                    break
                case .PLAYER_1:
                    boardString += "1"
                    break
                case .PLAYER_2:
                    boardString += "2"
                    break
                }
            }
            boardString += "\n"
        }
        switch state {
        case .PLAYING:
            boardString += "\tPlaying\n"
            break
        case .PLAYER_1_WON:
            boardString += "\tPlayer 1 won\n"
            break
        case .PLAYER_2_WON:
            boardString += "\tPlayer 2 won\n"
            break
        case .DRAW:
            boardString += "\tDraw\n"
            break
        }
        
        return boardString
    }
}
