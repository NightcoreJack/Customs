--Wyndbreaker Fairy
local cid, id = GetID()
function cid.initial_effect(c)
	--synchro summon proc
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3b4),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--
	--
	--xyzlv
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_XYZ_LEVEL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cid.xyzlv)
	c:RegisterEffect(e5)
end

function cid.xyzlv(e,c,rc)
	if rc:IsAttribute(ATTRIBUTE_WIND) then
		return 4,e:GetHandler():GetLevel()
	else
		return e:GetHandler():GetLevel()
	end
end