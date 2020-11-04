local Enum={}
Enum.status={init="init",pass="pass",settle="settle",waiting="waiting"}
Enum.diceType={nopoint="nopoint",single="single",small="small",big="big",triple="triple",isAllOne="isAllOne"}
Enum.response={Y="Y",N="N"}
Enum.result={win="win",lose="lose",draw="draw"}
Enum.points={one=1,two=2,three=3,four=4,five=5,six=6}

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
