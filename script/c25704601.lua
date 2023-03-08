--Elefox 
local cid, id = GetID()
function cid.initial_effect(c)
	--flip
	local fusparams = {matfilter=Fusion.OnFieldMat(Card.IsAbleToHand),extrafil=cid.extramat,extraop=cid.extraop,gc=Fusion.ForcedHandler,extratg=cid.extratarget}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,id)
	e1:SetTarget(Fusion.SummonEffTG(fusparams))
	e1:SetOperation(Fusion.SummonEffOP(fusparams))
	c:RegisterEffect(e1)
	--ATK gain and no control switch
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(cid.effcon)
	e2:SetOperation(cid.effop)
	c:RegisterEffect(e2)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e4:SetTarget(cid.sptg)
	e4:SetOperation(cid.spop)
	c:RegisterEffect(e4)
end
function cid.extramat(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
end
function cid.extratarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_MZONE+LOCATION_GRAVE)
end
function cid.extraop(e,tc,tp,sg)
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_GRAVE)
	if #gg>0 then Duel.HintSelection(gg,true) end
	local rg=sg:Filter(Card.IsFacedown,nil)
	if #rg>0 then Duel.ConfirmCards(1-tp,rg) end
	Duel.SendtoHand(sg,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	local dg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
	local ct=dg:FilterCount(Card.IsControler,nil,tp)
	if ct>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
	if #dg>ct then
		Duel.ConfirmCards(1-tp,sg)
	end
	sg:Clear()
end
function cid.tgfilter(c)
	return c:IsSetCard(0xc15) and c:IsTrap() and c:IsSSetable()
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g)~=0 and
		c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cid.effcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_FUSION)==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0xc15) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cid.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--Elefox monster using this card cannot be destroyed by battle
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(3000)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
end