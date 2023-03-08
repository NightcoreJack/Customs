--Imagenary Light
--local cid, id = GetID()
--Duel.LoadScript('imagenary_core.lua')
--function cid.initial_effect(c)
--Scripted by IanxWaifu
--Shio to Suna ★ Sunbathing!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return (c:IsSetCard(0x12F0) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.BreakEffect()	
	Duel.SendtoGrave(c,REASON_RULE)
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local e6=Effect.CreateEffect(c)
	e6:SetCode(EFFECT_REMOVE_TYPE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e6:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
	c:RegisterEffect(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e4:SetValue(7)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	Pendulum.AddProcedure(c)
end