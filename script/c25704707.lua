--Hydrozoe Jelly Stingers
local s,id=GetID()
function s.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TO)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.cecon)
	e1:SetTarget(s.cetg)
	e1:SetOperation(s.ceop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
s.listed_series={0x6f9}
s.listed_names={id}
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function s.cecon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
	   and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x6f9),tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0x6f9) and c:IsAbleToHand()
end
function s.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,rp,0,LOCATION_DECK,1,nil) end
end
function s.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f9) and c:IsType(TYPE_MONSTER)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(s.drfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectTarget(tp,s.drfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end