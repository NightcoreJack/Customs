--Acceleracer Bay
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
	--tohand
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cid.activate1)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--Def down
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(-400)
	c:RegisterEffect(e4)
	--attach
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_DETACH_MATERIAL)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r&REASON_LOST_TARGET==0 end)
	e5:SetTarget(cid.mattg)
	e5:SetOperation(cid.matop)
	c:RegisterEffect(e5)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
end
function cid.thfilter(c)
	return c:IsSetCard(0xa4a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable() and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.SSet(tp,tc)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
end
function cid.activate1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable() and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.SSet(tp,tc)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cid.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa4a)
end
function cid.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cid.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_GRAVE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cid.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,1-tp,0)
end
function cid.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_GRAVE,1,1,nil)
		Duel.Overlay(tc,g)
	end
end