heroTalent_npc_dota_hero_marci_3 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_3", "heroTalent/heroTalent_npc_dota_hero_marci_3", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_marci_3:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_marci_3:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_marci_3:IsStealable() 				return true end
function heroTalent_npc_dota_hero_marci_3:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_marci_3:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_marci_3" end
-- function heroTalent_npc_dota_hero_marci_3:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return 1000 - caster:GetCastRangeBonus()

-- end
function heroTalent_npc_dota_hero_marci_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/marci_talent/talent_3/eye_effect/effect_buff.vpcf", context )

end

modifier_heroTalent_npc_dota_hero_marci_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_marci_3:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_marci_3:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_marci_3:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_marci_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_marci_3:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_marci_3:OnCreated(keys)
	local abiluty = self:GetAbility()
	self.bonus_attribute = abiluty:GetSpecialValueFor("bonus_attribute")
	self.bonus_attribute_per_level = abiluty:GetSpecialValueFor("bonus_attribute_per_level")
	self.attack_rate = abiluty:GetSpecialValueFor("attack_rate")
	self.min_move = abiluty:GetSpecialValueFor("min_move")
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		-- self:StartIntervalThink(0.3)
		self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )




		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/marci_talent/talent_3/eye_effect/effect_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "eye_l", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "eye_r", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self:StartIntervalThink(30)
	end
end

function modifier_heroTalent_npc_dota_hero_marci_3:OnIntervalThink()
	local parent = self:GetParent()
	local arti_72 = parent:FindModifierByName("modifier_item_hd_onlyone_effects")
	if arti_72 then
		arti_72:ForceRefresh()
	end
end

function modifier_heroTalent_npc_dota_hero_marci_3:OnRefresh(keys)
	local abiluty = self:GetAbility()
	self.bonus_attribute = abiluty:GetSpecialValueFor("bonus_attribute")
	self.bonus_attribute_per_level = abiluty:GetSpecialValueFor("bonus_attribute_per_level")
	self.attack_rate = abiluty:GetSpecialValueFor("attack_rate")
	self.min_move = abiluty:GetSpecialValueFor("min_move")
end
function modifier_heroTalent_npc_dota_hero_marci_3:OnDestroy()
	if IsServer() then
		if self.filter then
			FilterManager:RemoveExecuteOrderFilter( self.filter )
		end
		
	end
end


function modifier_heroTalent_npc_dota_hero_marci_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_marci_3:OnOrder( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero()then
		return
	end

	if params.unit~=self:GetParent() then return end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if parent:IsRooted() then
		return  
	end
	-- 天与咒缚的翻墙效果
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
        local current_pos = parent:GetAbsOrigin()
        local leap_dis = CalculateDistance(params.new_pos,current_pos)
        if leap_dis<=400 then
            local pos = GetClearSpaceForUnit(parent,params.new_pos)
            if math.abs((pos.z-current_pos.z))>=32 then
                if parent:HasModifier("modifier_generic_arc_lua") then
                    return
                end
                local dis = CalculateDistance(params.new_pos,pos)
                if dis<=200 then
                    -- FindClearSpaceForUnit( parent, pos, true )

                    local arc = parent:AddNewModifier(
                        parent, -- player source
                        self:GetAbility(), -- ability source
                        "modifier_generic_arc_lua", -- modifier name
                        {
                            target_x = pos.x,
                            target_y = pos.y,
                            distance = leap_dis,
                            duration = 0.4,
                            height = 300,
                            fix_end = false,
                            isForward = true,
                            -- activity = 
                            -- isRestricted = true,
                        } -- kv
                    )
                    parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_2, 0.1, 0.9, 0.7)
                    parent:EmitSound("Hero_Techies.ProjectileImpact")
                    arc:SetEndCallback(function()
                        parent:EmitSound("Hero_Marci.Unleash.Pulse")
                        parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 0.1, 0.9, 1)
                    end)
					FireDefaultMoveEvent(parent,self:GetAbility())
       
                end
            end
        end
		
	end
