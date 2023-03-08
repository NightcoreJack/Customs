--Imagenary Predilection
local cid, id = GetID()
Duel.LoadScript('imagenary_core.lua')
function cid.initial_effect(c)
	Ritual.AddProcEqualCode(c,nil,nil,25704865,25704866)
	--declare a name and add this to hand and draw 1
	Imagenary.EnableImagenaryGYEffect(c,id)
end