
Middle_Plague_Ward = class({})

-- LinkLuaModifier("modifier_Middle_Plague_Ward_think", "skills/Middle_Plague_Ward", LUA_MODIFIER_MOTION_NONE)

-- require("internal.timers")
function Middle_Plague_Ward:IsHiddenWhenStolen() 	return false end
function Middle_Plague_Ward:IsRefreshable() 		return false end
function Middle_Plague_Ward:IsStealable() 			return true end
function Middle_Plague_Ward:IsNetherWardStealable()return false end
function Middle_Plague_Ward:IsSummonSpell()return true end

function Middle_Plague_Ward:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end
function Middle_Plague_Ward:OnSpellStart(bNomain)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local theward = {}
	local life_duration = self:GetSpecialValueFor("duration")
	local heal = self:GetSpecialValueFor("bonus_creep_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_venomancer_2") then
		damage = damage * 2
	end
	if not bNomain then
		local unit = caster:SummonUnit("npc_Advanced_Plague_Ward",life_duration,pos,nil,self,0,heal,0,damage,armor,1,1)
		
		table.insert(theward, unit)
		unit:EmitSound("Hero_Venomancer.Plague_Ward")
	end

	local wards = self:GetSpecialValueFor("plague_amount")
	heal = 1
	armor = 0
	damage = damage *0.4
	for i=1, wards do
		local spawn_point = RotatePosition(pos, QAngle(0, i * 360 / wards, 0), pos + caster:GetForwardVector() * 125 )
		local unit = caster:SummonUnit("npc_Advanced_Plague_Ward_2",life_duration,spawn_point,nil,self,0,heal,0,damage,armor,1,1)

		unit:EmitSound("Hero_Venomancer.Plague_Ward")
		table.insert(theward, unit)
	
	end
	local pfx_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	for i=0, 1 do
		ParticleManager:SetParticleControlEnt(pfx_cast, i, caster, PATTACH_POINT_FOLLOW, "attach_attack"..(i + 1), caster:GetAbsOrigin(), true)
	end
	ParticleManager:ReleaseParticleIndex(pfx_cast)
	for _, ward in pairs(theward) do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:ReleaseParticleIndex(pfx)
		-- ward:AddNewModifier(caster, self, "modifier_Middle_Plague_Ward_think", {duration = life_duration})
		-- ward:AddNewModifier(caster, self, "modifier_kill", {duration = life_duration})
	end
	-- Timers:CreateTimer(FrameTime(), function()
	-- 	for _, ward in pairs(theward) do
	-- 		FindClearSpaceForUnit(ward, ward:GetAbsOrigin(), true)
	-- 	end
	-- 	return nil
	-- end
	-- )
end

-- modifier_Middle_Plague_Ward_think = class({})

-- function modifier_Middle_Plague_Ward_think:IsDebuff()			return false end
-- function modifier_Middle_Plague_Ward_think:IsHidden() 		return true end
-- function modifier_Middle_Plague_Ward_think:IsPurgable() 		return false end
-- function modifier_Middle_Plague_Ward_think:IsPurgeException() return false end
