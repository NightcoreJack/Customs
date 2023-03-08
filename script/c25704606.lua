--Elefox 
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xc15),aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST))
	--
	--
	--
end
