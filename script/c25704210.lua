--Nekomi Hassha
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_BEASTWARRIOR),tp,LOCATION_MZONE,0,1,nil)
end
function s.pfilter(c)
	return c:IsSpellTrap() and c:IsDestructable()
end
function s.setfilter(c)
	return c:IsTrap() and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.pfilter(chkc) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.pfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,s.pfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_ONFIELD)
	Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,25704206),tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SSet(tp,g)
		 end
	  end
   end
end