Advanced_Time_Dilation = class({})

LinkLuaModifier("modifier_Advanced_Time_Dilation_slow", "skills/Advanced_Time_Dilation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Dilation_buff", "skills/Advanced_Time_Dilation", LUA_MODIFIER_MOTION_NONE)


function Advanced_Time_Dilation:CheckKV(key)
	local table = {
	


	}
	local value = table[key] or -1
	return value

end

function Advanced_Time_Dilation:IsHiddenWhenStolen() 		return false end
function Advanced_Time_Dilation:IsRefreshable() 			return true  end
function Advanced_Time_Dilation:IsStealable() 			return true  end
function Advanced_Time_Dilation:IsNetherWardStealable() 	return true end ---不知道干嘛用的

function Advanced_Time_Dilation:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
--获取施法范围（不明白为什么后面是减）

function Advanced_Time_Dilation:OnSpellStart()
	local caster = self:GetCaster()
	local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf"
	local pfx_debuff_name = "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf"
	local sound_name = "Hero_FacelessVoid.TimeDilation.Cast"
	caster:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(pfx)
	local cooldown_ability = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		local cooldown_ability_per = 0
		for i=0,enemy:GetAbilityCount() - 1 do
			local ability = enemy:GetAbilityByIndex(i)
			if ability then
				if not ability:IsCooldownReady() and not ability:IsPassive() and ability:GetCooldownTime() ~= 0 then
					--print(ability:GetName(), ability:GetCooldownTimeRemaining())
					ability:StartCooldown(ability:GetCooldownTimeRemaining() + self:GetSpecialValueFor("cooldown_increase"))
				else
					ability:StartCooldown(self:GetSpecialValueFor("cooldown_start"))
				end
			end
		end

		EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Hero_FacelessVoid.TimeDilation.Target", enemy)
		local debuff = enemy:AddNewModifier(caster, self, "modifier_Advanced_Time_Dilation_slow", {duration = self:GetSpecialValueFor("cooldown_increase")})
		local pfx2 = ParticleManager:CreateParticle(pfx_debuff_name, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(pfx2, 1, Vector(1, 0, 0))
		debuff:AddParticle(pfx2, false, false, 15, false, false)
		cooldown_ability = cooldown_ability + 1
		
	end

		local buff = caster:AddNewModifier(caster, self, "modifier_Advanced_Time_Dilation_buff", {duration = self:GetSpecialValueFor("cooldown_increase")})
		buff:SetStackCount(cooldown_ability)

end

modifier_Advanced_Time_Dilation_slow = class({})

function modifier_Advanced_Time_Dilation_slow:IsDebuff()			return true end
function modifier_Advanced_Time_Dilation_slow:IsHidden() 			return false end
function modifier_Advanced_Time_Dilation_slow:IsPurgable() 			return true end
function modifier_Advanced_Time_Dilation_slow:IsPurgeException() 	return true end
function modifier_Advanced_Time_Dilation_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Advanced_Time_Dilation_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_Advanced_Time_Dilation_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")) end

modifier_Advanced_Time_Dilation_buff = class({})

function modifier_Advanced_Time_Dilation_buff:IsDebuff()			return false end
function modifier_Advanced_Time_Dilation_buff:IsHidden() 			return false end
function modifier_Advanced_Time_Dilation_buff:IsPurgable() 			return true end
function modifier_Advanced_Time_Dilation_buff:IsPurgeException() 	return true end  --返回这个Mordifier是否能被强力驱散清除
function modifier_Advanced_Time_Dilation_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Time_Dilation_buff:GetEffectName() return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf" end
function modifier_Advanced_Time_Dilation_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Advanced_Time_Dilation_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("move_bonus")) end
function modifier_Advanced_Time_Dilation_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attack_bonus")) end