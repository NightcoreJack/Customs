--Westward Barrage
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttackBelow,c:GetAttack()),tp,0,LOCATION_MZONE,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local dg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttackBelow,tc:GetAttack()),tp,0,LOCATION_MZONE,nil)
	dg:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,dg,#dg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not s.tgfilter(tc,tp) then return end
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttackBelow,tc:GetAttack()),tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		g:AddCard(tc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end