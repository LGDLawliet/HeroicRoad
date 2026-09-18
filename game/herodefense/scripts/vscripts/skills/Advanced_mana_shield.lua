
LinkLuaModifier("modifier_Advanced_mana_shield_meditate", "skills/Advanced_mana_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_mana_shield", "skills/Advanced_mana_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_mana_shield_stone", "skills/Advanced_mana_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_mana_shield_unlock3", "skills/Advanced_mana_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_mana_shield_cd", "skills/Advanced_mana_shield", LUA_MODIFIER_MOTION_NONE)
Advanced_mana_shield = class({})

function Advanced_mana_shield:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/mana_shield/unlock1/effectti_5.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/mana_shield/unlock3/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_medusa_stone_gaze.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context )
end

function Advanced_mana_shield:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function Advanced_mana_shield:CheckKV(key)
	local table = {
		per_mana = 0.1,
		bonus_spell_amp = 0.8,
		bonus_mana = 1,
		middle_damage = 0.1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_mana_shield:GetIntrinsicModifierName()
	return "modifier_Advanced_mana_shield_meditate"
end

function Advanced_mana_shield:ProcsMagicStick() return false end

function Advanced_mana_shield:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_mana_shield:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Advanced_mana_shield:OnToggle()
	if not IsServer() then return end
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_mana_shield", {})
	else
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_mana_shield", self:GetCaster())
	end
end

function Advanced_mana_shield:Spawn()
	self.unlock1_mana = 0
end

function Advanced_mana_shield:UnlockFirstCore(key)
	return true
end
function Advanced_mana_shield:UnlockSecondCore(key)
	return true
end
function Advanced_mana_shield:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_mana_shield_unlock3",{})
	return true
end

function Advanced_mana_shield:Unlock1Mana(mana)
	if  _G.GAME_mana_shield_unlock1_bonus>=10 then
		return
	end
	self.unlock1_mana = self.unlock1_mana + mana
	local caster = self:GetCaster()
	local need = caster:GetMaxMana()
	if self.unlock1_mana>=need then
		self.unlock1_mana = self.unlock1_mana - need
		_G.GAME_mana_shield_unlock1_bonus  = _G.GAME_mana_shield_unlock1_bonus  +0.02
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/mana_shield/unlock1/effectti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

		ParticleManager:SetParticleControl( pfx, 0, caster:GetOrigin() )
		ParticleManager:SetParticleControlEnt(pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc",caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	end
end

function Advanced_mana_shield:Unlock2StackSave(stack)
	self.unlock2_stack = stack
end
------------------------------------------------------------------------------------------------------------------
modifier_Advanced_mana_shield_meditate = advanced_modifier({})

function modifier_Advanced_mana_shield_meditate:IsHidden()	return true end
function modifier_Advanced_mana_shield_meditate:IsPurgable() 		return false end
function modifier_Advanced_mana_shield_meditate:IsPurgeException() 	return false end
function modifier_Advanced_mana_shield_meditate:RemoveOnDeath()  return false end
function modifier_Advanced_mana_shield_meditate:DeclareFunctions()
	local decFuncs = {	
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,                       --魔法值
    }
    return decFuncs
end

function modifier_Advanced_mana_shield_meditate:ADDeclareFunctions()
	local decFuncs = {	
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,                       --魔法值
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return decFuncs
end

function modifier_Advanced_mana_shield_meditate:OnCreated(table)
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	
	local ability = self:GetAbility()	
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self:SetStackCount(0)
	--if IsServer() then
		self:StartIntervalThink(0.5)
	--end
end

function modifier_Advanced_mana_shield_meditate:OnIntervalThink()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")

	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	if self:GetParent():HasModifier("modifier_Advanced_mana_shield") then
		self:SetStackCount(self.incoming)
	else
		self:SetStackCount(0)
	end
end

function modifier_Advanced_mana_shield_meditate:GetModifierExtraManaPercentage()	return self.bonus_mana end
function modifier_Advanced_mana_shield_meditate:Advanced_GetModifierSpellAmplifyBonus()	return self.bonus_spell_amp end
function modifier_Advanced_mana_shield_meditate:Advanced_GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()
end
-------------------------------------------------------------------------------------------------------------------
modifier_Advanced_mana_shield = advanced_modifier({})
function modifier_Advanced_mana_shield:GetEffectName()return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf" end
function modifier_Advanced_mana_shield:IsHidden() return false end
function modifier_Advanced_mana_shield:IsDebuff() return false end
function modifier_Advanced_mana_shield:IsPurgable() 		return false end
function modifier_Advanced_mana_shield:RemoveOnDeath()	return false end

function modifier_Advanced_mana_shield:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.middle_damage = self:GetAbility():GetSpecialValueFor("middle_damage")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")

	if not IsServer() then return end
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	self:StartIntervalThink(1)
	self.time = 0
	if ability.unlock2 and ability.unlock2_stack then
		self:SetStackCount(ability.unlock2_stack)
	end
	if ability.unlock3 then
		self.modifier = caster:FindModifierByName("modifier_Advanced_mana_shield_unlock3")
	end

	self.unlock3Stack = 0
	self.per_mana = self:GetAbility():GetSpecialValueFor("per_mana") + _G.GAME_mana_shield_unlock1_bonus
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
end

function modifier_Advanced_mana_shield:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability and ability.unlock2 then
			ability:Unlock2StackSave(self:GetStackCount())
		end
		self.time = 0
	end
end

function modifier_Advanced_mana_shield:DeclareFunctions()
	local decFuncs = {
		
    }
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(decFuncs,MODIFIER_EVENT_ON_MANA_GAINED)
	end

    return decFuncs
end

function modifier_Advanced_mana_shield:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.advanced_level = ability:GetSpecialValueFor('advanced_level')

	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.middle_damage = self:GetAbility():GetSpecialValueFor("middle_damage")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")*0.01
	self.armor = self:GetAbility():GetSpecialValueFor("armor")

	self.time = self.time + 1
	if self.time >= self.interval then
		self:Middle_shield()
		self.time = 0
	end
	--LV10魔力流体壁垒+
	if caster:GetManaPercent() <= self.line then
		self.mana_get = caster:GetMaxMana() * self.mana_regen
		if self.advanced_level >= 10 and caster:GetManaPercent() <= 20 then
			self.mana_get = caster:GetMaxMana() * 0.025
			--print("高10效果生效！")
		end
		caster:GiveMana(self.mana_get)
		--print("低于60自动回复魔法！")
	end
	self.per_mana = self:GetAbility():GetSpecialValueFor("per_mana") + _G.GAME_mana_shield_unlock1_bonus
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
end

function modifier_Advanced_mana_shield:Middle_shield()
	local parent = self:GetParent()
	local parent_pos = parent:GetAbsOrigin()
	local radius = self.radius
	local damage = parent:GetIntellect(false) * self.middle_damage

	local enemies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent_pos,
		nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
    	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
	)
    local i = 0
    for _, enemy in pairs(enemies) do
		local damageTable = {
			attacker = parent,
            victim = enemy,
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
        ApplyDamage(damageTable)
		enemy:AddNewModifier(parent,self:GetAbility(),"modifier_stunned",{duration = self.stun_duration})

		local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, enemy)
        local pos = enemy:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+5000))
        ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
        ParticleManager:SetParticleControl(particle, 3, Vector(pos.x, pos.y, pos.z))
		enemy:EmitSoundParams("Hero_Zuus.LightningBolt",0,0.3,0)

		i = i + 1
		if i >= self.max then
			break
		end
	end
