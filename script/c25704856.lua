--Imagenary Friend
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
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(cid.tdtg)
	e3:SetOperation(cid.tdop)
	c:RegisterEffect(e3)
end
function cid.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,25704857),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
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
function cid.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function cid.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and cid.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cid.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
		Duel.ConfirmDecktop(1-tp,1)
		Duel.ConfirmDecktop(tp,1)
	end
end