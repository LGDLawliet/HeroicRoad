
Primary_aphotic_shield = class({})

LinkLuaModifier("modifier_Primary_aphotic_shield", "skills/Primary_aphotic_shield", LUA_MODIFIER_MOTION_NONE)

function Primary_aphotic_shield:IsHiddenWhenStolen() 		return false end
function Primary_aphotic_shield:IsRefreshable() 			return true end
function Primary_aphotic_shield:IsStealable() 				return true end
function Primary_aphotic_shield:IsNetherWardStealable()	return true end


function Primary_aphotic_shield:OnSpellStart()
	local target = self:GetCursorTarget()
	local buff = target:FindModifierByName("modifier_Primary_aphotic_shield")
	if buff then
		buff:SetStackCount(0)
		buff:SafeDestroy()
	end
	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)
	target:AddNewModifier(self:GetCaster(), self, "modifier_Primary_aphotic_shield", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
	target:Purge(false, true, false, true, false)
end

modifier_Primary_aphotic_shield = advanced_modifier({})

function modifier_Primary_aphotic_shield:IsDebuff()			return false end
function modifier_Primary_aphotic_shield:IsHidden() 			return false end
function modifier_Primary_aphotic_shield:IsPurgable() 			return true end
function modifier_Primary_aphotic_shield:IsPurgeException() 	return true end

function modifier_Primary_aphotic_shield:OnCreated()
	if IsServer() then


		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local shield = ability:GetSpecialValueFor("spell_sheild")+ability:GetSpecialValueFor("str_index")*caster:GetStrength()
		self:SetStackCount(shield)

		EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
		EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", parent)

		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		local ex = parent:GetModelScale() * 100
		ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 2, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 4, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end




function modifier_Primary_aphotic_shield:OnDestroy()

	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		local pos = self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_hitloc"))
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 5, pos)
		ParticleManager:ReleaseParticleIndex(pfx)



		local ability = self:GetAbility()
		if not ability then
			return
		end
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local damage = ability:GetSpecialValueFor("spell_damage")+ability:GetSpecialValueFor("str_damage")*caster:GetStrength()
		StopSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
		EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", parent)

	
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											parent:GetAbsOrigin(),
											nil,
											ability:GetSpecialValueFor("radius"),
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
		for i, enemy in pairs(enemies) do

			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
	end
end

function modifier_Primary_aphotic_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_Primary_aphotic_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
    return stack
end
