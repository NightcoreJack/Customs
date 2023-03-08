--Wyndbreaker Spirit
local cid, id = GetID()
function cid.initial_effect(c)
	--Fusion summon procedure
	Fusion.AddProcFunRep(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3b4),2,true)
	c:EnableReviveLimit()
end
