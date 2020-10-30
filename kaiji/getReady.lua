
local check = require("kaiji/check")
local enum = require("kaiji/enum")
local playerAndDice = require("kaiji/playerAndDice")
local getReady = {}
-- 通常在第二行會加上 package.loaded[...] = ... 的敘述，告訴 Lua 將此模組載入。
-- 常見的手法是將 __index 這個 metamethod 指向物件本身。這樣的意義在於當 Lua 找不到某個特定屬性或函式時，會從該物件的表中去查找。
-- package.loaded["getReady"] = getReady
-- getReady._index=getReady


function getReady.GetPlayerNumber()
        io.write("Hello,how many ppl would join the game?")
        local playerNumber  = io.read()
        if check.IsPostiveInt(playerNumber) then
            return tonumber(playerNumber)
        else
            return false
        end
end

function getReady.GetDealerId(player)
    local dealerId=-1
    for key, value in pairs(player) do        
        if  value.isDealer 
        then
            dealerId=key
            break 
        else --沒有玩家當過莊
            dealerId=0
        end
    end
    return dealerId
end

function getReady.BecomeDealer(dealerId,playerNumber)
    local newDealerId=-1
    for i=dealerId,playerNumber do
        local answer=""
        repeat
            io.write("Hi,player"..i..",do you want be dealer ? Please answer Y or N.")
            answer=io.read()
            answer=answer:upper()
        until (check.IsYorN(answer))
        if answer==enum.answer["Y"]
        then
            newDealerId=i
            break
        end
    end
    return newDealerId
end

-- function getReady.AskEveryOne(playerid,player,execFunction)
--     for i=playerid,#player do
--         local flag=execFunction
--         if flag then
--         break
--         end
--     end
-- end








return getReady