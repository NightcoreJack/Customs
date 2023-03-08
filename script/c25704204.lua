--Nekomi
local s,id=GetID()
function s.initial_effect(c)
	--Special Eff
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--rearrange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:GetActiveType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0xed3) and e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsCode(25704206) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.sumfilter(c)
	return c:IsSetCard(0xed3) and c:IsSummonable(true,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and Duel.IsPlayerCanSummon(tp)
		and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_DECK,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_EHERO_BLAZEMAN) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSummon(tp) then return end
	local g=Duel.GetMatchingGroup(s.sumfilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	for tc in aux.Next(g) do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.Summon(tp,spcard,true,nil)
		else
			Duel.Summon(tp,spcard,true,nil)
		end
	else
		Duel.ShuffleDeck(tp)
	end
end