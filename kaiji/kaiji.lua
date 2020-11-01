local GetReady = require("kaiji/getReady")
local Player = require("kaiji/player")
local Enum = require("kaiji/enum")
local Check = require("kaiji/check")
local Game = require("kaiji/game")

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

-- 準備完成,回合開始
local round=1
-- 玩家下注
Game.PlaceBet(player)









local Dice={}
Dice._index=Dice

function Dice:New()
    local d=0
    d={math.random(1,6),math.random(1,6),math.random(1,6)}
    setmetatable(d,Dice);
    return d
end



function Dice.TypeAndOddsNew(type,odds)
    local d=0
    d.type=type
    d.odds=odds
    return d
end

function Dice.TypeAndOddsArray()
    local d
    d.nopoint=Dice.TypeAndOddsNew("nopoint",1)
    d.single=Dice.TypeAndOddsNew("single",1)
    d.small=Dice.TypeAndOddsNew("small",2)
    d.big=Dice.TypeAndOddsNew("big",2)
    d.triples=Dice.TypeAndOddsNew("triples",3)
    return d
end

function Dice:TypeAndOdds()
    local typeAndOddsArray=Dice.TypeAndOddsArray()
    if table.sort(self)=={1,2,3}
    then
        return typeAndOddsArray.small
    
    elseif table.sort(self)=={4,5,6}
    then
        return typeAndOddsArray.big

    elseif self[0] ==self[1] ==self[2]
    then
        return typeAndOddsArray.triples

    elseif self[0] == self[1] or self[1] == self[2] or self[2] == self[0]
    then
        return typeAndOddsArray.single

    else
        return typeAndOddsArray.nopoint
    end
end

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

function RollDice(player)
    for i=1,#player do
        repeat          
            if player[i].status==Enum.status.pass then
                break  
            end
            local dicePoint={}
            local diceTypeandOdd={}
            local rollTimes=0
            math.randomseed(os.time())

            repeat
                dicePoint=Dice:New()
                diceTypeandOdd=dicePoint:TypeAndOdds()
                rollTimes=rollTimes+1
            until diceTypeandOdd.type ~="nopoint" or rollTimes==3

            if rollTimes==3 then
                -- local typeAndOddsArray=Dice.TypeAndOddsArray()
                diceTypeandOdd=Dice.TypeAndOddsArray().nopoint --尚未測試
            end
            
            player[i]:gameResult(dicePoint,diceTypeandOdd.type,diceTypeandOdd.odds)
        until true
    end
    return player
end


--玩家與莊家擲骰
player=RollDice(player)

print("temp")





