--Imagenary Passion
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
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--If special summoned, place on top of your Deck, 1 of your "Imagenary" monsters that is banished, in GY, or Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,id)
	e3:SetTarget(cid.target)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
end
function cid.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,25704866),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cid.filter(c)
	return c:IsSetCard(0x41a) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE+LOCATION_DECK))
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.filter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.MoveToDeckTop(tc)
	else
		Duel.HintSelection(g,true)
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
	if not tc:IsLocation(LOCATION_EXTRA) then
		Duel.ConfirmDecktop(tp,1)
	end
end