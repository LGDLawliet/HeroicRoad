--特效优化 √
Advanced_Arcane_Aura = class({})
LinkLuaModifier( "modifier_Advanced_Arcane_Aura", "skills/Advanced_Arcane_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Arcane_Aura_effect", "skills/Advanced_Arcane_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Arcane_Aura_effect2", "skills/Advanced_Arcane_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Arcane_Aura_frozen", "skills/Advanced_Arcane_Aura", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function Advanced_Arcane_Aura:GetIntrinsicModifierName()
	return "modifier_Advanced_Arcane_Aura"
end
function Advanced_Arcane_Aura:UnlockFirstCore(key)
	return true
end
function Advanced_Arcane_Aura:UnlockSecondCore(key)
	return true
end
function Advanced_Arcane_Aura:UnlockThirdCore(key)
	return true
end
function Advanced_Arcane_Aura:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_final_ti5.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning_aoe/arc_aoe.vpcf", context )
	-- PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning_continued/arc_lightning.vpcf", context )
	-- PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )

	
	
end
function Advanced_Arcane_Aura:CheckKV(key)
	local table = {
		bonus_re = 0.8,




	}
	local value = table[key] or -1
	return value

end


modifier_Advanced_Arcane_Aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Arcane_Aura:IsHidden()	return self:GetAbility():GetUnlock(1)~=1 end
function modifier_Advanced_Arcane_Aura:IsDebuff()	return false end
function modifier_Advanced_Arcane_Aura:IsPurgable() 		return false end
function modifier_Advanced_Arcane_Aura:IsPurgeException() 	return false end
function modifier_Advanced_Arcane_Aura:RemoveOnDeath()  return false end
function modifier_Advanced_Arcane_Aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Arcane_Aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_Arcane_Aura:GetModifierAura()	return "modifier_Advanced_Arcane_Aura_effect" end
function modifier_Advanced_Arcane_Aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Advanced_Arcane_Aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Arcane_Aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_Advanced_Arcane_Aura:GetAuraDuration()	return 0.5 end
function modifier_Advanced_Arcane_Aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_Arcane_Aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_Advanced_Arcane_Aura:OnAbilityFullyCast( params )
	if IsServer() then
		local ability = self:GetAbility()
		if not ability.unlock1 then
			return
		end
		if not ability:IsCooldownReady() then
			return
		end
		if not  params.unit:HasModifier("modifier_Advanced_Arcane_Aura_effect") then
			return
		end
		if params.ability:IsItem() then return end
		local cooldown = params.ability:GetCooldown(params.ability:GetLevel())
		if cooldown <= 0.5 then
			return
		end


		self:SetStackCount(self:GetStackCount()+math.floor(cooldown))
		if self:GetStackCount()>=100 then
			self:SetStackCount(0)
			self:TriggetUnlock1()
			
		end

	end
end
function modifier_Advanced_Arcane_Aura:TriggetUnlock1()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	ability:StartCooldown(5)
	local pos = parent:GetAbsOrigin()
	local particle_main_fx = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_final_ti5.vpcf", PATTACH_ABSORIGIN, parent)
	ParticleManager:SetParticleControl(particle_main_fx, 5, pos)
	ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(1000, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_main_fx)
	parent:EmitSound("Hero_Ancient_Apparition.IceBlast.Target")

	local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i,unit in pairs(units) do
		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier( parent, ability, "modifier_Advanced_Arcane_Aura_frozen", { duration = math.max(5 *StatusResistance,0.5)} )
	end
end



modifier_Advanced_Arcane_Aura_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Arcane_Aura_effect:IsHidden()	return false end
function modifier_Advanced_Arcane_Aura_effect:IsDebuff()	return false end
function modifier_Advanced_Arcane_Aura_effect:IsPurgable()	return false end
function modifier_Advanced_Arcane_Aura_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Advanced_Arcane_Aura_effect:IsAura()
	if self.advanced_level>=20 then
		return true
	end
	return false
