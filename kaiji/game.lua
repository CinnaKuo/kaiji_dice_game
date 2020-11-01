local Game={}
local Player = require("kaiji/player")
local Enum = require("kaiji/Enum")
local Check = require("kaiji/Check")


function Game.PlaceBet(player)
    for i=1,#player do
        repeat
            
            if player[i].isbanker then  --莊家不下注
                break  
            end
            
            local answer=""         
            repeat 
                io.write("Hi,player "..i..",please input a number to place bet or press p to pass.")
                answer=io.read()
                answer=answer:upper()
            until (Check.IsPostiveInt(answer) or Check.IsP(answer))
 
            if answer=='P'
            then
                player[i].status=Enum.status.pass
                print("Player "..i.." pass this round.")
            else
                player[i].status=Enum.status.waiting
                player[i].stake=answer
                print("Player "..i.." place bet successful.Your stake is "..answer..".")
            end
        until true
    end
end





function Game.AddRollTimes()
    local rollTimes  = 0
    return function()
        rollTimes=rollTimes+1
        return rollTimes
    end
end

function Game.RollDice()
    local dice2={}
    dice2={math.random(1,6),math.random(1,6),math.random(1,6)}
    return dice2
end

-- function Game.GameOver(num)
--     local num = tonumber(num);
--     if type(num)=="number" and math.type(num) == "integer" and num>0
--     then
--         return true
--     else
--         return false
--     end     
-- end

return Game