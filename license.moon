--[[
 This Source Code Form is subject to the terms of the Mozilla Public
 License, v. 2.0. If a copy of the MPL was not distributed with this
 file, You can obtain one at http://mozilla.org/MPL/2.0/.
  
 Copyright © 2020, cleaneddata
--]]

opt = require "license_opt"

macro expr is = (c, c2) -> "type(#{c}) == \"#{c2}\""

table.pretty = (t, pre, post) ->
  s = ""

  for k, v in next, t
    if $is v, table
      s = s..table.pretty v, "\t"..pre, post
    else
      s = s..(pre or "")..v..(post or "").."\n"
  
  s

opt.make_pretty = (o) ->
  if $is o, table
    table.pretty o, (opt.pretty and opt.pretty.prefix) or "\t\t- ", (opt.pretty and opt.pretty.postfix)
  else
    tostring o

class Licenser
  new: (name, licenseName) =>
    content = io.open(name, "r")

    file = content\read "*all"

    for l in content\lines!
      return if l\match "-- block:LICENSE"
    
      if l\match "%-?%]=*%]"
        skip = true
        file = ""
      elseif skip
        file = file..l
    
    file = content\read "*all" if file == ""
    return if file\find "-- block:LICENSE"

    content\close!

    comm = opt[licenseName]\gsub "{([^%{%}]+)}", (f) -> (load or loadstring or CompileString)("local opt = ...; return "..f\gsub("@", "opt."))(opt)

    newComm = ""
    newComm = newComm..(opt.prefix or "")..l.."\n" for l in comm\gmatch "[^\n]*"

    nf = io.open name, "w"

    cstart, cend = "--", "--"
    if opt.comment
      cstart, cend = opt.comment.starts, opt.comment.ends
    
    nf\write (opt.control and "-- block:LICENSE\n" or "")..cstart.."\n"..newComm..""..cend.."\n\n"..file

    nf\flush!
    nf\close!

local *
fileName = arg[1]
licenseName = arg[2]

Licenser fileName, licenseName

