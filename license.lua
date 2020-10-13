--[[
 This Source Code Form is subject to the terms of the Mozilla Public
 License, v. 2.0. If a copy of the MPL was not distributed with this
 file, You can obtain one at http://mozilla.org/MPL/2.0/.
  
 Copyright © 2020, cleaneddata
--]]

local opt = require("license_opt")
table.pretty = function(t, pre, post)
        local s = ""
        for k, v in next, t do
                if (type(v) == "table") then
                        s = s .. table.pretty(v, "\t" .. pre, post)
                else
                        s = s .. (pre or "") .. v .. (post or "") .. "\n"
                end
        end
        return s
end
opt.make_pretty = function(o)
        if (type(o) == "table") then
                return table.pretty(o, (opt.pretty and opt.pretty.prefix) or "\t\t- ", (opt.pretty and opt.pretty.postfix))
        else
                return tostring(o)
        end
end
local Licenser
do
        local _class_0
        local _base_0 = { }
        _base_0.__index = _base_0
        _class_0 = setmetatable({
                __init = function(self, name, licenseName)
                        local content = io.open(name, "r")
                        local file = content:read("*all")
                        for l in content:lines() do
                                if l:match("-- block:LICENSE") then
                                        return
                                end
                                if l:match("%-?%]=*%]") then
                                        local skip = true
                                        file = ""
                                elseif skip then
                                        file = file .. l
                                end
                        end
                        if file == "" then
                                file = content:read("*all")
                        end
                        if file:find("-- block:LICENSE") then
                                return
                        end
                        content:close()
                        local comm = opt[licenseName]:gsub("{([^%{%}]+)}", function(f)
                                return (load or loadstring or CompileString)("local opt = ...; return " .. f:gsub("@", "opt."))(opt)
                        end)
                        local newComm = ""
                        for l in comm:gmatch("[^\n]*") do
                                newComm = newComm .. (opt.prefix or "") .. l .. "\n"
                        end
                        local nf = io.open(name, "w")
                        local cstart, cend = "--", "--"
                        if opt.comment then
                                cstart, cend = opt.comment.starts, opt.comment.ends
                        end
                        nf:write((opt.control and "-- block:LICENSE\n" or "") .. cstart .. "\n" .. newComm .. "" .. cend .. "\n\n" .. file)     
                        nf:flush()
                        return nf:close()
                end,
                __base = _base_0,
                __name = "Licenser"
        }, {
                __index = _base_0,
                __call = function(cls, ...)
                        local _self_0 = setmetatable({}, _base_0)
                        cls.__init(_self_0, ...)
                        return _self_0
                end
        })
        _base_0.__class = _class_0
        Licenser = _class_0
end
local fileName, licenseName
fileName = arg[1]
licenseName = arg[2]
return Licenser(fileName, licenseName)