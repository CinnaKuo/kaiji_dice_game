local enum = require("kaiji/enum")
--player
local Player={}
Player._index=Player
function Player:new()
    local p={}
    p.isDealer=false
    p.dealerTwice=false
    p.status=enum.status.init
    p.bet=0
    p.winlost=0
    p.amount=0
    p.rollTimes=0
    p.currentDice={}--想做interface
    p.gameReocrd={}
    setmetatable(p,Player);
    return p
end

function Player:setting(index,value)
    self[index]=value
end

return Player


---------------------------dice----------------------------------------------
--diceType
-- local DiceTypeObj={}
-- DiceTypeObj._index=DiceTypeObj
-- function DiceTypeObj:new()
--     local d={}
--     d.typeName=""
--     d.diceValue={}
--     d.odds=1,
--     setmetatable(d,DiceTypeObj);
--     return d
-- end

-- --createDiceType
-- local diceType
-- diceType[1]=DiceTypeObj:new()
-- diceType[1].typeName="single"
-- diceType[1].odds=1
-- diceType[1].diceValue={}





