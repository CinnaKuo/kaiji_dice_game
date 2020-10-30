
--請玩家輸入答案
function CreateAnswer()
    io.write('請設定你的答案')
    answer = io.read()

    while CheckNumber(answer)==false
    do
            CreateAnswer()
    end

    playerNumber=playerNumber+1
    
    print('玩家',playerNumber,'你的答案已經設定好,開始遊戲請按Y，讓其他玩家輸入答案請按其他鍵')
    local isStarted = io.read()

    while isStarted.upper ~= 'Y'
    do
            CreateAnswer()
    end
end

--請玩家猜數字
function Guess()

end

--猜對執行
function GuessRight()

end

--猜錯執行
function GuessWrong()

end

--檢查數字
function CheckNumber(answer)

end


playerNumber=0;
CreateAnswer()


