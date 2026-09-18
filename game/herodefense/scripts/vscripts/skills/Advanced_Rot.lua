
--特效优化 √
LinkLuaModifier("modifier_Advanced_Rot", "skills/Advanced_Rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Rot_slow", "skills/Advanced_Rot", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Rot_unlock1_debuff", "skills/Advanced_Rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Rot_unlock2", "skills/Advanced_Rot", LUA_MODIFIER_MOTION_NONE)

Advanced_Rot							= Advanced_Rot or class({})



function Advanced_Rot:CheckKV(key)
	local table = {
		bonus_damage = 0.1,




	}
	local value = table[key] or -1
	return value

end


function Advanced_Rot:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/rot/unlock1/effect_pustule.vpcf", context )
	PrecacheResource( "modle", "models/items/undying/undying_fall20_immortal_head/undying_fall20_immortal_minion.vmdl", context )

	PrecacheResource( "particle", "particles/econ/items/sand_king/sandking_ti7_arms/sandking_ti7_caustic_finale_explode.vpcf", context )

	
end

function Advanced_Rot:OnUnlock2Kill(pos)
	local caster = self:GetCaster()
	local unit = caster:SummonUnit("npc_hd_little_zombie",10,
	pos,
	caster:GetForwardVector(),self,0,caster:GetMaxHealth()*0.3,nil,0,0,1,0)
	if unit then
		unit.specialUnit = true
		unit:AddNewModifier(caster, self, "modifier_Advanced_Rot_unlock2", {})
	end
end













function Advanced_Rot:UnlockFirstCore(key)
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_rubick" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock1 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true
end
function Advanced_Rot:UnlockSecondCore(key)
	return true
end
function Advanced_Rot:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_summons_ward_Aghanim_the_Wisest_buff_count_unlock3",{})
	local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_pudge")
	if not ability then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	ability.rot_unlock3 = true
	return true
end
function Advanced_Rot:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_Rot:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Rot", self:GetCaster())
end

function Advanced_Rot:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		-- self:GetCaster():EmitSound("Hero_Pudge.Rot")
		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Rot", {})
	else
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")

		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Rot", self:GetCaster())
	end
	
end

function Advanced_Rot:GetCastRange()
	local caster = self:GetCaster()
	local bonus_radius = 150
	if self:GetSpecialValueFor("advanced_level")>=5 then
		bonus_radius = 250
	end
	return self:GetSpecialValueFor("radius") +bonus_radius- caster:GetCastRangeBonus()

end

--------------------------
-- MANA SHIELD MODIFIER --
--------------------------
modifier_Advanced_Rot				=modifier_Advanced_Rot or class({})

function modifier_Advanced_Rot:IsDebuff() return false end
function modifier_Advanced_Rot:IsHidden() return true end
function modifier_Advanced_Rot:IsPurgable() 		return false end
function modifier_Advanced_Rot:RemoveOnDeath()	return true end
function modifier_Advanced_Rot:IsAura() return true end
function modifier_Advanced_Rot:GetModifierAura()	return "modifier_Advanced_Rot_slow" end
function modifier_Advanced_Rot:GetAuraRadius()	return self.radius  end
function modifier_Advanced_Rot:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Rot:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Rot:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_Advanced_Rot:OnCreated()

	if not IsServer() then return end

	local bonus_radius = 150
	if self:GetAbility().advanced_level>=5 then
		bonus_radius = 250
	end
	self.radius = self:GetAbility():GetSpecialValueFor("radius") +bonus_radius
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Pudge.Rot")
	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self.radius,1,1) )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	self.damage_tick = 1
	self.damageTable = {
	
		attacker =caster,
		-- damage = caster:GetMaxHealth()*0.01* self:GetAbility():GetSpecialValueFor("bonus_damage") / (1.0 / damage_tick),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		}

	self.damageTableSelf = {
		victim = caster,
		attacker = caster,
		-- damage = caster:GetMaxHealth()*0.01* self:GetAbility():GetSpecialValueFor("bonus_damage") / (1.0 / damage_tick),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags =DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION +DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL +DOTA_DAMAGE_FLAG_NON_LETHAL  , --Optional.
		ability = self:GetAbility(), --Optional.
		}
	self:StartIntervalThink(self.damage_tick)
end


function modifier_Advanced_Rot:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = caster:GetMaxHealth()*0.01* ability:GetSpecialValueFor("bonus_damage") / (1.0 / self.damage_tick)
	
	self.damageTableSelf.damage = damage
	if ability.advanced_level>=15 then
		damage = (caster:GetMaxHealth()*0.01* ability:GetSpecialValueFor("bonus_damage")+caster:GetStrength()) / (1.0 / self.damage_tick)
	end
	self.damageTable.damage = damage
	if ability.unlock1 then
		for i, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster,ability,"modifier_Advanced_Rot_unlock1_debuff",{})
			-- self.damageTable.victim = enemy
			-- ApplyDamage(self.damageTable)
		end
	else
		if ability.unlock2 then
			
			for i, enemy in pairs(enemies) do
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
				if not enemy:IsAlive() then
					ability:OnUnlock2Kill(enemy:GetOrigin())
				end
			end
		else
			for i, enemy in pairs(enemies) do
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
			end
		end
		
	end
	
	if not caster:HasModifier("modifier_heroTalent_npc_dota_hero_pudge_2") then
		ApplyDamage(self.damageTableSelf)
	end
