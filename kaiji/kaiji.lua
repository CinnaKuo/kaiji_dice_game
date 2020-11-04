EndThisGame=false

local Game = require("kaiji/game")
local Dice = require("kaiji/dice")
local playerNumber=0
local players={}
local bankerId=0
local round=1

local sameBanker=false

playerNumber=Game.GetPlayerNumber()

players=Game.CreatePlayer(playerNumber)

--測試用
players[3].isBanker=true

repeat
    print ("New Round")
    if not sameBanker then
        players,bankerId=Game.DecideBanker(players,playerNumber)     
    end

    if bankerId then
        players=Game.PlaceBet(players)

        players=Dice.RollDice(players)
    
        players=Game.Settle(players,bankerId,round)
        
        Game.PrintResult(players)
        
        players,sameBanker=Game.IsSameBanker(players,bankerId)
        
    end 
    round=round+1

until EndThisGame






