--Nekomi Doku
local s,id=GetID()
function s.initial_effect(c)
	--Banish 1 monster from opponent's GY, or if you control "Nekomi Tamashi", special summon it
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_BEASTWARRIOR),tp,LOCATION_MZONE,0,1,nil)
end
function s.filter(c,e,tp,spchk)
	return c:IsMonster() and (c:IsAbleToRemove()
		or (spchk and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local spchk=false
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,25704206),tp,LOCATION_MZONE,0,1,nil) then
		spchk=true
	end
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(c,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,spchk)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,25704206),tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			--Cannot attack
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3206)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			--Target becomes a Beast-Warrior monster
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_BEASTWARRIOR)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
