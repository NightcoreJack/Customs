--Imagenary Foe
local cid, id = GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(cid.atkcon)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--return to gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.tgtg)
	e2:SetOperation(cid.tgop)
	c:RegisterEffect(e2)
	--return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_END_PHASE)
	e3:SetTarget(cid.thtg)
	e3:SetOperation(cid.thop)
	c:RegisterEffect(e3)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e3)
end
function cid.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,25704856),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cid.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x41a)
end
function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
function cid.thfilter(c)
	return aux.disfilter2(c)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and aux.disfilter2(chkc) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.disfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cid.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(cid.cfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,tc:GetCode())
		if #g>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		local rg=Group.FromCards(c,tc)
		Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
		Duel.ConfirmDecktop(1-tp,1)
		Duel.ConfirmDecktop(tp,1)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end
function cid.recon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE
end