--Kyonshī Thelxiepeia
local s,id=GetID()
function s.initial_effect(c)
	--Send to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--Destruction replacement
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0xfe4) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
		or (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,25704305),tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,2,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,25704305),tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,2,nil,tp)
	if not a and not b then return end
	if (not a and b) or (b and Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
		 if #g>=2 then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local sg=g:Select(tp,2,2,nil)
			 Duel.SendtoGrave(sg,REASON_EFFECT)
		 end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0xfe4)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
