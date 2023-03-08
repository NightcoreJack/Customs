--Acceleracer
local cid, id = GetID()
function cid.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PYRO),4,2)
	c:EnableReviveLimit()
	--act qp/trap in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa4a))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCondition(cid.handcon)
	e1:SetValue(cid.handvalue)
	c:RegisterEffect(e1)
	--
end
function cid.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function cid.handvalue(e,rc,re)
	re:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
end