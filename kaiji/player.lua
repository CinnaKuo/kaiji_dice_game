local enum = require("kaiji/enum")
--player
local Player={}
Player._index=Player
function Player:New()
    local p={}
    p.isbanker=false
    p.bankerTwice=false
    p.status=enum.status.init
    p.stake=0
    p.winlost=0
    p.balance=0
    p.gameResult={}
    setmetatable(p,Player);
    return p
end

function Player:gameResult(dicePoint,diceType,odds)
    local p={}
    p.dicePoint=dicePoint
    p.diceType=diceType
    p.odds=odds
    p.stake=self.stake
    p.winlost=0
    p.result=""
    return p
end
-- function Player:setting(index,value)
--     self[index]=value
-- end

return Player





