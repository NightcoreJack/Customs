--
local s,id=GetID()
function s.initial_effect(c)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xed3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.setfilter(c)
	return c:IsSetCard(0xed3) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local seq=tc:GetSequence()
		if Duel.CheckLocation(tp,LOCATION_SZONE,seq) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local st=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
		if #st>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=st:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEDOWN,true,1<<seq)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD_EXC_GRAVE|RESET_PHASE|PHASE_END)
			e1:SetCondition(s.triggercon)
			sg:GetFirst():RegisterEffect(e1)
			Duel.ConfirmCards(1-tp,sg)
		 end
	  end
   end
end
function s.triggercon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsEnvironment(25704207,tp)
end