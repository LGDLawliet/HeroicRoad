--特效优化 √
LinkLuaModifier( "modifier_Advanced_enrage", "skills/Advanced_enrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_enrage_debuff", "skills/Advanced_enrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_enrage_unlock1", "skills/Advanced_enrage", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
Advanced_enrage						= Advanced_enrage or class({})
function Advanced_enrage:IsRefreshable() return false end
function Advanced_enrage:CheckKV(key)
	local table = {

		bonus_damage_reduce =0.5,
		bonus_status_resistance = 0.5,
		duration = 0.1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_enrage:Precache( context )
	PrecacheResource( "model", "models/items/lone_druid/bear/dark_wood_bear_brown/dark_wood_bear_brown.vmdl", context )
end

function Advanced_enrage:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_enrage_unlock1",{})
	return true
end
function Advanced_enrage:UnlockSecondCore(key)
	return true
end
function Advanced_enrage:UnlockThirdCore(key)
	return true
end








function Advanced_enrage:OnSpellStart()


	
	local caster =self:GetCaster()
	EmitSoundOn( "Hero_Ursa.Enrage", caster )
	caster:Purge(false, true, false, true, true)  --强驱散
	local Gain = caster:GetModifierDurationGainIndex(0.4)
	local duration = self:GetSpecialValueFor("duration")* Gain
	if self.unlock2 then
		duration = 20
		self:EndCooldown()
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_enrage", {duration =duration})
	if self.unlock3 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  700,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
		local count = 5
		for _, unit in pairs(units) do
			if not unit:HasModifier("modifier_Advanced_enrage") then
				count = count - 1
				unit:AddNewModifier(caster, self, "modifier_Advanced_enrage", {duration =duration})
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  700,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
		for _, unit in pairs(units) do
			if not unit:HasModifier("modifier_Advanced_enrage") then
				count = count - 1
				unit:AddNewModifier(caster, self, "modifier_Advanced_enrage", {duration =duration})
			end
			if count<=0 then
				break
			end
		end
	end
end





modifier_Advanced_enrage = advanced_modifier({})

-----------------------------------------------------------------------------------------
function modifier_Advanced_enrage:IsDebuff() return false end
function modifier_Advanced_enrage:IsHidden() return false end
function modifier_Advanced_enrage:IsPurgable()
	return false
end
function modifier_Advanced_enrage:IsAura() return true end
function modifier_Advanced_enrage:GetAuraDuration() return 0.5 end
function modifier_Advanced_enrage:GetModifierAura() return "modifier_Advanced_enrage_debuff" end
function modifier_Advanced_enrage:GetAuraRadius() return self.aura_radius end
function modifier_Advanced_enrage:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_enrage:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_enrage:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_Advanced_enrage:OnCreated( kv )
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

	self.bonus_damage_reduce = -self:GetAbility():GetSpecialValueFor( "bonus_damage_reduce" )
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor( "bonus_status_resistance" )
	self.ModelScale = 70
	self.aura_radius = 500
	--LV10解锁远古之姿+
	if self.advanced_level>=10 then
		self.aura_radius = 700
	end
	--LV20解锁远古之姿++
	if self.advanced_level>=20 then
		self.bonus_status_resistance = 200
		self.ModelScale = 110
	end
	local parent = self:GetParent()


	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_ti10/ursa_ti10_enrage_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		--变色
		-- ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(0,0,0))
		-- ParticleManager:SetParticleControl(self.nFXIndex, 61, Vector(1,0,0))
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 60, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		local bonus_index = 3
		local min_health_index = 0.2
		--先祖之魂+
		if self.advanced_level>=5 then
			bonus_index = 5
			min_health_index = 0.35
		end
		
		self.bonus_str = _G.GAME_ROUND*bonus_index
		self.bonus_agi = _G.GAME_ROUND*bonus_index
		self.bonus_int = _G.GAME_ROUND*bonus_index
		self.min_health = parent:GetMaxHealth()*min_health_index



		--LV15解锁暴怒
		if self.advanced_level>=15 then
			self:OnIntervalThink()
			self:StartIntervalThink(1)
		end
		self.model = "models/items/lone_druid/bear/dark_wood_bear_brown/dark_wood_bear_brown.vmdl"
		if self:GetAbility().unlock2 then
			self.unlock2 = true
			self:GetAbility():SetActivated(false)
			self:StartIntervalThink(0.3)
			self.model = "models/monster/monster_dragon/dragon_definitivo.vmdl"
			Timers:CreateTimer(0.01, function()
				self:GetParent():SetSkin(2)
			end)
		end

	end
end




function modifier_Advanced_enrage:OnDestroy( kv )

	local parent = self:GetParent()

	if IsServer() then

		if self.unlock2 then
			local ability = self:GetAbility()
			ability:SetActivated(true)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel())* self:GetParent():GetCooldownReduction() )
		end


	end
