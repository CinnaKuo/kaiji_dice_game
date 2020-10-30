local getReady = require("kaiji/getReady")
local playerAndDice = require("kaiji/playerAndDice")
local enum = require("kaiji/enum")
local check = require("kaiji/check")
local game = require("kaiji/game")

-- 遊戲開始:輸入人數
local playerNumber
repeat
    playerNumber=getReady.GetPlayerNumber();
    if playerNumber then
        print ("Welcome to the game!")
    else
        print ("The number is invalid.")
    end
until (playerNumber)

-- 遊戲開始:創造參與者
local player={}
for i=1, playerNumber  do
    player[i]=playerAndDice.new()
end

player[3].isDealer=true
-- 目前當莊的人id
local dealerId=getReady.GetDealerId(player,playerNumber)
--下莊
playerAndDice.setting(player[dealerId], "isDealer", false)
--從下個人開始詢問是否當莊
local dealerId=getReady.BecomeDealer(dealerId+1,playerNumber)

if dealerId<0 then
    print("Game End")
end
--上莊
playerAndDice.setting(player[dealerId], "isDealer", true)

-- 準備完成,回合開始
local round=1
-- 玩家下注
game.PlaceBet(player)
--玩家擲骰








local dice={}
dice._index=dice

function dice:new()
    local d={}
    d={math.random(1,6),math.random(1,6),math.random(1,6)}
    setmetatable(d,dice);
    return d
end

function dice:AddRollTimes(rollTimes)
    return rollTimes+1
end

function DiceResult(player)
    for i=1,#player do
        repeat
            
            if player[i].isDealer then  --莊家不下注
                break  
            end
            math.randomseed(os.time())
            repeat
                player[i].currentDice=dice:new()
                --檢查骰子類型
            until
        until true
    end
end

local rollResult={}



function CheckDiceType(arg1, arg2, arg3)
    
end