end

function modifier_Advanced_mana_shield:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	local parent = self:GetParent()
	--LV5水流护盾
	if self.advanced_level >= 5 then
		if not parent:HasModifier("modifier_Advanced_mana_shield_cd") then
			parent:GiveMana((parent:GetMaxMana() - parent:GetMana())*0.07)
			parent:AddNewModifier(parent,self:GetAbility(),"modifier_Advanced_mana_shield_cd",{duration = 2})
			--print("回复魔法成功！")
		end
	end
	if parent.GetMana then
		local damage_block_per_mana = self.per_mana
		--LV15防死结界
		if self.advanced_level>=15 then

			--优化：全生命值都会格挡
			if keys.damage>=parent:GetHealth() or parent:GetHealthPercent()<=40 then
				local ability = self:GetAbility()
				local mana_to_block	= keys.original_damage / damage_block_per_mana
				local reduce=  100 * parent:GetMana() / math.max(mana_to_block, 1)
				if mana_to_block >= parent:GetMana() then
					parent:EmitSound("Hero_Medusa.ManaShield.Proc")
					
					local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
					ParticleManager:ReleaseParticleIndex(shield_particle)

					if ability.unlock2 then
						local stack = self:GetStackCount()
						local max_stack = parent:GetMaxMana()*10
						if stack<max_stack then
							-- 仍然可以贷款魔法
							reduce = 100
							self:SetStackCount(stack+mana_to_block-parent:GetMana())
						end
					end
				end	
				mana_to_block = math.min(mana_to_block,self:GetParent():GetMaxMana()*0.3)
				parent:Script_ReduceMana(mana_to_block,self:GetAbility())
				if ability.unlock1 then
					ability:Unlock1Mana(mana_to_block)
				end
				if ability.unlock3 then
					self:TryTriggerUnlock3(mana_to_block)
				end


				if reduce>=100 then
					reduce = 1000
				end
				return reduce * (-1)

			else
				
				local mana_to_block	= keys.original_damage * self.absorption_tooltip * 0.01 / damage_block_per_mana
		
				if mana_to_block >= parent:GetMana() then
					parent:EmitSound("Hero_Medusa.ManaShield.Proc")
					
					local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
					ParticleManager:ReleaseParticleIndex(shield_particle)
				end	
				
				local block = math.min(self.absorption_tooltip, self.absorption_tooltip * parent:GetMana() / math.max(mana_to_block, 1)) * (-1)
				mana_to_block = math.min(mana_to_block,self:GetParent():GetMaxMana()*0.3)
				parent:Script_ReduceMana(mana_to_block,self:GetAbility())
				if self:GetAbility().unlock1 then
					self:GetAbility():Unlock1Mana(mana_to_block)
				end
				return block
			end

		else
			--原本的逻辑
			local mana_to_block	= keys.original_damage * self.absorption_tooltip * 0.01 / damage_block_per_mana
		
			if mana_to_block >= parent:GetMana() then
				parent:EmitSound("Hero_Medusa.ManaShield.Proc")
				
				local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:ReleaseParticleIndex(shield_particle)
			end	
			
			local block = math.min(self.absorption_tooltip, self.absorption_tooltip * parent:GetMana() / math.max(mana_to_block, 1)) * (-1)
			mana_to_block = math.min(mana_to_block,self:GetParent():GetMaxMana()*0.3)
			parent:Script_ReduceMana(mana_to_block,self:GetAbility())
			if self:GetAbility().unlock1 then
				self:GetAbility():Unlock1Mana(mana_to_block)
			end
			return block
		end
	end
