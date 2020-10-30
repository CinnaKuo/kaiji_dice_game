local Player = {}

Player.__index = Player
function Player:new(Name)
    local p = {}
    p.Name = Name
    p.Hands = {}
    setmetatable(p, Player);
    return p
end
-- 檢查有無重複牌組
function Player:CheckRepeatedCards()
    -- 如果三被刪除後 CardIndex會直接跳4 要改回3 因為原本的第4位陣列移動到3了
    local CardIndex = 1;
    local CardValue = {};
    while CardIndex <= #self.Hands do
        local IsDelCards = false;
        CardValue = self.Hands[CardIndex];
        for PointIndex, PointValue in ipairs(self.Hands) do
            if CardValue.Suit ~= "Joker" and PointValue.Suit ~= "Joker" and CardValue ~= PointValue then
                if CardValue.Point == PointValue.Point then
                    print(
                        "丟牌:|" .. CardValue.Suit .. " " .. CardValue.Point .. "|    |" .. PointValue.Suit .. " " ..
                            PointValue.Point .. "| \n");
                    -- 必免重覆扣除到陣列內容
                    if IsDelCards == false then
                        table.remove(self.Hands, CardIndex);
                        IsDelCards = true;
                    end
                    -- 如果掃到的號碼和最後一號相同就刪除
                    if PointValue == self.Hands[#self.Hands] and self.Hands[#self.Hands].Suit ~= "Joker" then
                        table.remove(self.Hands, #self.Hands)
                    elseif CardIndex > PointIndex then
                        table.remove(self.Hands, PointIndex)
                    else
                        table.remove(self.Hands, PointIndex - 1)
                    end
                    break
                end
            end
        end
        if IsDelCards == true then
            CardIndex = CardIndex;
        else
            CardIndex = CardIndex + 1;
        end
    end
    if #self.Hands == 0 then
        print("恭喜玩家 " .. self.Name .. "手上沒牌了 !!");
    end
end
function Player:CountPlayerHandsNum()
    local Message = "";
    for Index, Value in pairs(self.Hands) do
        Message = Message .. " |" .. Value.Suit .. "-" .. Value.Point .. "|  ";
    end
    if Message ~= "" then
        --todo..
        print(self.Name .." 您的目前手牌有:" .. Message);
    else
        print("您的目前沒有手牌了 !!");
    end
end
---創建亂數順序牌組
function CreateCards()
    local Cards = {}
    local Poker = {
        point = {},
        suits = {"Joker", "S", "H", "D", "C"},
        value = {}
    }
    local num;
    -- 產生排組
    for i = 1, 3 do
        Poker.point[i] = i;
    end
    local StartIndex = math.random(1, #Poker.suits)
    local PokerSuitIndex = StartIndex;
    repeat
        local PointNumMax;
        if PokerSuitIndex ~= 1 then
            PointNumMax = #Poker.point;
        else
            PointNumMax = 1;
        end
        local PokerPointIndex = 1
        repeat
            num = math.random(1, PointNumMax);
            local tempCard = {
                Point = num,
                Suit = Poker.suits[PokerSuitIndex]
            };

            local CheckCardIn = true
            for Index, Value in ipairs(Cards) do
                if Value.Point == tempCard.Point and Value.Suit == tempCard.Suit then
                    CheckCardIn = false;
                    break
                end
            end
            if CheckCardIn then
                table.insert(Cards, tempCard);
                PokerPointIndex = PokerPointIndex + 1;
            else
                PokerPointIndex = PokerPointIndex;
            end
        until PokerPointIndex > PointNumMax
        if PokerSuitIndex == #Poker.suits then
            PokerSuitIndex = 0;
        end
        PokerSuitIndex = PokerSuitIndex + 1
    until PokerSuitIndex == StartIndex;
    return Cards;
end

local Card = {}
Card.__index = Card
-- 透過玩家人數建置牌組
function Card:new(PlayerIndex)
    local Cards = {}
    Cards = CreateCards();

    -- 洗牌 Shuffle
    Cards = Card:Shuffle(Cards);
    setmetatable(Cards, Card);
    return Cards
end
-- 洗牌 Shuffle

function Card:Shuffle(Cards)

    local tmp
    local tempCard
    math.randomseed(os.time());
    for key, value in ipairs(Cards) do
        tmp = math.random(1, #Cards);
        tempCard = Cards[key];
        Cards[key] = Cards[tmp];
        Cards[tmp] = tempCard;
    end
    return Cards
end
-- 建置好的牌組分發給玩家
function Card:Deal(Players)
    local PlayerHands = {}
    for CardIndex, Value in ipairs(self) do
        local SplitIndex = (CardIndex % #Players) + 1;
        PlayerHands = InsertTable(SplitIndex, PlayerHands, self[CardIndex]);
    end
    for i = 1, #Players do
        Players[i].Hands = PlayerHands[i];
    end
    return Players
end
function InsertTable(SplitIndex, PlayerHands, TmpCardsTable)
    local TmpCardsTables = {}
    if PlayerHands[SplitIndex] ~= nil then
        for i, v in ipairs(PlayerHands[SplitIndex]) do
            table.insert(TmpCardsTables, PlayerHands[SplitIndex][i])
        end
    end
    table.insert(TmpCardsTables, TmpCardsTable)
    PlayerHands[SplitIndex] = TmpCardsTables;
    return PlayerHands;
end
-- 請求玩家輸入遊玩人數
function SettingPlayer()
    local Cards = {}
    local Players = {}
    io.write("請輸入幾位玩家:");
    local IsValueNumber = false;
    local PlayerCount = 0;
    repeat
        PlayerCount = io.read("*l"); -- 請輸入有幾位玩家
        IsValueNumber = CheckInput("n", PlayerCount);
    until IsValueNumber == true
    for i = 1, PlayerCount do
        io.write("請輸入第 ", i, "位玩家名稱:");
        Players[i] = Player:new(io.read("*l"));
        io.write("第" .. i .. "位玩家名稱  :  ", Players[i].Name, "\n");
    end
    -- 透過玩家人數建置牌組
    Cards = Card.new(#Players);
    -- 建置好的牌組分發給玩家
    Cards:Deal(Players);
    return Players;
end

-- 檢查玩家順序
function CheckPlayerTurn(Players, CurrentPlayerIndex)
    local Index = CurrentPlayerIndex;
    local NextPlayerIndex;
    local IsOtherPlayerNoHands=0;
    --先確認其他三家都有牌至少一家有牌
    for i=1,#Players do
        if #Players[i].Hands >0 then
            IsOtherPlayerNoHands=IsOtherPlayerNoHands+1;
        end
    end
    if IsOtherPlayerNoHands>1 then
        repeat
            if Index == #Players then
                Index = 0;
            end
            Index = Index + 1;
            ----檢查卡牌數量
            if #Players[Index].Hands > 0 and Index ~= CurrentPlayerIndex then
                NextPlayerIndex = Index;
            end
        until Index == CurrentPlayerIndex;
    end
    if NextPlayerIndex == nil then
        NextPlayerIndex = 0;
        for i = 1, #Players do
            if #Players[i].Hands > 0 then
                print("哈哈輸家是: " .. Players[i].Name .. " 下次加油~");
            end
        end
       
    end
    return NextPlayerIndex;
end

-- 抽鬼牌
function DrawCard(Players, CurrentPlayerIndex, NextPlayerIndex)
    print("玩家 " .. Players[NextPlayerIndex].Name .. "手中共有 " .. #Players[NextPlayerIndex].Hands ..
              "張牌 請問您要抽哪張?");
    local DrawCardIndex
    repeat
        local IsValueNumber = false
        local NextPlayerCardCount = #Players[NextPlayerIndex].Hands
        DrawCardIndex = io.read("*l"); -- 請輸入有幾位玩家
        IsValueNumber = CheckInput("n", DrawCardIndex);
        if IsValueNumber then
            DrawCardIndex = tonumber(DrawCardIndex);
            if DrawCardIndex <= NextPlayerCardCount then
                IsValueNumber = true
            else
                print("您輸入的數字大過於下家手牌數量!! 請重新輸入..");
                IsValueNumber = false
            end
        end
    until IsValueNumber

    print("您抽到了:" .. Players[NextPlayerIndex].Hands[DrawCardIndex].Suit .. "-" ..
              Players[NextPlayerIndex].Hands[DrawCardIndex].Point .. "!");
    table.insert(Players[CurrentPlayerIndex].Hands, Players[NextPlayerIndex].Hands[DrawCardIndex])
    table.remove(Players[NextPlayerIndex].Hands, DrawCardIndex)
    -- 檢查牌組
    if #Players[NextPlayerIndex].Hands == 0 then
        print("恭喜玩家 " .. Players[NextPlayerIndex].Name .. "手上沒牌了 !!");
    end
    Players[CurrentPlayerIndex]:CheckRepeatedCards();

end
function CheckInput(type, value)
    local IsTypeCorrect = false
    if type == "a" then
        local strPattern = "%a";
        if string.gmatch(value, strPattern) ~= nil and string.len(value) < 2 then
            IsTypeCorrect = true;
        else
            print("輸入'字母'有誤請重新輸入...");
            IsTypeCorrect = false;
        end
    elseif type == "n" then
        local status, value = pcall(tonumber, value);
        if value == nil or value<=0 then
            IsTypeCorrect = false;
            print("輸入'正整數'有誤請重新輸入...");
        else
            IsTypeCorrect = status;
        end
    else
        print("輸入字元有誤請重新輸入...");
        IsTypeCorrect = false;
    end
    return IsTypeCorrect;
end
-- 主程式
local Players
-- 請求玩家輸入遊玩人數並且發牌
Players = SettingPlayer();
-- for PlayerIndex, Value in ipairs(Players) do
--     print("第" .. PlayerIndex .. "位玩家手牌:");
--     for Index, Value in ipairs(Players[PlayerIndex].Hands) do
--         print(Value.Point, Value.Suit);
--     end
-- end
-- 依序玩家檢查有無重複牌組
for i = 1, #Players do
    Players[i]:CheckRepeatedCards()
end
-- for PlayerIndex, Value in ipairs(Players) do
--     print("第" .. PlayerIndex .. "位玩家手牌:");
--     for Index, Value in ipairs(Players[PlayerIndex].Hands) do
--         print(Value.Point, Value.Suit);
--     end
-- end

-- 開始遊戲
-- 當前玩家序
math.randomseed(os.time());
local CurrentPlayerIndex = math.random(1, #Players);

repeat
    -- 檢查玩家順序
    local NextPlayerIndex = CheckPlayerTurn(Players, CurrentPlayerIndex);
    if NextPlayerIndex == 0 then
        break
        -- 抽鬼牌 當前玩家抽下家
    else
        local Message = "";
        print("輪到玩家" .. Players[CurrentPlayerIndex].Name .. " 抽取 玩家" .. Players[NextPlayerIndex].Name ..
                  "的手牌!");
        print("您現在手上共有 " .. #Players[CurrentPlayerIndex].Hands .. " 牌 \n");
        local CheckPlayerChoice = false;
        local IsPlyerDrew = false;
        repeat
            if IsPlyerDrew then
                print("請問您接下的動作是?  B:查詢牌組,E:換下位玩家 ");
            else
                print("請問您接下的動作是?  A:抽牌,B:查詢牌組 ");
            end
            local strPattern = "%a";
            local PlayerChoosedKey = io.read("*l");
            local PlayerChoosedKey = string.upper(PlayerChoosedKey);
            if CheckInput("a", PlayerChoosedKey) then
                if PlayerChoosedKey == "A" and IsPlyerDrew == false then
                    DrawCard(Players, CurrentPlayerIndex, NextPlayerIndex);
                    Players[CurrentPlayerIndex].Hands = Card:Shuffle(Players[CurrentPlayerIndex].Hands);
                    IsPlyerDrew = true;
                elseif PlayerChoosedKey == "B" then
                    Players[CurrentPlayerIndex]:CountPlayerHandsNum();
                elseif PlayerChoosedKey == "E" and IsPlyerDrew == true then
                    CheckPlayerChoice = true;
                else
                    print("輸入字元無法辨識,請重新輸入...");
                end
            else
                print("輸入字元無法辨識,請重新輸入...");
            end
        until CheckPlayerChoice
    end
    -- 檢查玩家順序
    NextPlayerIndex = CheckPlayerTurn(Players, CurrentPlayerIndex);
    -- if NextPlayerIndex == 0 then
    --    
    -- end
    CurrentPlayerIndex = NextPlayerIndex
until NextPlayerIndex == 0;
-- 隨機牌組要更改順序
--修改randomseed
--修改func 將 抽牌對牌洗牌放在同個func
--將OOP物件導向 多型或介面實作