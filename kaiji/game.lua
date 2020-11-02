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

function Game.BankerIsBigger(player,bankerId,playerId)
    if player[bankerId].gameResult.diceRank>player[playerId].gameResult.diceRank
    then
        return true
    else
        return false
    end   
end

function Game.Settle(player,bankerId)
    --找出莊家 紀錄莊家的點數
    --jimmy快給我建議
    --迴圈每個人 跟莊家比
    for i=1,#player do    
        if not player[bankerId].isbanker then  --莊家不跟自己比
            if Game.BankerIsBigger(player,bankerId,i)
            then
                
            end
            

        end 
        player[i].status=Enum.status.settle        
    end
    player[bankerId]=Enum.status.settle
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