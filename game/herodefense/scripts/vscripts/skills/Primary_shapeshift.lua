
Primary_shapeshift = class({})
LinkLuaModifier("modifier_Primary_shapeshift_transform_stun", "skills/Primary_shapeshift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_shapeshift_transform", "skills/Primary_shapeshift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_shapeshift", "skills/Primary_shapeshift", LUA_MODIFIER_MOTION_NONE)

function Primary_shapeshift:Precache( context )
	PrecacheResource( "model", "models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl", context )
	PrecacheResource( "model", "models/heroes/lycan/lycan_wolf.vmdl", context )
end

function Primary_shapeshift:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local transformation_time = 1.2
	local duration = ability:GetSpecialValueFor("duration")	
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_lycan") then
		duration = duration * 2
	end
	
	-- Start transformation gesture
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)



	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Primary_shapeshift_transform"
	
	-- Play cast sound
	EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
	
	-- Add cast particle effects
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 2 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	-- Disable Lycan for the transform duration
	caster:AddNewModifier(caster, ability, "modifier_Primary_shapeshift_transform_stun", {duration = transformation_time})
	
	-- Wait the transformation time
	Timers:CreateTimer(transformation_time, function()
		-- Give Lycan transform buff
		local gain = caster:GetModifierDurationGainIndex(0.3)
		caster:AddNewModifier(caster, ability, "modifier_Primary_shapeshift_transform", {duration = duration*gain})
	end)	
end


modifier_Primary_shapeshift_transform_stun = class({})

function modifier_Primary_shapeshift_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end
function modifier_Primary_shapeshift_transform_stun:IsHidden()
	return true
end

modifier_Primary_shapeshift_transform = advanced_modifier({})
function modifier_Primary_shapeshift_transform:IsHidden()	return false end
function modifier_Primary_shapeshift_transform:IsPurgable()	return false end
function modifier_Primary_shapeshift_transform:IsDebuff()	return false end
function modifier_Primary_shapeshift_transform:IsAura() return true end
function modifier_Primary_shapeshift_transform:GetAuraDuration() return 0.1 end
function modifier_Primary_shapeshift_transform:GetModifierAura() return "modifier_Primary_shapeshift" end
function modifier_Primary_shapeshift_transform:GetAuraRadius() return 4000 end
function modifier_Primary_shapeshift_transform:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end
function modifier_Primary_shapeshift_transform:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Primary_shapeshift_transform:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_shapeshift_transform:AllowIllusionDuplicate()	return false end
function modifier_Primary_shapeshift_transform:GetAuraEntityReject(target)
    if IsServer() then	    	
    	if target:IsRealHero() then
    		if target == self.caster then		
    			return false
    		end
    	end
    	
    	if target:GetOwnerEntity() then
    		if target:GetOwnerEntity() == self.caster then
    			return false
    		end
    	end	
    		
    	return true
    end
end



function modifier_Primary_shapeshift_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
		}
		
		return decFuncs	
end
function modifier_Primary_shapeshift_transform:GetModifierModelScale() 
    return 25
end


function modifier_Primary_shapeshift_transform:GetModifierModelChange()
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_lycan") then
		return "models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl"
	end
	return "models/heroes/lycan/lycan_wolf.vmdl"
end

function modifier_Primary_shapeshift_transform:OnCreated()
    if IsServer() then
    	self.caster = self:GetCaster()
    	self.ability = self:GetAbility()

    end
end

function modifier_Primary_shapeshift_transform:OnDestroy()
    if IsServer() then    	


    	
    	local particle_revert_fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    	ParticleManager:SetParticleControl(particle_revert_fx, 0, self:GetParent():GetAbsOrigin())
    	ParticleManager:SetParticleControl(particle_revert_fx, 3, self:GetParent():GetAbsOrigin())
    	ParticleManager:ReleaseParticleIndex(particle_revert_fx)
 	
    end
end


function modifier_Primary_shapeshift_transform:Advanced_GetModifierAttackRangeOverride() 	return 200 end
function modifier_Primary_shapeshift_transform:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
	}
end


-- Speed/crit modifier
modifier_Primary_shapeshift = advanced_modifier({})
function modifier_Primary_shapeshift:IsHidden()	return true end
function modifier_Primary_shapeshift:IsPurgable()	return false end
function modifier_Primary_shapeshift:IsDebuff()	return false end
function modifier_Primary_shapeshift:OnCreated()	
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
	self.parent = self:GetParent()    
	self.certain_crit_buff = "modifier_Primary_shapeshift_certain_crit"
    self.transform_buff = "modifier_Primary_shapeshift_transform"

    -- Ability specials
    self.night_vision_bonus = self.ability:GetSpecialValueFor("night_vision_bonus")
    self.absolute_speed = self.ability:GetSpecialValueFor("bonus_move")
    self.crit_chance = self.ability:GetSpecialValueFor("bonus_damage_chance")
    self.crit_damage = self.ability:GetSpecialValueFor("bonus_damage")       

		

end


function modifier_Primary_shapeshift:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
end

function modifier_Primary_shapeshift:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_shapeshift:DeclareFunctions()
		local decFuncs = {
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
			-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
						}		
		return decFuncs	
end

function modifier_Primary_shapeshift:Advanced_GetBonusNightVision()	
	return self.night_vision_bonus
end

function modifier_Primary_shapeshift:GetModifierMoveSpeed_AbsoluteMin()
	return self.absolute_speed
end



-- advanced_modifier
function modifier_Primary_shapeshift:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }

	return funcs

end
function modifier_Primary_shapeshift:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if keys.attacker==self.parent and self.crit_chance>=RandomInt(1, 100) then
			if keys.damage_category==DOTA_DAMAGE_CATEGORY_SPELL then
				return
			end
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast_e.vpcf", PATTACH_POINT_FOLLOW, keys.target)
			local pos = keys.target:GetAbsOrigin()
			pos.z = pos.z +64
			ParticleManager:SetParticleControl(particle, 3, pos)
			ParticleManager:ReleaseParticleIndex(particle)
			return self.crit_damage
		end
	end
	return 0
end