end

function modifier_Advanced_Arcane_Aura_effect:GetModifierAura()	return "modifier_Advanced_Arcane_Aura_effect2" end
function modifier_Advanced_Arcane_Aura_effect:GetAuraRadius()	return 500  end
function modifier_Advanced_Arcane_Aura_effect:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Arcane_Aura_effect:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_Advanced_Arcane_Aura_effect:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_Arcane_Aura_effect:OnCreated( kv )
	-- references
	self.advanced_level = 1
	local ability = self:GetAbility()
	self.regen_ally = ability:GetSpecialValueFor( "bonus_re" )
	self.regen_self = self.regen_ally*ability:GetSpecialValueFor( "self_mul" )
	self.bonus_spell_damage = 0
	self.life_steal_index = 0.02
	self.mana_cost_reduce = 15
	self.cast_point_bonus = 0
	if IsServer() then
		self:StartIntervalThink(0.5)
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster~=target then
			local pfx_name ="particles/new_effect/arcane_aura/arcane_aura.vpcf"
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_CENTER_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end
		if ability.unlock2  then
			if not self.unlock2_done then
				self.unlock2_done = true
				self.cast_point_bonus = 1000
			end
		end
	end
end


function modifier_Advanced_Arcane_Aura_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "bonus_re" )
	self.regen_self = self.regen_ally*self:GetAbility():GetSpecialValueFor( "self_mul" )
	local eqiup_sp = self:GetCaster():FindModifierByName("modifier_item_hd_argo_paw_buff") 
	if eqiup_sp then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
	--LV5解锁奥数掌握
	if self.advanced_level>=5 then
		self.mana_cost_reduce = 30
		--LV10解锁魔精转换
		if self.advanced_level>=10 then
			self.life_steal_index = 0.033
			--LV15解锁集中
			if self.advanced_level>=15 then
				self.bonus_spell_damage = 15
			end
		end
	end
	if ability.unlock2  then
		if not self.unlock2_done then
			self.unlock2_done = true
			self.cast_point_bonus = 1000
		end
	end
end

function modifier_Advanced_Arcane_Aura_effect:OnDestroy( kv )
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end

function modifier_Advanced_Arcane_Aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,            --技能魔法消耗
	}
	return funcs
end

function modifier_Advanced_Arcane_Aura_effect:AdvancedGetModifierConstantManaRegen()
	if self:GetParent()==self:GetCaster() then return self:GetAbility():GetSpecialValueFor( "bonus_re" )*self:GetAbility():GetSpecialValueFor( "self_mul" )*self:GetStackCount() end
	return self:GetAbility():GetSpecialValueFor( "bonus_re" )*self:GetStackCount()
end

function modifier_Advanced_Arcane_Aura_effect:Advanced_GetModifierSpellAmplifyBonus()
	if self:GetParent()==self:GetCaster() then return self.bonus_spell_damage*1.5 end
	return self.bonus_spell_damage
end


function modifier_Advanced_Arcane_Aura_effect:GetModifierPercentageManacost()
	if self:GetParent()==self:GetCaster() and self:GetAbility() then 
		return self.mana_cost_reduce*self:GetAbility():GetSpecialValueFor("self_mul") 
	end
	return self.mana_cost_reduce
end

function modifier_Advanced_Arcane_Aura_effect:OnTakeDamage(tg)
    if IsServer() then   
		local unit = self:GetParent()
		local caster = self:GetCaster()
        if tg.attacker==unit and 
			not unit:IsIllusion() and 
			tg.inflictor~=nil and 
			bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION and  
			bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 
			local ability = self:GetAbility()
			if not ability then
				return
			end
            local life_steal_gain = unit:GetModifierLifeStealGain(1)
			local lifesteal = self.life_steal_index

			if unit==caster then
				lifesteal = lifesteal*ability:GetSpecialValueFor("self_mul")
			end
            local hp=tg.damage*lifesteal *life_steal_gain
            hp = hp-hp%1
            if hp<=0 then return end   --没有吸血效果了就不执行了
            unit:Heal(hp, ability)

        end 
    end 
