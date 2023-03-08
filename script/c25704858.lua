--Imagenary Power
local cid, id = GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,2,2,nil,nil,99)
	--ATK Down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cid.atkval)
	c:RegisterEffect(e1)
	--ritual material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e2:SetTarget(cid.mttg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(cid.tgcon)
	e3:SetTarget(cid.tgtg)
	e3:SetOperation(cid.tgop)
	c:RegisterEffect(e3)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(cid.thcon)
	e4:SetTarget(cid.thtg)
	e4:SetOperation(cid.thop)
	c:RegisterEffect(e4)
end
function cid.atkval(e,c)
	return c:GetOverlayCount()*-1000
end
function cid.mttg(e,c)
	return e:GetHandler():GetOverlayGroup():IsContains(c)
end
function cid.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cid.tgfilter(c)
	return c:IsSetCard(0x41a) and c:IsAbleToGrave()
end
function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cid.thfilter(c,tp)
	return c:IsSetCard(0x41a) and c:IsRitualMonster() and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(cid.tgfilter1,tp,LOCATION_DECK,0,1,c)
end
function cid.tgfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x41a) and c:IsAbleToGrave()
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #hg>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0
		and hg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cid.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end