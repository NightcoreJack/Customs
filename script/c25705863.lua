--Wyndbreaker Apprentice
local cid, id = GetID()
function cid.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2,cid.ovfilter,aux.Stringid(id,0),2,cid.xyzop)
	c:EnableReviveLimit()
	--
	--
	--
end
function cid.cfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function cid.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND,lc,SUMMON_TYPE_XYZ,tp) and c:IsLevel(4)
end
function cid.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc then
		Duel.Release(tc,REASON_COST)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end