EndThisGame=false

local Game = require("kaiji/game")
local Dice = require("kaiji/dice")
local playerNumber=0
local players={}
local bankerId=0
local round=1

local sameBanker=false

-- local dicepointAndCounts={one=1,two=3,three=1,four=0,five=0,six=0}
-- local singlePoint
-- local t=#dicepointAndCounts

-- for i = 1, 6 do
--     if dicepointAndCounts[i]==3
--     then 
--         singlePoint=i
--         print(singlePoint)
--     end
-- end
-- if dicepointAndCounts.one==1 and dicepointAndCounts.two==1 and dicepointAndCounts.three==1 then
--     print("qwe")
-- end


local jimmy={init="init",pass="pass",settle="settle",waiting="waiting"}
for key, value in pairs(jimmy) do
    if value==2 then
        return key
    end
end



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






