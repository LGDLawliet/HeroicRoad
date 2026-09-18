--特效优化 √
require('internal/timers') 
Advanced_fiery_soul = Advanced_fiery_soul or class({})

LinkLuaModifier("modifier_Advanced_fiery_soul", "skills/Advanced_fiery_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fiery_soul_active", "skills/Advanced_fiery_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fiery_soul_lv25", "skills/Advanced_fiery_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fiery_soul_unlock3", "skills/Advanced_fiery_soul", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function Advanced_fiery_soul:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/fiery_soul/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/fiery_soul_active/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/fiery_soul_active/effect_unlock3.vpcf", context )

	
end

function Advanced_fiery_soul:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_fiery_soul:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_fiery_soul:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end


function Advanced_fiery_soul:CheckKV(key)
	local table = {


		fiery_soul_attack_speed_bonus = 1,
		fiery_soul_move_speed_bonus = 0.3,


	}
	local value = table[key] or -1
	return value

end

function Advanced_fiery_soul:GetIntrinsicModifierName()
	return "modifier_Advanced_fiery_soul"
end
function Advanced_fiery_soul:OnAdvancedUpgrade()
	if self.advanced_level>=25 then
		local caster = self:GetCaster()
		if not caster:HasModifier("modifier_Advanced_fiery_soul_lv25") then
			caster:AddNewModifier(caster, self, "modifier_Advanced_fiery_soul_lv25", {}) 
		end
	end
end

function Advanced_fiery_soul:GetBehavior()

	if self:GetUnlock(3)==3 then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	return self.BaseClass.GetBehavior(self)
end


function Advanced_fiery_soul:ResetToggleOnRespawn()
	return true
end


function Advanced_fiery_soul:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then

		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_fiery_soul_unlock3", {})
	else


		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_fiery_soul_unlock3", self:GetCaster())
	end
	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_Advanced_fiery_soul = modifier_Advanced_fiery_soul or class({})
--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:IsHidden()
	return ( self:GetStackCount() == 0 )
end
function modifier_Advanced_fiery_soul:IsPurgable() return false end
function modifier_Advanced_fiery_soul:IsPurgeException() return false end
function modifier_Advanced_fiery_soul:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:OnCreated( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self.flFierySoulDuration = 0

	if IsServer() then
		self.active_spell_list = {
			Advanced_Spear= true,
			Middle_Spear = true,
			Primary_Dual_Breath = true,
			Middle_Dual_Breath = true,
			Advanced_Dual_Breath = true,
		}
		self.cast_time = 0
		self.bonus_cast = 3
		self.cast_time_needed = 4
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/fiery_soul/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:OnRefresh( kv )
	local ability = self:GetAbility()
	self.fiery_soul_attack_speed_bonus = ability:GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = ability:GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = ability:GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = ability:GetSpecialValueFor( "duration_tooltip" )

	if IsServer() then
		if ability.advanced_level>=10 then
			self.bonus_cast = 4
			if ability.advanced_level>=15 then
				self.fiery_soul_max_stacks = self.fiery_soul_max_stacks+1
				self.cast_time_needed = 3
				if ability.unlock2 then
					self.fiery_soul_max_stacks = 15
					self.duration_tooltip = 5
				end
			end
		end
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) ) 
	end
end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:SetStackCount( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.fiery_soul_move_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.fiery_soul_attack_speed_bonus
end


--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul:OnAbilityExecuted( keys )
	if IsServer() then
		local parent = self:GetParent()
		if keys.unit == parent then
			if parent:PassivesDisabled() then
				return 0
			end

			local hAbility = keys.ability 
			if hAbility:GetCooldown(-1)<3 then
				return
			end
			if hAbility ~= nil and ( not hAbility:IsItem() ) and ( not hAbility:IsToggle() ) then
	
				if hAbility:IsFireSpell() then
					local stack = self:GetStackCount()
					--触发双重施法
					if stack>=15 or (stack>=1 and parent:GetRandomEffect(stack*self.bonus_cast,INT_TYPE,1)  > RandomInt(1, 100)) then
						local pos = parent:GetCursorPosition()
						local target = parent:GetCursorCastTarget()
						Timers(1, function()
							if not hAbility:IsNull() then
								local current_pos = parent:GetCursorPosition()
								local current_target = parent:GetCursorCastTarget()
								parent:SetCursorPosition(pos)
								parent:SetCursorCastTarget(target)
								hAbility:OnSpellStart()
								parent:SetCursorPosition(current_pos)
								parent:SetCursorCastTarget(current_target)
							end
						end)
						
					end
				end
		
				if self:GetStackCount() < self.fiery_soul_max_stacks then
					self:IncrementStackCount()
				else
					self:SetStackCount( self:GetStackCount() )
					self:ForceRefresh()
				end
				self.cast_time = self.cast_time + 1
				if self.cast_time>=self.cast_time_needed then
					self.cast_time = 0
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_fiery_soul_active", { duration = 2 } )
				end

				self:SetDuration( self.duration_tooltip, true )
				self:StartIntervalThink( self.duration_tooltip )
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_Advanced_fiery_soul_active = modifier_Advanced_fiery_soul_active or advanced_modifier({})
--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul_active:IsHidden()	return false end
function modifier_Advanced_fiery_soul_active:IsPurgable() return false end
function modifier_Advanced_fiery_soul_active:IsPurgeException() return false end

--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul_active:OnCreated( kv )
	
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if IsServer() then
		self.bonus_damage = 50
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/fiery_soul_active/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end


function modifier_Advanced_fiery_soul_active:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_CastPoint
    }

	return funcs

