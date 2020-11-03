local Game={}
local Player = require("kaiji/player")
local Enum = require("kaiji/Enum")
local Check = require("kaiji/Check")



function Game.CreatePlayer(playerNumber)
    local players={}
    for i=1, playerNumber  do
        players[i]=Player:New()
    end
    return players
end


function Game.BankerIsBigger(player,banker)
    if banker.gameResult.diceRank>player.gameResult.diceRank
    then
        return true
    else
        return false
    end   
end

function Game.PlayerIsBigger(player,banker)
    if player.gameResult.diceRank>banker.gameResult.diceRank
    then
        return true
    else
        return false
    end   
end

function Game.HigherOdds(player,banker)
    if banker.gameResult.odds>player.gameResult.odds
    then
        return banker.gameResult.odds
    else
        return player.gameResult.odds
    end   
end


function Game.GetPlayerNumber()
    io.write("Hello,how many ppl would join the game?")
    local playerNumber  = io.read()
    if Check.IsPostiveInt(playerNumber) then
        return tonumber(playerNumber)
    else
        return false
    end
end

function Game.GetbankerId(players)
local bankerId
for key, value in pairs(players) do        
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

function Game.BecomeBankerResponse(i)
    local response=""
    repeat
        io.write("Hi,player"..i..",do you want be banker ? Please answer Y or N.")
        response=io.read()
        response=response:upper()
    until (Check.IsYorN(response))
    return response
end

function Game.BecomeBanker(pplNextToBanker,playerNumber)
local newbankerId=0
for i=pplNextToBanker,playerNumber do
    local response=Game.BecomeBankerResponse(i)
    if response==Enum.response.Y
    then
        newbankerId=i
        break
    end
end
return newbankerId
end

function Game.AllPlayerGameRecordClear(players)
    for i=1,#players do
        players[i]:RecordClear()
    end
end

function Game.DecideBanker(players,playerNumber)
    -- 目前當莊的人id
    local bankerId=Game.GetbankerId(players)
    --下莊,所有人清除這局遊戲紀錄
    if bankerId then
        Game.AllPlayerGameRecordClear(players)
    else
        bankerId=0
    end  
    --從下個人開始詢問是否當莊
    local bankerId=Game.BecomeBanker(bankerId+1,playerNumber)
    if not bankerId then
        EndThisRound=false
    end   
    --上莊
    players[bankerId]:SetupBanker()
    return players,bankerId
end


function Game.IsBecomeBankerAgain(players,bankerId)
    local banker=players[bankerId]
    if banker:IsQualifyBecomeBankerAgain() then
        local response=Game.BecomeBankerResponse(bankerId)
        if response==Enum.response.Y
        then
            return true
        end
        return false
    end
    return false
end

function Game.PlaceBet(players)
    for i=1,#players do
        local player=players[i]
        repeat
            
            if player.isbanker then  --莊家不下注
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
                player.status=Enum.status.pass
                print("Player "..i.." pass this round.")
            else
                player:PlaceBetMoney(answer)
                print("Player "..i.." place bet successful.Your stake is "..answer..".")
            end
        until true
    end
    return players
end

function Game.Settle(players,bankerId)
    local banker=players[bankerId]
    for i=1,#players do    
        
        local player=players[i]
        if (not player.isbanker) and not (player.status==Enum.status.pass) then  --莊家不跟自己比
            local higherOdds=Game.HigherOdds(player,banker)
            local stake=player.stake
            if Game.BankerIsBigger(player,banker)
            then
                player:SettleMoneyAndResult(higherOdds,Enum.result.lose,stake)
                banker:SettleMoneyAndResult(higherOdds,Enum.result.win,stake)
            
            elseif Game.PlayerIsBigger(player,banker)
            then
                player:SettleMoneyAndResult(higherOdds,Enum.result.win,stake)
                banker:SettleMoneyAndResult(higherOdds,Enum.result.lose,stake)
            else
                player:SettleMoneyAndResult(higherOdds,Enum.result.draw,stake)
                banker:SettleMoneyAndResult(higherOdds,Enum.result.draw,stake)
            end            
        end 
        player.status=Enum.status.settle        
    end
    players[bankerId].status=Enum.status.settle
    return players
end

function Game.PrintResult(players)
    for i=1, #players do
        local player=players[i]        
        if player.isbanker 
        then
            print("player "..i.." you are banker")
        elseif  player.status==Enum.status.pass
        then
            print("player "..i.." you have pass this round")
        else
            print("player "..i.." you"..player.gameResult.result.."the game, your winlost is "..player.gameResult.winlost)    
        end        
    end   
end




return Game