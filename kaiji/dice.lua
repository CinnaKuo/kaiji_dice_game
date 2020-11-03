local Enum = require("kaiji/enum")
local Dice={}
Dice.__index=Dice

function Dice:New()
    local d=0
    d={math.random(1,6),math.random(1,6),math.random(1,6)}
    setmetatable(d,Dice);
    return d
end

function Dice.TypeAndOddsNew(type,odds)
    local d={}
    d.type=type
    d.odds=odds
    return d
end

function Dice.TypeAndOddsArray()
    local d={}
    d.nopoint=Dice.TypeAndOddsNew(Enum.diceType.nopoint,1)
    d.single=Dice.TypeAndOddsNew(Enum.diceType.single,1)
    d.small=Dice.TypeAndOddsNew(Enum.diceType.small,2)
    d.big=Dice.TypeAndOddsNew(Enum.diceType.big,2)
    d.triples=Dice.TypeAndOddsNew(Enum.diceType.triples,3)
    return d
end
--table.sort(self)=={1,2,3}抽出來
function Dice:TypeAndOdds(typeAndOddsArray)
    local rank=0
    if table.sort(self)=={1,2,3}
    then
        rank=0
        return typeAndOddsArray.small,rank
    
    elseif table.sort(self)=={4,5,6}
    then
        rank=4
        return typeAndOddsArray.big,rank

    elseif self[1] ==self[2] and self[2]==self[3]
    then
        rank=self[1]+7
        return typeAndOddsArray.triples,rank

    elseif (self[1] == self[2]) or (self[2] == self[3]) or (self[3] == self[1])
    then
        local tempValueIsKey={}
        local notRepeat={}
        local repeatNum=0

        for k,v in ipairs(self)do
            if (not tempValueIsKey[v]) then
                notRepeat[#notRepeat+1]=v --{5,3}
                tempValueIsKey[v]=v
            else
                repeatNum=v  --5
            end
        end
        --改成for迴圈
        if repeatNum==notRepeat[1] then 
            rank=notRepeat[2]
        else
            rank=notRepeat[1]
        end

        return typeAndOddsArray.single,rank

    else
        rank=-1
        return typeAndOddsArray.nopoint,rank
    end
    setmetatable(typeAndOddsArray,Dice)
end

function Dice.RollDice(players)
    math.randomseed(os.time())
    for i=1,#players do
        repeat          
            if players[i].status==Enum.status.pass then
                break  
            end
            local dicePoint={}
            local diceTypeAndOdd={}
            local rollTimes=0    
            local typeAndOddsArray=Dice.TypeAndOddsArray()  
            local rank=0                 
            repeat
                dicePoint=Dice:New()
                diceTypeAndOdd,rank=dicePoint:TypeAndOdds(typeAndOddsArray)
                rollTimes=rollTimes+1
            until (diceTypeAndOdd.type ~="nopoint") or rollTimes==3
            print("player"..i.." your dice is "..dicePoint[1]..dicePoint[2]..dicePoint[3])
            print("player"..i.." your dice type is "..diceTypeAndOdd.type)
            players[i].gameResult=players[i]:GameResult(dicePoint,diceTypeAndOdd.type,diceTypeAndOdd.odds,rank)
        until true
    end
    return players
end

return Dice