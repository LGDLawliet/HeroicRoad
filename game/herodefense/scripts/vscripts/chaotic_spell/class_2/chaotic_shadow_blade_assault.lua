LinkLuaModifier( "modifier_chaotic_shadow_blade_assault", "chaotic_spell/class_2/chaotic_shadow_blade_assault.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hd_backstab", "chaotic_spell/class_1/chaotic_stealth.lua", LUA_MODIFIER_MOTION_NONE )

--Abilities
if chaotic_shadow_blade_assault == nil then
	chaotic_shadow_blade_assault = class({})
end

function chaotic_shadow_blade_assault:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local position = target:GetAbsOrigin()
	-- Move caster behind the target
	local direction = (target:GetForwardVector() * -1):Normalized()
	local new_position = position + direction * 100
	FindClearSpaceForUnit(caster, new_position, true)
	
	-- Perform three attacks
	for i = 1, 3 do
		caster:PerformAttack(target, true, true, true, false, false, false, true)
	end

	local modifier = caster:FindModifierByName("modifier_hd_backstab")
	if not modifier then
		modifier = caster:AddNewModifier(caster, self, "modifier_hd_backstab", {duration = -1})
	else
		modifier = caster:FindModifierByName("modifier_hd_backstab")
	end
	if modifier and modifier.AlwaysBackstab then
		modifier:SetStackCount(modifier:GetStackCount() + 10)
		modifier:AlwaysBackstab(self:GetSpecialValueFor("buff_duration"))
		print("modifier: " .. self:GetSpecialValueFor("buff_duration"))
		caster:AddNewModifier(caster, self, "modifier_chaotic_shadow_blade_assault", {duration = self:GetSpecialValueFor("buff_duration")})
	end

	
end
if modifier_chaotic_shadow_blade_assault == nil then
    modifier_chaotic_shadow_blade_assault = class({})
end

function modifier_chaotic_shadow_blade_assault:IsHidden() return true end
function modifier_chaotic_shadow_blade_assault:IsDebuff() return false end
function modifier_chaotic_shadow_blade_assault:IsPurgable() return false end