end

function modifier_Advanced_enrage:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local particle = ParticleManager:CreateParticle("particles/econ/items/ursa/ursa_ti10/ursa_ti10_earthshock.vpcf", PATTACH_POINT_FOLLOW, parent)
		local pos = parent:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle, 0, pos)
		ParticleManager:SetParticleControl(particle, 3, pos)
		ParticleManager:SetParticleControl(particle, 9, pos)
		ParticleManager:SetParticleControl(particle, 1,Vector(pos.x,pos.y,pos.z))
		ParticleManager:SetParticleControl(particle, 2,Vector(500,500,500))
		ParticleManager:ReleaseParticleIndex(particle)
		parent:EmitSound("Hero_Ursa.Earthshock")
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		local damagetable= {
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetStrength()*2,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self:GetAbility(),
			}
		
		for i, unit in pairs(units) do
			damagetable.victim =unit
			ApplyDamage(damagetable)
			if i>=5 then
				break
			end


		end
		if self:GetAbility().unlock2 then
			parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,7)
		end

	end
end
-----------------------------------------------------------------------------------------

function modifier_Advanced_enrage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		

	}
	if self:GetAbility():GetUnlock(3)==3 then
		return funcs
	end
	table.insert(funcs,MODIFIER_PROPERTY_MIN_HEALTH)

	return funcs
end

-- -----------------------------------------------------------------------------------------

function modifier_Advanced_enrage:Advanced_GetModifierIncomingDamage_Percentage( params )
	return self.bonus_damage_reduce
end


function modifier_Advanced_enrage:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Advanced_enrage:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Advanced_enrage:GetModifierBonusStats_Agility()	return self.bonus_agi end


function modifier_Advanced_enrage:GetModifierModelScale() 
    return self.ModelScale
end


function modifier_Advanced_enrage:GetModifierModelChange()
	if IsServer() then
		return self.model
	end
	
end


function modifier_Advanced_enrage:GetMinHealth() return self.min_health end




function modifier_Advanced_enrage:GetPriority()
	return 99999
end

function modifier_Advanced_enrage:CheckState()
	if self:GetAbility():GetUnlock(2)==2 then
		local state = {
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_SILENCED] = true,
		}
		
	
		return state
	end

end


function modifier_Advanced_enrage:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance}
	return funcs
end
function modifier_Advanced_enrage:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end



modifier_Advanced_enrage_debuff = class({})

function modifier_Advanced_enrage_debuff:IsDebuff()				return true end
function modifier_Advanced_enrage_debuff:IsHidden() 			return true end
function modifier_Advanced_enrage_debuff:IsPurgable() 			return true end
-- function modifier_Advanced_enrage_debuff:IsPurgeException() 	return true end

function modifier_Advanced_enrage_debuff:OnCreated( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end

	self:StartIntervalThink(2)
end

function modifier_Advanced_enrage_debuff:OnRemoved()
	if not IsServer() then
		return
	end
	self:GetParent():Stop()
end

function modifier_Advanced_enrage_debuff:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():Stop()
end
function modifier_Advanced_enrage_debuff:OnIntervalThink( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end
end



modifier_Advanced_enrage_unlock1 = class({})

function modifier_Advanced_enrage_unlock1:IsDebuff()			return false end
function modifier_Advanced_enrage_unlock1:IsHidden() 			return true end
function modifier_Advanced_enrage_unlock1:IsPurgable() 		return false end
function modifier_Advanced_enrage_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_enrage_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_enrage_unlock1:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Advanced_enrage_unlock1:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel())
	if cooldown <= 1 then
		return
	end
	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end
	local caster =self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_enrage")
	if modifier then
		modifier:SetDuration(modifier:GetRemainingTime()+math.min(cooldown*0.1,3), true)
	else
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_enrage", {duration =math.min(cooldown*0.1,3)})
	end
	


end