end
function modifier_heroTalent_npc_dota_hero_marci_3:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ORDER = {self:GetParent(), nil}
	
    }
end
function modifier_heroTalent_npc_dota_hero_marci_3:Advanced_GetModifierBonusStats_Strength(keys)
	return self.bonus_attribute + self:GetParent():GetLevel()*self.bonus_attribute_per_level
end
function modifier_heroTalent_npc_dota_hero_marci_3:Advanced_GetModifierBonusStats_Agility(keys)
	return self.bonus_attribute + self:GetParent():GetLevel()*self.bonus_attribute_per_level
end
function modifier_heroTalent_npc_dota_hero_marci_3:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.bonus_attribute + self:GetParent():GetLevel()*self.bonus_attribute_per_level
end
function modifier_heroTalent_npc_dota_hero_marci_3:GetModifierBaseAttackTimeConstant(keys)
	return self.attack_rate
end

function modifier_heroTalent_npc_dota_hero_marci_3:GetModifierMoveSpeed_AbsoluteMin(keys)
	return self.min_move
end


-- function modifier_heroTalent_npc_dota_hero_marci_3:CheckState()
-- 	local state = {[MODIFIER_STATE_SILENCED] = true}
-- 	return state
-- end

function modifier_heroTalent_npc_dota_hero_marci_3:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if data.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		data.order_type==DOTA_UNIT_ORDER_CAST_TARGET  or
		data.order_type==DOTA_UNIT_ORDER_CAST_NO_TARGET
	then
		if data.entindex_ability then
			local ability =EntIndexToHScript( data.entindex_ability)
			if ability and not ability:IsItem() then
				SendCustomErrorToPlayer(data.issuer_player_id_const,"dota_hud_silence_cast","General.Cancel")
				return false
			end
		end
		-- dota_hud_silence_cast
		
	end
	
	return true
end

-- modifier_heroTalent_npc_dota_hero_marci_3_effect = class({})

-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:IsDebuff() return false end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:IsHidden() return false end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:IsPurgable() 		return false end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:IsPurgeException() 	return false end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:RemoveOnDeath()  return false end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:GetStatusEffectName()
-- 	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
-- end

-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:StatusEffectPriority()
-- 	return MODIFIER_PRIORITY_NORMAL
-- end

-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:OnCreated( kv )
-- 	if not IsServer() then return end
-- 	self:PlayEffects1()
-- end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:OnTakeDamage( params )

-- 	if IsServer() then
-- 		local Attacker = params.attacker
-- 		local Target = params.unit
-- 		local flDamage = params.damage

-- 		if Attacker ~= self:GetParent() or Target == nil then
-- 			return 0
-- 		end

-- 		if params.damage_category == 0 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
-- 			return
-- 		end

-- 		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
-- 			return 0
-- 		end
-- 		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
-- 			return 0
-- 		end
-- 		if flDamage<=0 then
-- 			return
-- 		end
	
-- 		self.bonus_life_steal = 0.15
-- 		local gain = Attacker:GetModifierLifeStealGain(1)
-- 		local flLifesteal = flDamage * self.bonus_life_steal*gain
-- 		self.target:Heal( flLifesteal, self:GetAbility() )
-- 		self:PlayEffects2()
-- 	end

-- 	return 0.0

-- end
-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:PlayEffects2()

-- 	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.target )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )
-- end


-- function modifier_heroTalent_npc_dota_hero_marci_3_effect:PlayEffects1()
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
-- 	if self:GetParent()~=self:GetCaster() then
-- 		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
-- 	end

-- 	local sound_target = "Hero_Marci.Guardian.Applied"

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
-- 	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
-- 	-- ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- buff particle
-- 	self:AddParticle(
-- 		effect_cast,
-- 		false, -- bDestroyImmediately
-- 		false, -- bStatusEffect
-- 		-1, -- iPriority
-- 		false, -- bHeroEffect
-- 		false -- bOverheadEffect
-- 	)

-- 	-- Create Sound
-- 	EmitSoundOn( sound_target, self:GetParent() )
-- end
