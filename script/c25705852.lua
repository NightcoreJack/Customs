--Wyndbreaker Harpist
local cid, id = GetID()
function cid.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.sprcost)
	e1:SetTarget(cid.sprtg)
	e1:SetOperation(cid.sprop)
	c:RegisterEffect(e1)
	--
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,2})
	e3:SetCondition(cid.spcon)
	e3:SetTarget(cid.sptg)
	e3:SetOperation(cid.spop)
	c:RegisterEffect(e3)
	aux.GlobalCheck(cid,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(id)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge3:SetLabel(id)
		Duel.RegisterEffect(ge3,0)
	end)
end
function cid.rfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function cid.sprcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,cid.rfilter,1,false,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupCost(tp,cid.rfilter,1,1,false,nil,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function cid.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.sprop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end

function cid.tgfilter(c)
	return c:IsSetCard(0x3b4) and c:IsAbleToGrave()
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function cid.spfilter(c,tp)
	return c:IsSetCard(0x3b4) and c:IsAbleToGrave()
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,25705850,0x3b4,TYPES_TOKEN,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_WIND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp,rp)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		if tc:IsOnField() and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_GRAVE) then return end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,25705850,0x3b4,TYPES_TOKEN,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,25705850)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	  end
   end
end