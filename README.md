# License Tool

```sh
lua license.lua fileName licenseName
```

file: license_opt.lua
```lua
return {
  pretty  = { -- "prefix   - {listMember} postfix"
    prefix  = "list prefix ",
    postfix = " list postfix"
  },
  comment = { -- "start and end of license comment"
    starts = "--[[",
    ends   = "--]]"
  },
  control = true, -- whether or not add control line to file
  prefix  = "license line prefix\t  "; -- "-- {licenseLine}"


  -- formatting
  now = {
   month = os.date "%B",
   day   = os.date "%d"
  },
  fmt = false,
  list = {"a", "b", "c"},
  licenseName = [[This is sample license
Today is {@now.month}, {@now.day}

{not @fmt and "I can evaulate lua!" or "Wow!"}

and now print list
{opt.make_pretty(@list)}]]
}
```
And then run script on file
file: test
```lua
if smth then
  smth()
end
```
Script turn this file into
```lua
-- block:LICENSE
--[[
license line prefix	  This is sample license
license line prefix	  Today is October, 13
license line prefix	  
license line prefix	  I can evaulate lua!
license line prefix	  
license line prefix	  and now print list
license line prefix	  list prefix a list postfix
license line prefix	  list prefix b list postfix
license line prefix	  list prefix c list postfix
license line prefix	  
--]]

if smth then
  smth()
end
```
