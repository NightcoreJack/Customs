--
local cid, id = GetID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.target)
	c:RegisterEffect(e1)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chk)
	if chk then return cid.thtg(e,tp,eg,ep,ev,re,r,rp,0,chk) end
	--
	local b1=cid.thtg(e,tp,eg,ep,ev,re,r,rp,0)
	--Special Summon 1 "Acceleracer" monster from Extra Deck
	local b2=cid.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		local g=Duel.GetMatchingGroup(cid.thfilter,tp,LOCATION_DECK,0,nil)
		e:SetOperation(cid.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		cid.thtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		e:SetOperation(cid.spop)
		cid.sptg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0xa4a) and c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP,0x60)>0 and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,c)
	end
end
