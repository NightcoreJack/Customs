--Wyndbreaker Calling
local cid, id = GetID()
function cid.initial_effect(c)
	--Send To GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3b4) and c:IsAbleToGrave()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g and #g>0 and Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		if Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,25705850),tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end