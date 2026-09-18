Middle_feast = class({})
-- LinkLuaModifier("modifier_Middle_feast_arua", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_arua_effect", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_feast", "skills/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_active", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_effect", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_effect2", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_active_standby", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_debuff", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_feast_thinker", "special_gain/Middle_feast", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function Middle_feast:GetIntrinsicModifierName()
	return "modifier_Middle_feast"
end

function Middle_feast:OnSpellStart()
	-- print("aaa")
	self:OnToggle()


end



modifier_Middle_feast = class({})

function modifier_Middle_feast:IsDebuff() return false end
function modifier_Middle_feast:IsHidden() return true end
function modifier_Middle_feast:IsPurgable() 		return false end
function modifier_Middle_feast:IsPurgeException() 	return false end
function modifier_Middle_feast:RemoveOnDeath()  return false end



function modifier_Middle_feast:OnCreated(keys)
    self.ability = self:GetAbility()

 
    -- local parent = self:GetParent()

	
	-- self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	


 
end



function modifier_Middle_feast:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		

	}
end


function modifier_Middle_feast:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end


function modifier_Middle_feast:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local feast_aiblity = self:GetAbility()

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if Attacker:PassivesDisabled() then
			return
		end

		if feast_aiblity:GetToggleState() then
			--激活独食
			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.016
			local gain = Attacker:GetModifierLifeStealGain(1)
			local flLifesteal = flDamage * self.bonus_life_steal*gain
			Attacker:Heal( flLifesteal, feast_aiblity )
		else
			--分享
			local unit = FinDLowestHealthPerAllyInRange(Attacker, 1000 )
			if unit then

				--恢复自己
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
				local gain = Attacker:GetModifierLifeStealGain(1)
				local flLifesteal = flDamage * self.bonus_life_steal*gain
				Attacker:Heal( flLifesteal, feast_aiblity )
				---------------------------------------------------------
				--恢复友军
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
				local gain = Attacker:GetModifierLifeStealGain(1)
				local flLifesteal = flDamage * self.bonus_life_steal*gain
				unit:Heal( flLifesteal, feast_aiblity )

				
			else
				--当区域内没有可以触发的友军单位时仍旧触发独食
				--激活独食
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.016
				local gain = Attacker:GetModifierLifeStealGain(1)
				local flLifesteal = flDamage * self.bonus_life_steal*gain
				Attacker:Heal( flLifesteal, feast_aiblity )

			end

		end


	end

	return 0.0

end