end


function modifier_Advanced_mana_shield:TryTriggerUnlock3(mana_to_block)


	if not self.modifier then
		return
	end


	self.unlock3Stack = self.unlock3Stack  + mana_to_block
	local stack = self.modifier:GetStackCount()
	local caster = self:GetParent()
	local need = caster:GetMaxMana() * (0.1 + stack*0.05)
	if self.unlock3Stack>=need then
		self.unlock3Stack = 0
		-- self:IncrementStackCount()
		self.modifier:TriggerUnlock3()

		--触发范围石化
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/mana_shield/unlock3/effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(500,1,1))
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("Hero_Medusa.StoneGaze.Stun")

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(units) do
			enemy:AddNewModifier(caster, ability,"modifier_Advanced_mana_shield_stone", 
			{
				duration = 2,
				center_unit = caster:entindex(),
			} 
		)
		end
		
	end






end


function modifier_Advanced_mana_shield:OnManaGained()
	if IsServer() then
		local stack = self:GetStackCount()
		if stack>0 then
			local caster = self:GetCaster()
			local mana = caster:GetMana()
			if mana>0 then
				if mana>=stack then
					self:SetStackCount(0)
					caster:SetMana(mana-stack)
				else
					self:SetStackCount(stack-mana)
					caster:SetMana(0)
				end
			end
		end
	end