end
function modifier_Advanced_Rot:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Pudge.Rot")
	end
end









modifier_Advanced_Rot_slow =modifier_Advanced_Rot_slow or advanced_modifier({})
function modifier_Advanced_Rot_slow:IsHidden()	return false end
function modifier_Advanced_Rot_slow:IsDebuff()	return true end
function modifier_Advanced_Rot_slow:IsPurgable()	return false end
-- function modifier_Advanced_Rot_slow:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Rot_slow:OnCreated(keys)
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
	self.bonus_heal_receive_amplification = 0
	self.bonus_damage = 0
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		self.bonus_damage = 10
		self.bonus_heal_receive_amplification = -30
	end
	if IsServer() then
		self.advanced_level =  self:GetAbility().advanced_level
		
	end
end

function modifier_Advanced_Rot_slow:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       
		MODIFIER_EVENT_ON_DEATH,

	}
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_pudge_2") then
		table.insert(funcs,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS)
	end

	return funcs
end

function modifier_Advanced_Rot_slow:GetModifierMoveSpeedBonus_Constant()	return self.move_slow end
function modifier_Advanced_Rot_slow:Advanced_GetModifierIncomingDamage_Percentage()	return self.bonus_damage end
function modifier_Advanced_Rot_slow:GetModifierMagicalResistanceBonus()	return -25 end


function modifier_Advanced_Rot_slow:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then

		local parent =  keys.unit
        local pos = parent:GetAbsOrigin()
        local caster = self:GetCaster()


		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			150,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = caster:GetMaxHealth()*0.1
		local damageTable = {
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
			}

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

		for i,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if self.advanced_level>=10 then
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = 1*StatusResistance})
			end
		end
	
		parent:EmitSound("Ability.SandKing_CausticFinale")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(pfx)


    end
end


-- advanced_modifier
function modifier_Advanced_Rot_slow:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_Advanced_Rot_slow:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.bonus_heal_receive_amplification
end










modifier_Advanced_Rot_unlock1_debuff =modifier_Advanced_Rot_unlock1_debuff or class({})
function modifier_Advanced_Rot_unlock1_debuff:IsHidden()	return false end
function modifier_Advanced_Rot_unlock1_debuff:IsDebuff()	return true end
function modifier_Advanced_Rot_unlock1_debuff:IsPurgable()	return false end
function modifier_Advanced_Rot_unlock1_debuff:IsPurgeException() return false end
function modifier_Advanced_Rot_unlock1_debuff:OnCreated()
	if IsServer() then
		self.damageTable = {
			victim = self:GetParent(),
			attacker =self:GetCaster(),
			-- damage = caster:GetMaxHealth()*0.01* self:GetAbility():GetSpecialValueFor("bonus_damage") / (1.0 / damage_tick),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		self.unlock1_bonus = 1
		self.damage_index = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self:SetStackCount(1)
		self.damage_timer = GameRules:GetGameTime() --下一次受到伤害的时间点
		self:StartIntervalThink(0.2)
		self:OnIntervalThink(true)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/rot/unlock1/effect_pustule.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(self:GetStackCount(),0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end

function modifier_Advanced_Rot_unlock1_debuff:OnRefresh()
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1))
		self.damage_timer = GameRules:GetGameTime() --下一次受到伤害的时间点
		self:OnIntervalThink(true)
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(self:GetStackCount(),0,0) )
	end
end
function modifier_Advanced_Rot_unlock1_debuff:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle( self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
		end
		
	end
	
end

function modifier_Advanced_Rot_unlock1_debuff:OnIntervalThink(force)
	if GameRules:GetGameTime()>=self.damage_timer then
		self.damage_timer = GameRules:GetGameTime() +1
		local caster = self:GetCaster()
		
		local damage = (caster:GetMaxHealth()*0.01* self.damage_index+caster:GetStrength())
		self.unlock1_bonus = math.min(3,self.unlock1_bonus*1.01)
		if force then
			self.damageTable.damage = damage *(1+self:GetStackCount()*0.1) *self.unlock1_bonus --处于范围中的触发 附加本身的伤害
		else
			self.damageTable.damage = damage *(self:GetStackCount()*0.1) *self.unlock1_bonus  --未处于范围中的触发 造成恶性肿瘤本身的伤害
		end
		ApplyDamage(self.damageTable)
		
	end
end




modifier_Advanced_Rot_unlock2 =modifier_Advanced_Rot_unlock2 or class({})
function modifier_Advanced_Rot_unlock2:IsHidden()	return true end
function modifier_Advanced_Rot_unlock2:IsDebuff()	return false end
function modifier_Advanced_Rot_unlock2:IsPurgable()	return false end
function modifier_Advanced_Rot_unlock2:IsPurgeException() return false end
function modifier_Advanced_Rot_unlock2:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			parent:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = parent:GetMaxHealth()
		local damageTable = {
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
			}

		-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

		for i,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
	
		parent:EmitSound("Ability.SandKing_CausticFinale")
		local pfx = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_ti7_arms/sandking_ti7_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end