end

function modifier_Advanced_Arcane_Aura_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
    }
end
function modifier_Advanced_Arcane_Aura_effect:Advanced_GetModifier_CastPoint() return self.cast_point_bonus end

function modifier_Advanced_Arcane_Aura_effect:OnAttackLanded(keys)
	if self:GetStackCount() ~= 0 then--有命石才会生效
		return
	end
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local eqiup_sp = self:GetCaster():FindModifierByName("modifier_item_hd_argo_paw_buff") 
	if eqiup_sp then
		if self:GetParent() == self:GetCaster() then 
			-- self.mp_get = self.regen_self*eqiup_sp:GetAbility():GetSpecialValueFor("arcane_mp_index")*0.01
			keys.attacker:GiveMana(self.regen_self*eqiup_sp:GetAbility():GetSpecialValueFor("arcane_mp_index")*0.01)

		else
			-- self.mp_get = self.regen_ally*eqiup_sp:GetAbility():GetSpecialValueFor("arcane_mp_index")*0.01
			keys.attacker:GiveMana(self.regen_ally*eqiup_sp:GetAbility():GetSpecialValueFor("arcane_mp_index")*0.01)
		end
	end
	
	
end

function modifier_Advanced_Arcane_Aura_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then

		local ability = self:GetAbility()
		if ability and ability.unlock3 then
			if keys.damage_type ==DAMAGE_TYPE_MAGICAL  then
				if Cannotcrit(keys) then return 0 end
				if self:GetCaster():GetRandomEffect(15,INT_TYPE,1) >=RandomInt(1, 100) then
					return 200
				elseif self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100) then
					return 100
				end
			end
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------




modifier_Advanced_Arcane_Aura_effect2 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Arcane_Aura_effect2:IsHidden()	return false end
function modifier_Advanced_Arcane_Aura_effect2:IsDebuff()	return false end
function modifier_Advanced_Arcane_Aura_effect2:IsPurgable()	return false end
function modifier_Advanced_Arcane_Aura_effect2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Arcane_Aura_effect2:OnCreated( kv )
	-- references
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster~=target then
			local pfx_name ="particles/new_effect/arcane_aura/arcane_aura.vpcf"
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_CENTER_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end




	end
end

function modifier_Advanced_Arcane_Aura_effect2:OnDestroy( kv )
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

	end
end


function modifier_Advanced_Arcane_Aura_effect2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_Advanced_Arcane_Aura_effect2:Advanced_GetModifierSpellAmplifyBonus()
	return 10
end








modifier_Advanced_Arcane_Aura_frozen = advanced_modifier({})

function modifier_Advanced_Arcane_Aura_frozen:IsDebuff() return true end
function modifier_Advanced_Arcane_Aura_frozen:IsHidden() return false end
function modifier_Advanced_Arcane_Aura_frozen:IsPurgable() return false end
function modifier_Advanced_Arcane_Aura_frozen:IsPurgeException() return true end
function modifier_Advanced_Arcane_Aura_frozen:GetStatusEffectName()	return "particles/status_fx/status_effect_frost_lich.vpcf"	end
function modifier_Advanced_Arcane_Aura_frozen:StatusEffectPriority() return 100	end
function modifier_Advanced_Arcane_Aura_frozen:GetEffectName()	return "particles/generic_gameplay/generic_frozen.vpcf"	end
function modifier_Advanced_Arcane_Aura_frozen:GetModifierIncomingDamage_Percentage(keys)	
	if IsClient() then
		return
	end
	if keys.damage_type==DAMAGE_TYPE_MAGICAL  then
		return 100
	end
	return 0
end


function modifier_Advanced_Arcane_Aura_frozen:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
end


function modifier_Advanced_Arcane_Aura_frozen:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

