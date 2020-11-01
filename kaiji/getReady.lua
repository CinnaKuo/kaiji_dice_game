
local Check = require("kaiji/check")
local Enum = require("kaiji/enum")
local Player = require("kaiji/player")
local GetReady = {}
-- 通常在第二行會加上 package.loaded[...] = ... 的敘述，告訴 Lua 將此模組載入。
-- 常見的手法是將 __index 這個 metamethod 指向物件本身。這樣的意義在於當 Lua 找不到某個特定屬性或函式時，會從該物件的表中去查找。
-- package.loaded["getReady"] = getReady
-- getReady._index=getReady


function GetReady.GetPlayerNumber()
        io.write("Hello,how many ppl would join the game?")
        local playerNumber  = io.read()
        if Check.IsPostiveInt(playerNumber) then
            return tonumber(playerNumber)
        else
            return false
        end
end

function GetReady.GetbankerId(player)
    local bankerId
    for key, value in pairs(player) do        
        if  value.isbanker 
        then
            bankerId=key
            break 
        else --沒有玩家當過莊
            bankerId=0
        end
    end
    return bankerId
end

function GetReady.Becomebanker(bankerId,playerNumber)
    local newbankerId=-1
    for i=bankerId,playerNumber do
        local answer=""
        repeat
            io.write("Hi,player"..i..",do you want be banker ? Please answer Y or N.")
            answer=io.read()
            answer=answer:upper()
        until (Check.IsYorN(answer))
        if answer==Enum.answer["Y"]
        then
            newbankerId=i
            break
        end
    end
    return newbankerId
end

-- function getReady.AskEveryOne(playerid,player,execFunction)
--     for i=playerid,#player do
--         local flag=execFunction
--         if flag then
--         break
--         end
--     end
-- end








return GetReady