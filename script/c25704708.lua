--Hydrozoa Zephyr
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
end
s.listed_series={0x6f9}
