local GetReady = require("kaiji/getReady")
local Player = require("kaiji/player")
local Enum = require("kaiji/enum")
local Check = require("kaiji/check")
local Game = require("kaiji/game")
local Dice = require("kaiji/dice")

-- 遊戲開始:輸入人數
local playerNumber
repeat
    playerNumber=GetReady.GetPlayerNumber();
    if playerNumber then
        print ("Welcome to the game!")
    else
        print ("The number is invalid.")
    end
until (playerNumber)

-- 遊戲開始:創造參與者
local player={}
for i=1, playerNumber  do
    player[i]=Player:New()
end

--測試用
player[3].isbanker=true
-- 目前當莊的人id
local bankerId=GetReady.GetbankerId(player,playerNumber)
--下莊
player[bankerId].isbanker=false
--從下個人開始詢問是否當莊
local bankerId=GetReady.Becomebanker(bankerId+1,playerNumber)

if bankerId<0 then
    print("Game End")
end
--上莊
player[bankerId].isbanker=true
player[bankerId].status=Enum.status.waiting
-- 準備完成,回合開始
local round=1
-- 玩家下注
Game.PlaceBet(player)


--玩家與莊家擲骰
player=Dice.RollDice(player)


-- function Player.gameReocrdNew(round,dicePoint,diceType,odds,stake,bankerId)
--     local p
--     p.round=round
--     p.dicePoint=dicePoint
--     p.diceType=diceType
--     p.odds=odds
--     p.stake=stake
--     p.bankerId=bankerId
--     p.winlost=0
--     p.result=""
--     return p
-- end





print("temp")





