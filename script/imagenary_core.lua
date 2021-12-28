if not aux.ImagenaryEff then
	aux.ImagenaryEff = {}
	Imagenary = aux.ImagenaryEff
end

if not Imagenary then
	Imagenary = aux.ImagenaryEff
end
--Common used cards
CARD_CONVULSION = 62966332

--
function Imagenary.EnableImagenarySpSummonEffect(c,id)
    local eff=Effect.CreateEffect(c)
    eff:SetDescription(aux.Stringid(id,1))
    eff:SetCategory(CATEGORY_SPECIAL_SUMMON)
    eff:SetType(EFFECT_TYPE_IGNITION)
    eff:SetRange(LOCATION_GRAVE)
    eff:SetCountLimit(1,{id,1})
    eff:SetTarget(Imagenary.sptg)
    eff:SetOperation(Imagenary.spop)
    c:RegisterEffect(eff)
    --register names
	if not Imagenary.global_flag then
		Imagenary.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(Imagenary.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
Imagenary.name_list={}

function Imagenary.resetop(e,tp,eg,ep,ev,re,r,rp)
	Imagenary.name_list={}
	return false
end
function Imagenary.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	local filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
    if #Imagenary.name_list~=0 then
        local ct=#Imagenary.name_list
        for _,code in ipairs(Imagenary.name_list) do
        	table.insert(filter,code)
        	table.insert(filter,OPCODE_ISCODE)
        	table.insert(filter,OPCODE_NOT)
        	table.insert(filter,OPCODE_AND)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    local ac=Duel.AnnounceCard(tp,filter)
    Duel.SetTargetParam(ac)
    Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Imagenary.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 
		or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
    Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local g1=Duel.GetDecktopGroup(tp,1)
	local tc1=g1:GetFirst()
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local tc2=g2:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	table.insert(Imagenary.name_list,ac)
	if (tc1:IsCode(ac) or tc2:IsCode(ac)) and Duel.SelectYesNo(tp,aux.Stringid(c:GetCode(),1)) then
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function Imagenary.EnableImagenaryGYEffect(c,id)
    local eff=Effect.CreateEffect(c)
    eff:SetDescription(aux.Stringid(id,1))
    eff:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_DRAW)
    eff:SetType(EFFECT_TYPE_IGNITION)
    eff:SetRange(LOCATION_GRAVE)
    eff:SetCountLimit(1,{id,1})
    eff:SetTarget(Imagenary.rttg)
    eff:SetOperation(Imagenary.rtop)
    c:RegisterEffect(eff)
    --register names
	if not Imagenary.global_flag then
		Imagenary.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(Imagenary.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function Imagenary.EnableImagenaryGYQEffect(c,id)
    local eff=Effect.CreateEffect(c)
    eff:SetDescription(aux.Stringid(id,1))
    eff:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_DRAW)
    eff:SetType(EFFECT_TYPE_QUICK_O)
	eff:SetCode(EVENT_FREE_CHAIN)
    eff:SetRange(LOCATION_GRAVE)
    eff:SetCountLimit(1,{id,1})
    eff:SetTarget(Imagenary.rttg)
    eff:SetOperation(Imagenary.rtop)
    c:RegisterEffect(eff)
    --register names
	if not Imagenary.global_flag then
		Imagenary.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(Imagenary.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function Imagenary.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	local filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
    if #Imagenary.name_list~=0 then
        local ct=#Imagenary.name_list
        for _,code in ipairs(Imagenary.name_list) do
        	table.insert(filter,code)
        	table.insert(filter,OPCODE_ISCODE)
        	table.insert(filter,OPCODE_NOT)
        	table.insert(filter,OPCODE_AND)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    local ac=Duel.AnnounceCard(tp,filter)
    Duel.SetTargetParam(ac)
    Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function Imagenary.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 
		or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
    Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local g1=Duel.GetDecktopGroup(tp,1)
	local tc1=g1:GetFirst()
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local tc2=g2:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	table.insert(Imagenary.name_list,ac)
	if (tc1:IsCode(ac) or tc2:IsCode(ac)) and Duel.SelectYesNo(tp,aux.Stringid(c:GetCode(),1)) then
		if not c:IsRelateToEffect(e) then return end
		Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--