Middle_God_Strength = class({})

LinkLuaModifier("modifier_Middle_God_Strength", "skills/Middle_God_Strength", LUA_MODIFIER_MOTION_NONE)


function Middle_God_Strength:IsHiddenWhenStolen() 		return false end
function Middle_God_Strength:IsRefreshable() 			return true end
function Middle_God_Strength:IsStealable() 				return true end
function Middle_God_Strength:IsNetherWardStealable()	return true end
function Middle_God_Strength:OnSpellStart()
	local caster = self:GetCaster()
	--派生技升级
	local pfx_name = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx_head = "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf"
	local sound_name = "Hero_Sven.GodsStrength"
	-- if HeroItems:UnitHasItem(self:GetCaster(), "sven_immortal_head_ti10") then
	-- 	pfx_name = "particles/econ/items/sven/sven_ti10_helmet/sven_ti10_helmet_gods_strength.vpcf"
	-- 	pfx_head = "particles/econ/items/sven/sven_ftp_weapon/sven_spell_gods_strength_ambient_ftp.vpcf"
	-- end
	caster:EmitSound(sound_name)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetBaseStrength()/self:GetSpecialValueFor("str_duration_index_other")
	local str_hero = caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH 
	if str_hero then
		duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetBaseStrength()/self:GetSpecialValueFor("str_duration_index")
	end
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	local buff = caster:AddNewModifier(caster, self, "modifier_Middle_God_Strength", {duration =duration*ModifierStatusGain})
	
	local pfx = ParticleManager:CreateParticle(pfx_head, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	buff:AddParticle(pfx, false, false, 15, false, false)
	buff:SetStackCount(0)
end

modifier_Middle_God_Strength = advanced_modifier({})

function modifier_Middle_God_Strength:IsDebuff()			return false end
function modifier_Middle_God_Strength:IsHidden() 			return false end
function modifier_Middle_God_Strength:IsPurgable() 		return false end
function modifier_Middle_God_Strength:IsPurgeException() 	return false end
function modifier_Middle_God_Strength:GetStatusEffectName() return "particles/status_fx/status_effect_gods_strength.vpcf" end
function modifier_Middle_God_Strength:StatusEffectPriority() return 16 end

function modifier_Middle_God_Strength:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end

	if RandomInt(1, 100) > self:GetAbility():GetSpecialValueFor("chance") then
		return
	end
	
	if not self:GetParent():IsInSpecialAttack() then
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 0,
		}
		local attackEffectRecord = keys.attacker:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		keys.attacker:PerformAttack(keys.target, false, true, true, true, false, false, true)--对一单位执行攻击。

		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
	end
end

function modifier_Middle_God_Strength:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_Middle_God_Strength:Advanced_GetModifierBaseDamageOutgoing_Percentage() return self.bonus_damage end


function modifier_Middle_God_Strength:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},

	}
	return funcs
end

