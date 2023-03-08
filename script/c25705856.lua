--Wyndbreaker Spirit Weaving
local cid, id = GetID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
cid.listed_series={0x3b4}
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cid.cfilter(c,tp)
	return c:IsSetCard(0x3b4) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,c)
end
function cid.filter(c,rc)
	return c:IsSetCard(0x3b4) and c:IsAttack(rc:GetAttack()) and c:IsAbleToHand()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if rc then
		Duel.ConfirmCards(1-tp,rc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,rc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(cid.regop)
		e1:SetLabel(rc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(cid.damcon)
		e2:SetOperation(cid.damop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetTargetRange(1,0)
	e3:SetValue(cid.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cid.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsAttribute(ATTRIBUTE_WIND)
end
function cid.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local tc=eg:GetFirst()
	if tc:IsCode(e:GetLabel()) and tc:IsSummonPlayer(tp) then
		e:SetLabel(0)
	end
end
function cid.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2500)
end