--Wyndbreaker Angel
local cid, id = GetID()
function cid.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND),2,2)
	c:EnableReviveLimit()
end
