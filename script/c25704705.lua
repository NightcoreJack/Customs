--Hydrozoe School
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6f9))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Change damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetValue(s.damval)
	c:RegisterEffect(e5)
	--excavate and special
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(s.target)
	e6:SetOperation(s.activate)
	c:RegisterEffect(e6)
end
s.listed_series={0x6f9}
function s.val(e,re,dam,r,rp,rc)
	if r&REASON_EFFECT~=0 then
		return math.floor(dam/2)
	else
		return dam
	end
end
function s.damval(e,rc)
	if rc:IsSetCard(0x6f9) then return -1 end
	return HALF_DAMAGE
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x6f9) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sg=g:Filter(s.filter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if #g>0 then
		Duel.DisableShuffleCheck()
		if #sg>0 and ft>0 then
			if #sg>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,ft,ft,nil)
			end
			g:Sub(sg)
			local tc=sg:GetFirst()
			for tc in aux.Next(sg) do
				if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(3302)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				end
			end
			Duel.SpecialSummonComplete()
		end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if ct>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*1000)
		end
	end
end