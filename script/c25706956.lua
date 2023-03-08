--Westward Outlaw
local cid, id = GetID()
function cid.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cid.spcon)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(id)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(cid.drtg)
	e2:SetOperation(cid.drop)
	c:RegisterEffect(e2)
	--Equip itself to 1 "Westward Steed" from hand, field, or GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,{id,2})
	e3:SetTarget(cid.eqtg)
	e3:SetOperation(cid.eqop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--Prevent effect target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	ge1:SetCode(EVENT_EQUIP)
	ge1:SetOperation(cid.checkop)
	Duel.RegisterEffect(ge1,0)
end
--
function cid.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetOwner()) then
		Duel.RaiseSingleEvent(e:GetOwner(),id,e,0,0,0,0,0)
	end
end
--special summon itself
function cid.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
--
function cid.tdfilter(c)
	return c:IsSetCard(0xc3b) and c:IsAbleToDeck()
		and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function cid.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cid.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cid.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetTargetCards(e)
	if #tg<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--Equip itself to 1 "Westward Steed" from hand, field, or GY
function cid.eqfilter(c)
	return c:IsFaceup() and c:IsCode(25706951)
end
function cid.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cid.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cid.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	if(e:GetHandler():IsLocation(LOCATION_GRAVE)) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function cid.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc and tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsFacedown() then
		Duel.Equip(tp,c,tc,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cid.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
	end
end
function cid.eqlimit(e,c)
	return c==e:GetLabelObject()
end