--特效优化 √
Advanced_Inner_Beast = class({})
-- LinkLuaModifier("modifier_Advanced_Inner_Beast_arua", "items/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast_arua_effect", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast_buff", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast_unlock1_buff", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast_unlock2", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast_unlock2_buff", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Inner_Beast_unlock3_buff", "skills/Advanced_Inner_Beast", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function Advanced_Inner_Beast:GetIntrinsicModifierName()
	return "modifier_Advanced_Inner_Beast"
end
function Advanced_Inner_Beast:GetBehavior()
	if self:GetUnlock(1)==1 then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end
function Advanced_Inner_Beast:CheckKV(key)
	local table = {

	


		bonus_attack_speed = 2,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Inner_Beast:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_lunar_blessing_unlock1",{})
	-- self:SetLevel(0)
	-- self:SetLevel(1)
	return true
end
function Advanced_Inner_Beast:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Inner_Beast:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_howl_unlock3",{})
	return true
end

function Advanced_Inner_Beast:Precache( context )
	PrecacheResource( "particle", "particles/new_effect/new_effect/new_hd_soul_move.vpcf", context )

	PrecacheResource( "particle", "particles/new_effect/status/new_status_effect_soul_11.vpcf", context )


	
end














modifier_Advanced_Inner_Beast = class({})

function modifier_Advanced_Inner_Beast:IsDebuff() return false end
function modifier_Advanced_Inner_Beast:IsHidden() return true end
function modifier_Advanced_Inner_Beast:IsPurgable() return false end
function modifier_Advanced_Inner_Beast:IsAura() return true end
function modifier_Advanced_Inner_Beast:GetAuraDuration() return 0.5 end
function modifier_Advanced_Inner_Beast:GetModifierAura() return "modifier_Advanced_Inner_Beast_arua_effect" end
function modifier_Advanced_Inner_Beast:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_Advanced_Inner_Beast:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Inner_Beast:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Inner_Beast:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Inner_Beast:OnSummonUnit(keys)
	local ability = self:GetAbility()
	if ability:GetAutoCastState() then
		local unit = keys.target
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Inner_Beast_unlock1_buff", {})
	end
	if ability.unlock2 then
		local unit = keys.target
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Inner_Beast_unlock2", {})
	end
	if ability.unlock3 then
		local unit = keys.target
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Inner_Beast_unlock3_buff", {})
	end
end





modifier_Advanced_Inner_Beast_arua_effect = class({})

function modifier_Advanced_Inner_Beast_arua_effect:IsDebuff() return false end
function modifier_Advanced_Inner_Beast_arua_effect:IsHidden() return false end
function modifier_Advanced_Inner_Beast_arua_effect:IsPurgable() return false end
function modifier_Advanced_Inner_Beast_arua_effect:OnCreated(keys)
	self.advanced_level =1
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_magic_res = 20
	self.bonus_move_per = 20
	self:StartIntervalThink(1)
end
function modifier_Advanced_Inner_Beast_arua_effect:OnIntervalThink(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_magic_res = 20
	self.bonus_move_per = 20
	--Lv5解锁迅疾+
	if self.advanced_level>=5 then
		self.bonus_move_per = 30
		--Lv10解锁魔法防护+
		if self.advanced_level>=10 then
			self.bonus_magic_res = 30
		end
	end
end

function modifier_Advanced_Inner_Beast_arua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	}

	return funcs
end

function modifier_Advanced_Inner_Beast_arua_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetParent():IsRealHero() and self.bonus_attack_speed or self.bonus_attack_speed*0.5
end


function modifier_Advanced_Inner_Beast_arua_effect:GetModifierMagicalResistanceBonus()
	return self:GetParent():IsRealHero() and self.bonus_magic_res*0.5 or self.bonus_magic_res
end

function modifier_Advanced_Inner_Beast_arua_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move_per
end



function modifier_Advanced_Inner_Beast_arua_effect:OnAttackLanded(keys)
	if IsServer() then
		local unit = keys.attacker

		--LV15解锁野性狂暴
		if self.advanced_level>=15 then
			if unit == self:GetParent()  then
				if not self:GetAbility() then
					return
				end
				if not unit.Advanced_Inner_Beast_cooldowning  then
					local chance = 15
					if unit:IsRealHero() then
						chance = 5
					end
					if chance>=RandomInt(1, 100) then
						local ModifierStatusGain =self:GetCaster():GetModifierDurationGainIndex(0.5)
						unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Inner_Beast_buff", {duration = 3*ModifierStatusGain})
						unit.Advanced_Inner_Beast_cooldowning = true
						unit:EmitSound("Hero_Ursa.Overpower")
						Timers:CreateTimer(10, function()
							unit.Advanced_Inner_Beast_cooldowning = false
						end)
					end
				end
				
				
			end
		end
		
	end
end










modifier_Advanced_Inner_Beast_buff = class({})

function modifier_Advanced_Inner_Beast_buff:IsDebuff() return false end
function modifier_Advanced_Inner_Beast_buff:IsHidden() return false end
function modifier_Advanced_Inner_Beast_buff:IsPurgable() return false end
function modifier_Advanced_Inner_Beast_buff:GetEffectName()	return  self.advanced_level>=20 and "particles/items_fx/black_king_bar_avatar.vpcf"  end
function modifier_Advanced_Inner_Beast_buff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Advanced_Inner_Beast_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_attack_speed = 100
	--LV20解锁野性狂暴+
	if self.advanced_level>=20 then
		self.bonus_attack_speed = 150
	end
end
function modifier_Advanced_Inner_Beast_buff:CheckState()
	local state = {}
	--LV20解锁野性狂暴+
	if self.advanced_level>=20 then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end
	

	return state
end


function modifier_Advanced_Inner_Beast_buff:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_Advanced_Inner_Beast_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end


function modifier_Advanced_Inner_Beast_buff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

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

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		self.bonus_life_steal = 0.1
		if Attacker:IsRealHero() then
			self.bonus_life_steal = 0.05
		end
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * self.bonus_life_steal*gain
		Attacker:Heal( flLifesteal, self:GetAbility() )
	end

	return 0.0

end












modifier_Advanced_Inner_Beast_unlock1_buff = advanced_modifier({})

function modifier_Advanced_Inner_Beast_unlock1_buff:IsDebuff() return false end
function modifier_Advanced_Inner_Beast_unlock1_buff:IsHidden() return true end
function modifier_Advanced_Inner_Beast_unlock1_buff:IsPurgable() return false end
function modifier_Advanced_Inner_Beast_unlock1_buff:OnCreated(keys)
	if IsServer() then
		self:GetParent():SetControllableByPlayer(-1, false)
	end
end

function modifier_Advanced_Inner_Beast_arua_effect:Advanced_GetModifierAttackSpeedPercentage()
	return 60
end



function modifier_Advanced_Inner_Beast_arua_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end








modifier_Advanced_Inner_Beast_unlock2 = class({})




function modifier_Advanced_Inner_Beast_unlock2:IsHidden() 
	return true
end
function modifier_Advanced_Inner_Beast_unlock2:IsPurgable() return false end
function modifier_Advanced_Inner_Beast_unlock2:IsDebuff() return false end

function modifier_Advanced_Inner_Beast_unlock2:DeclareFunctions()
	return {

		-- MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_Advanced_Inner_Beast_unlock2:OnDeath(keys)
    if not IsServer() then
        return
    end

	
    if keys.unit == self:GetParent() and keys.attacker and keys.attacker~=keys.unit then
		local parent = self:GetParent()
        -- keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Evil_debuff", {duration = 10})
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for i, unit in pairs(units) do
			if unit~=parent and unit:IsAlive() and not unit:IsInvulnerable() and unit:GetHealth()>=1000 then
				if not unit.inner_beast_unlock2 then
					unit.inner_beast_unlock2 = 0
				end
				if unit.inner_beast_unlock2<10 then
					unit.inner_beast_unlock2 = unit.inner_beast_unlock2 +1
					local particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_soul_move.vpcf", PATTACH_POINT_FOLLOW, parent)
					ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle)
					local aiblity = self:GetAbility()
					local fbonus_damage =parent:GetDamageMax()*0.5
					unit:AddNewModifier(unit, aiblity, "modifier_Advanced_Inner_Beast_unlock2_buff", {bonus_damage=fbonus_damage})
					parent:EmitSound("Hero_Visage.SoulAssumption.Cast")
					break

				end

			end

			  	   
		   end

    end
   
end







modifier_Advanced_Inner_Beast_unlock2_buff = class({})

function modifier_Advanced_Inner_Beast_unlock2_buff:IsDebuff() return false end
function modifier_Advanced_Inner_Beast_unlock2_buff:IsHidden() return false end
function modifier_Advanced_Inner_Beast_unlock2_buff:IsPurgable() return false end
function modifier_Advanced_Inner_Beast_unlock2_buff:OnCreated(keys)

	if IsServer() then
		self:SetStackCount(keys.bonus_damage)
	end
end
function modifier_Advanced_Inner_Beast_unlock2_buff:OnRefresh(keys)

	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.bonus_damage)
	end
end
function modifier_Advanced_Inner_Beast_unlock2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end


function modifier_Advanced_Inner_Beast_unlock2_buff:GetModifierPreAttack_BonusDamage()	return self:GetStackCount() end












modifier_Advanced_Inner_Beast_unlock3_buff = advanced_modifier({})

function modifier_Advanced_Inner_Beast_unlock3_buff:IsDebuff() return false end
function modifier_Advanced_Inner_Beast_unlock3_buff:IsHidden() return true end
function modifier_Advanced_Inner_Beast_unlock3_buff:IsPurgable() return false end



function modifier_Advanced_Inner_Beast_unlock3_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_Advanced_Inner_Beast_unlock3_buff:Advanced_GetModifierAttackSpeedPercentage()
	return 25
end


function modifier_Advanced_Inner_Beast_unlock3_buff:GetModifierMoveSpeedBonus_Percentage() return   80 end
function modifier_Advanced_Inner_Beast_unlock3_buff:GetModifierIgnoreMovespeedLimit()             return   1  end


function modifier_Advanced_Inner_Beast_unlock3_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end
