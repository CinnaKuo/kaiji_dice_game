local playerAndDice = require("kaiji/playerAndDice")
local enum = require("kaiji/enum")
local check = {}
-- 通常在第二行會加上 package.loaded[...] = ... 的敘述，告訴 Lua 將此模組載入。
-- 常見的手法是將 __index 這個 metamethod 指向物件本身。這樣的意義在於當 Lua 找不到某個特定屬性或函式時，會從該物件的表中去查找。
-- package.loaded["check"] = getReady
-- check._index=check

function check.IsPostiveInt(num)
    local num = tonumber(num);
    if type(num)=="number" and math.type(num) == "integer" and num>0
    then
        return true
    else
        return false
    end     
end

function check.IsYorN(answer)
    if answer==enum.answer["Y"] or answer==enum.answer["N"]
    then 
        return true
    else
        return false
    end    
end

function check.IsP(answer)
    if answer=='P'
    then 
        return true
    else
        return false
    end    
end




function check.ParticipantsProperty(property,value)
    
    if property==value then
        return true
    else
        return false
    end

end

local player={}
player[1]=playerAndDice.new(1)



print("qwe")
print(player[1].isDealer)
check.ParticipantsProperty(player[1].isDealer,false)



return check