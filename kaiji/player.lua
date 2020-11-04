local Enum = require("kaiji/Enum")
local Player={}
Player.__index=Player
function Player:New()
    local p={}
    p.isBanker=false
    p.bankerTwice=false
    p.status=Enum.status.init
    p.stake=0
    p.winlost=0
    p.balance=0
    p.gameResult={}
    setmetatable(p,Player);
    return p
end

function Player:GameResult(dicePoint,diceType,odds,diceRank)
    local p={}
    p.dicePoint=dicePoint
    p.diceType=diceType
    p.diceRank=diceRank
    p.odds=odds
    p.stake=self.stake
    p.winlost=0
    p.result=""
    self.gameResult=p
    return p
end

function Player:PlaceBetMoney(answer)
    self.status=Enum.status.waiting
    self.stake=answer
    self.balance= self.balance-answer
end

function Player:SettleMoneyAndResult(higherOdds,result,stake)
    if result==Enum.result.lose
    then
        higherOdds=higherOdds*-1
    elseif result==Enum.result.draw
    then
        higherOdds=0
    end
    self.gameResult.winlost=stake*higherOdds
    self.gameResult.result=result 
    self.winlost=self.winlost+self.gameResult.winlost
    self.balance=self.balance+self.stake+self.gameResult.winlost
end

function Player:SetupBanker()
    self.isBanker=true
    self.status=Enum.status.waiting
end

function Player:IsQualifyBecomeBankerAgain()
    if self.bankerTwice then
        return false
    elseif self.gameResult.diceType==(Enum.diceType.nopoint or Enum.diceType.small)
    then
        return false
    else
        return true
    end    
end

function Player:RecordClear()
    self.isBanker=false
    self.status=Enum.status.init
    self.status=0
    self.gameResult={}
    self.bankerTwice=false
end
return Player





