
Middle_Poison_Nova = class({})

LinkLuaModifier("modifier_Middle_Poison_Nova", "skills/Middle_Poison_Nova", LUA_MODIFIER_MOTION_NONE)

function Middle_Poison_Nova:IsHiddenWhenStolen() 	return false end
function Middle_Poison_Nova:IsRefreshable() 		return true end
function Middle_Poison_Nova:IsStealable() 			return true end
function Middle_Poison_Nova:IsNetherWardStealable()return true end
function Middle_Poison_Nova:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Middle_Poison_Nova:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	self:PlayEffects()
	-- 施加debuff
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		local poison = self:GetSpecialValueFor("poison") + self:GetSpecialValueFor("bonus_poison")*caster:HDGetPrimaryStatValue()
		local index = self:GetSpecialValueFor("index")*0.01
		local spell_amp = math.max(1+caster:GetSpellAmplification(false)*index,0)
		poison = poison*spell_amp
		enemy:AddNewModifier(caster, self, "modifier_Middle_Poison_Nova", {duration = duration})
		enemy:Poison(caster,self,poison)
	end
end

function Middle_Poison_Nova:PlayEffects()
	-- 特效
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:EmitSound("Hero_Venomancer.PoisonNova")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(self:GetSpecialValueFor("radius"), 1, self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx3, 1, Vector(self:GetSpecialValueFor("radius"), 1, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_Middle_Poison_Nova = advanced_modifier({})

function modifier_Middle_Poison_Nova:IsDebuff()			return true end
function modifier_Middle_Poison_Nova:IsHidden() 			return false end
function modifier_Middle_Poison_Nova:IsPurgable() 		return false end
function modifier_Middle_Poison_Nova:IsPurgeException() 	return false end
-- function modifier_Middle_Poison_Nova:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Poison_Nova:GetEffectName() return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf" end
function modifier_Middle_Poison_Nova:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Poison_Nova:GetStatusEffectName() return "particles/status_fx/status_effect_poison_venomancer.vpcf" end
function modifier_Middle_Poison_Nova:StatusEffectPriority() return 15 end
function modifier_Middle_Poison_Nova:IsPoisonDeBuff() return true end

function modifier_Middle_Poison_Nova:OnCreated()
	self.poison_res = self:GetAbility():GetSpecialValueFor("poison_res")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Venomancer.PoisonNovaImpact")
	end
end

function modifier_Middle_Poison_Nova:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE
	}
end

function modifier_Middle_Poison_Nova:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return self.poison_res
end