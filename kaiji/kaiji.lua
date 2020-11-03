local Game = require("kaiji/game")
local Dice = require("kaiji/dice")

-- 遊戲開始:輸入人數
local playerNumber=0
local players={}
local bankerId=0
local round=1
EndThisRound=false
local sameBanker=false
repeat
    playerNumber=Game.GetPlayerNumber();
    if playerNumber then
        print ("Welcome to the game!")
    else
        print ("The number is invalid.")
    end
until (playerNumber)

players=Game.CreatePlayer(playerNumber)

--測試用
players[3].isbanker=true

repeat
    print ("New Round")
    if not sameBanker then
        players,bankerId=Game.DecideBanker(players,playerNumber)     
    end

    players=Game.PlaceBet(players)

    players=Dice.RollDice(players)

    players=Game.Settle(players,bankerId)
    
    Game.PrintResult(players)
    
    if Game.IsBecomeBankerAgain(players,bankerId)
    then
        Game.AllPlayerGameRecordClear(players)
        players[bankerId].bankerTwice=true
        players[bankerId].isbanker=true
        sameBanker=true
    else
        sameBanker=false
    end
    
until EndThisRound






