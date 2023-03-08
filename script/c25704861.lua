--Imagenary Shadow
local cid, id = GetID()
Duel.LoadScript('imagenary_core.lua')
function cid.initial_effect(c)
	--
	--declare a name and add this to hand and draw 1
	Imagenary.EnableImagenaryGYQEffect(c,id)
end
