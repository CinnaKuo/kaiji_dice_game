local enum={}
enum.status={init="init",pass="pass",settle="settle",waiting="waiting"}
enum.dice={round=0,dice1=0,dice2=0,dice3=0}
enum.odds={["nopoint"]=1,["single"]=1,["small"]=1,["big"]=2,["triples"]=3}
enum.answer={Y="Y",N="N"}

--參考原理https://blog.csdn.net/Cyiano/article/details/54175237
--範例http://andrejs-cainikovs.blogspot.com/2009/05/lua-constants.html
function enum.protect(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(key, value)
            error("attempting to change constant " ..
                   tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

enum.status = enum.protect(enum.status)
enum.odds = enum.protect(enum.odds)
enum.answer = enum.protect(enum.answer)
return enum
