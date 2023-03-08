--Imagenary Nostalgia
local cid, id = GetID()
Duel.LoadScript('imagenary_core.lua')
function cid.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x41a),2,2)
	c:EnableReviveLimit()
	--Link Eff
	--
	--
end