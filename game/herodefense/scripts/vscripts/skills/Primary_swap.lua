
--------------------------------------------------------------------------------
Primary_swap = class({})
function Primary_swap:Spawn()
	if not IsServer() then return end
	print("spawn finished")
	self.table = {}
	
end

function Primary_swap:OnSpellStart()
	if not IsServer() then return end
	print("swap start")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not target or target==caster then
		return
	end
	local ability = caster:FindAbilityByName( "Primary_swap2" )
	ability.target = target

	caster:SwapAbilities(
		"Primary_swap",
		"Primary_swap2",
		false,
		true
	)

end

Primary_swap2 = class({})



function Primary_swap2:Spawn()
	if not IsServer() then return end
	print("spawn2 finished")
	self.table = {}
	
end

function Primary_swap2:OnSpellStart()
	if not IsServer() then
		return
	end
	print("swap2 end")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not target or target==caster then
		return
	end
	local pos = target:GetAbsOrigin()
	target:SetOrigin(self.target:GetAbsOrigin())
	self.target:SetOrigin(pos)

	caster:SwapAbilities(
		"Primary_swap",
		"Primary_swap2",
		true,
		false
	)

end