end
function modifier_Advanced_fiery_soul_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type ==DAMAGE_TYPE_MAGICAL  then
		return self.bonus_damage
	end
end

function modifier_Advanced_fiery_soul_active:Advanced_GetModifier_CastPoint() 
	if self.advanced_level>=5 then
		return 100
	end
	return 0 
end










modifier_Advanced_fiery_soul_lv25 = modifier_Advanced_fiery_soul_lv25 or class({})
--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul_lv25:IsHidden()
	return true
end
function modifier_Advanced_fiery_soul_lv25:IsPurgable() return false end
function modifier_Advanced_fiery_soul_lv25:IsPurgeException() return false end
function modifier_Advanced_fiery_soul_lv25:DestroyOnExpire()	return false end
function modifier_Advanced_fiery_soul_lv25:RemoveOnDeath() return false end
function modifier_Advanced_fiery_soul_lv25:DeclareFunctions()
	if IsClient() then
		return
	end
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	if not self.ability then
		table.insert(funcs,MODIFIER_EVENT_ON_ABILITY_EXECUTED)
	end

	return funcs
end
function modifier_Advanced_fiery_soul_lv25:OnAbilityExecuted( keys )
	if IsServer() then
	
		-- print("ok")
		if self.ability then
			return
		end
		local parent = self:GetParent()
		if keys.unit == parent then
			if parent:PassivesDisabled() then
				return 0
			end

			local hAbility = keys.ability 
			if hAbility:GetCooldown(-1)<3 or not hAbility:IsRefreshable() then
				return
			end
			if hAbility ~= nil and ( not hAbility:IsItem() ) and ( not hAbility:IsToggle() ) then
				self.ability = hAbility
				-- parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_fiery_soul_lv25", {}) 
				-- self:SetStackCount(1)
			end
		end
	end

	return 0
end

function modifier_Advanced_fiery_soul_lv25:GetModifierPercentageCooldown(keys)
	if IsServer() then
		if self.ability and keys.ability then
			if self.ability==keys.ability then
				if self:GetAbility().unlock1 then
					return 45
				end
				return 20
			end
		end
	end
	
end











modifier_Advanced_fiery_soul_unlock3 = modifier_Advanced_fiery_soul_unlock3 or advanced_modifier({})
--------------------------------------------------------------------------------

function modifier_Advanced_fiery_soul_unlock3:IsHidden()
	return false
end
function modifier_Advanced_fiery_soul_unlock3:IsPurgable() return false end
function modifier_Advanced_fiery_soul_unlock3:IsPurgeException() return false end
function modifier_Advanced_fiery_soul_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_fiery_soul_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_fiery_soul_unlock3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
		local parent = self:GetParent()
		local health = parent:GetHealth() -parent:GetMaxHealth()*0.05
		parent:ModifyHealth(health,self:GetAbility(),false,0)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/fiery_soul_active/effect_unlock3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end
function modifier_Advanced_fiery_soul_unlock3:OnIntervalThink()
	local parent = self:GetParent()
	local health = parent:GetHealth() -parent:GetMaxHealth()*0.15
	parent:ModifyHealth(health,self:GetAbility(),false,0)
end
function modifier_Advanced_fiery_soul_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}


	return funcs
end

function modifier_Advanced_fiery_soul_unlock3:GetModifierBonusStats_Strength(keys)
	return 70
end
function modifier_Advanced_fiery_soul_unlock3:GetModifierBonusStats_Intellect(keys)
	return 70
end
function modifier_Advanced_fiery_soul_unlock3:GetModifierBonusStats_Agility(keys)
	return 70
end
function modifier_Advanced_fiery_soul_unlock3:Advanced_GetModifierSpellAmplifyBonus(keys)
	return 70
end

function modifier_Advanced_fiery_soul_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_Advanced_fiery_soul_unlock3:Advanced_GetModifierCastRangeBonusStacking(keys)
	return 800
end