end


function modifier_Advanced_mana_shield:ADDeclareFunctions()

	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,}
	return funcs
end

function modifier_Advanced_mana_shield:Advanced_GetModifierPhysicalArmorBonus()
	if self:GetParent():GetManaPercent() >= self.line then
		return self.armor
	end
	return 0
end

function modifier_Advanced_mana_shield:Advanced_GetModifierSpellAmplifyBonus()
	--LV20神代魔力
	if self.advanced_level < 20 then
		return 0 
	end
	return math.min(math.floor(self:GetParent():GetMaxMana()/300) *1 , 80)
end

------------------------------------------------------------------------------------------------------------------
modifier_Advanced_mana_shield_cd = advanced_modifier({})

function modifier_Advanced_mana_shield_cd:IsHidden()	return true end
function modifier_Advanced_mana_shield_cd:IsPurgable() 		return false end
function modifier_Advanced_mana_shield_cd:IsPurgeException() 	return false end
function modifier_Advanced_mana_shield_cd:RemoveOnDeath()  return false end


modifier_Advanced_mana_shield_stone = advanced_modifier({})


function modifier_Advanced_mana_shield_stone:IsHidden()	return false end
function modifier_Advanced_mana_shield_stone:IsDebuff()	return true end
function modifier_Advanced_mana_shield_stone:IsStunDebuff()	return true end
function modifier_Advanced_mana_shield_stone:IsPurgable()	return true end


function modifier_Advanced_mana_shield_stone:OnCreated( kv )
	if not IsServer() then return end
	self.physical_bonus = kv.physical_bonus
	self.center_unit = EntIndexToHScript( kv.center_unit )
	self:PlayEffects()
end

function modifier_Advanced_mana_shield_stone:OnRefresh( kv )
	if not IsServer() then return end

	-- references
	self.physical_bonus = kv.physical_bonus
	self.center_unit = EntIndexToHScript( kv.center_unit )

	self:PlayEffects()
end



function modifier_Advanced_mana_shield_stone:Advanced_GetModifierIncomingDamage_Percentage( params )
	return 100

end

function modifier_Advanced_mana_shield_stone:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end


function modifier_Advanced_mana_shield_stone:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_Advanced_mana_shield_stone:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_Advanced_mana_shield_stone:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
	local sound_cast = "Hero_Medusa.StoneGaze.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.center_unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector( 0,0,0 ), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:GetParent():EmitSound(sound_cast)
end


function modifier_Advanced_mana_shield_stone:ADDeclareFunctions()

	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end








modifier_Advanced_mana_shield_unlock3		= class({})

function modifier_Advanced_mana_shield_unlock3:IsHidden()	return false end
function modifier_Advanced_mana_shield_unlock3:IsDebuff() return false end
function modifier_Advanced_mana_shield_unlock3:IsPurgable() 		return false end
function modifier_Advanced_mana_shield_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_mana_shield_unlock3:RemoveOnDeath()  return false end
function modifier_Advanced_mana_shield_unlock3:OnCreated(keys)
	if IsServer() then
		self.time = GameRules:GetGameTime()
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_mana_shield_unlock3:OnIntervalThink()
	if GameRules:GetGameTime()>=self.time then
		self:SetStackCount(0)
	end
end


function modifier_Advanced_mana_shield_unlock3:TriggerUnlock3()
	self.time = GameRules:GetGameTime() + 10
	self:IncrementStackCount()
end