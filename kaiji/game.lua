local game={}
local playerAndDice = require("kaiji/playerAndDice")
local enum = require("kaiji/enum")
local check = require("kaiji/check")


function game.PlaceBet(player)
    for i=1,#player do
        repeat
            
            if player[i].isDealer then  --莊家不下注
                break  
            end
            
            local answer=""         
            repeat 
                io.write("Hi,player "..i..",please input a number to place bet or press p to pass.")
                answer=io.read()
                answer=answer:upper()
            until (check.IsPostiveInt(answer) or check.IsP(answer))
 
            if answer=='P'
            then
                playerAndDice.setting(player[i], "status", enum.status.pass)
                print("Player "..i.." pass this round.")
            else
                playerAndDice.setting(player[i], "status", enum.status.waiting)
                playerAndDice.setting(player[i], "stake",answer )
                print("Player "..i.." place bet successful.Your stake is"..answer..".")
            end
        until true
    end
end





function game.AddRollTimes()
    local rollTimes  = 0
    return function()
        rollTimes=rollTimes+1
        return rollTimes
    end
end

function game.RollDice()
    local dice2={}
    dice2={math.random(1,6),math.random(1,6),math.random(1,6)}
    return dice2
end

function game.GameOver(num)
    local num = tonumber(num);
    if type(num)=="number" and math.type(num) == "integer" and num>0
    then
        return true
    else
        return false
    end     
end

return game