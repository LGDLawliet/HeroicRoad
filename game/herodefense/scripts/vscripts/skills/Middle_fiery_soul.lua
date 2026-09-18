Middle_fiery_soul = Middle_fiery_soul or class({})

LinkLuaModifier("modifier_Middle_fiery_soul", "skills/Middle_fiery_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_fiery_soul_active", "skills/Middle_fiery_soul", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function Middle_fiery_soul:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/fiery_soul/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/fiery_soul_active/effect.vpcf", context )


	

end


function Middle_fiery_soul:GetIntrinsicModifierName()
	return "modifier_Middle_fiery_soul"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_Middle_fiery_soul = modifier_Middle_fiery_soul or class({})
--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:IsHidden()
	return ( self:GetStackCount() == 0 )
end
function modifier_Middle_fiery_soul:IsPurgable() return false end
function modifier_Middle_fiery_soul:IsPurgeException() return false end
function modifier_Middle_fiery_soul:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:OnCreated( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self.flFierySoulDuration = 0

	if IsServer() then
		self.cast_time = 0
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/fiery_soul/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:OnRefresh( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )

	if IsServer() then
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) ) 
	end
end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:SetStackCount( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.fiery_soul_move_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.fiery_soul_attack_speed_bonus
end


--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul:OnAbilityExecuted( keys )
	if IsServer() then
		if keys.unit == self:GetParent() then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local hAbility = keys.ability 
			if hAbility:GetCooldown(-1)<3 then
				return
			end
			if hAbility ~= nil and ( not hAbility:IsItem() ) and ( not hAbility:IsToggle() ) then
				if self:GetStackCount() < self.fiery_soul_max_stacks then
					self:IncrementStackCount()
				else
					self:SetStackCount( self:GetStackCount() )
					self:ForceRefresh()
				end
				self.cast_time = self.cast_time + 1
				if self.cast_time>=4 then
					self.cast_time = 0
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Middle_fiery_soul_active", { duration = 2 } )
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
modifier_Middle_fiery_soul_active = modifier_Middle_fiery_soul_active or advanced_modifier({})
--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul_active:IsHidden()	return false end
function modifier_Middle_fiery_soul_active:IsPurgable() return false end
function modifier_Middle_fiery_soul_active:IsPurgeException() return false end

--------------------------------------------------------------------------------

function modifier_Middle_fiery_soul_active:OnCreated( kv )
	
	if IsServer() then
		self.bonus_damage = 50
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/fiery_soul_active/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end


--------------------------------------------------------------------------------

-- function modifier_Middle_fiery_soul_active:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
-- 	}

-- 	return funcs
-- end


-- function modifier_Middle_fiery_soul_active:GetModifierTotalDamageOutgoing_Percentage( keys )
-- 	if keys.damage_type ==DAMAGE_TYPE_MAGICAL  then
-- 		return self.bonus_damage
-- 	end
-- end




-- advanced_modifier
function modifier_Middle_fiery_soul_active:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Middle_fiery_soul_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type ==DAMAGE_TYPE_MAGICAL  then
		return self.bonus_damage
	end
end
