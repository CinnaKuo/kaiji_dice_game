--註釋
answer=62
io.write('Hello, what is your name? ')
guess = io.read()
getNum(guess)



function createAnswer()

    repeat
        if (guess>answer)
        then
            print('你猜的數字太大了')
        elseif (guess<answer)
        then
            print('你猜的數字太小了')
        end
        guess=guess+1
    until (guess==answer)
end

function getNum(num)
    while type(num) ~= number
    do
            print('你輸入的不是數字')
    end
end

