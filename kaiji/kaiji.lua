EndThisGame=false

local Game = require("kaiji/game")
local Dice = require("kaiji/dice")
local playerNumber=0
local players={}
local bankerId=0
local round=1

local sameBanker=false

local test={2,2,1}
local test2={2,2,1}
if test==test2 then
    print ("refequal") 
end

if test[1]==test2[1] and test[2]==test2[2] and test[3]==test2[3] then
    print ("valequal") 
end

if test=={2,2,1} then
    print ("equal") 
end



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






