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
    d.triple=Dice.TypeAndOddsNew(Enum.diceType.triple,3)
    d.oneOneOne=Dice.TypeAndOddsNew(Enum.diceType.oneOneOne,5)
    return d
end

function Dice:IsSmall()
    local rank=0
    if self[1]==1 and self[2]==2 and self[3]==3 then
        rank=0
        return true,rank
    end   
    return false,rank
end

function Dice:IsOneOneOne()
    local rank=0
    if self=={1,1,1} then
        rank=14
        return true,rank
    end   
    return false,rank
end

function Dice:IsBig()
    local rank=0
    if self[1]==4 and self[2]==5 and self[3]==6 then
        rank=4
        return true,rank
    end   
    return false,rank
end

function Dice:IsTriple()
    local rank=0
    if self[1] ==self[2] and self[2]==self[3] then
        rank=self[1]+7
        return true,rank
    end   
    return false,rank
end

function Dice:IsSingle()
    local rank=0
    if (self[1] == self[2]) or (self[2] == self[3]) or (self[3] == self[1])
    then
        for i=1,#self do
            if self[i]==self[i+1]
            then table.removes(self,i+1)
                 table.removes(self,i)
            end
        end
        rank=self[1]
        return true,rank
    end
    return false,rank
end

function Dice:TypeAndOdds(typeAndOddsArray)
    table.sort(self)

    local isSmall,rank=self:IsSmall()
    if isSmall
    then
        return typeAndOddsArray.small,rank
    end

    local isOneOneOne,rank=self:IsOneOneOne()
    if isOneOneOne
    then
        return typeAndOddsArray.oneOneOne,rank
    end

    local isBig,rank=self:IsBig()
    if isBig
    then
        return typeAndOddsArray.big,rank
    end

    local isTriple,rank=self:IsTriple()
    if isTriple
    then
        return typeAndOddsArray.triple,rank
    end

    local isSingle,rank=self:isSingle()
    if isSingle
    then
        return typeAndOddsArray.single,rank
    end

    local rank=-1
    return typeAndOddsArray.nopoint,rank
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