--Wyndbreaker Spirit Summoning
local cid, id = GetID()
function cid.initial_effect(c)
	--Activate
	local e1=Ritual.AddProcGreater(c,aux.FilterBoolFunction(Card.IsCode,25705860),nil,nil,cid.extrafil,cid.extraop)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	AshBlossomTable=AshBlossomTable or {}
	table.insert(AshBlossomTable,e1)
end
cid.fit_monster={25705860} --should be removed in hardcode overhaul
cid.listed_names={25705860,25705850}
cid.listed_series={0x3b4}
function cid.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cid.extrafil(e,tp,mg)
	if Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,25705850),tp,LOCATION_MZONE,0,1,nil) then
		local eg=Duel.GetMatchingGroup(cid.exfilter,tp,LOCATION_DECK,0,nil)
		if eg and #eg>0 then
			return eg,cid.fcheck
		end
	end
	return nil
end
function cid.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function cid.exfilter(c)
	return c:IsMonster() and c:IsSetCard(0x3b4) and c:IsAbleToGrave()
end