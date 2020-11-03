local Enum={}
Enum.status={init="init",pass="pass",settle="settle",waiting="waiting"}
Enum.dice={round=0,dice1=0,dice2=0,dice3=0}
Enum.diceType={nopoint="nopoint",single="single",small="small",big="big",triples="triples"}
Enum.response={Y="Y",N="N"}
Enum.result={win="win",lose="lose",draw="draw"}

--參考原理https://blog.csdn.net/Cyiano/article/details/54175237
--範例http://andrejs-cainikovs.blogspot.com/2009/05/lua-constants.html
function Enum.protect(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(key, value)
            error("attempting to change constant " ..
                   tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

Enum.status = Enum.protect(Enum.status)
Enum.odds = Enum.protect(Enum.diceType)
Enum.answer = Enum.protect(Enum.answer)
return Enum
