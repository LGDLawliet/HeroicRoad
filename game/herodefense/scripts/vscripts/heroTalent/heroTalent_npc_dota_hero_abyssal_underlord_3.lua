LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_3", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff", "heroTalent/heroTalent_npc_dota_hero_abyssal_underlord_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heroTalent_npc_dota_hero_abyssal_underlord_3 == nil then
	heroTalent_npc_dota_hero_abyssal_underlord_3 = class({})
end
function heroTalent_npc_dota_hero_abyssal_underlord_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_abyssal_underlord_3"
end
function heroTalent_npc_dota_hero_abyssal_underlord_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", context )
end
---------------------------------------------------------------------
--Modifiers
if modifier_heroTalent_npc_dota_hero_abyssal_underlord_3 == nil then
	modifier_heroTalent_npc_dota_hero_abyssal_underlord_3 = class({})
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3:IsHidden() return true end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	
	if IsServer() then
		self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
	end
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3:OnDestroy()
	if IsServer() then
		if self.filter then
			FilterManager:RemoveExecuteOrderFilter( self.filter )
		end
		
	end
end


function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3:OrderFilter(data)
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end	
	end
	if not found then return true end

	if data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and self:GetAbility():IsCooldownReady() then
		
		self:GetParent():SetAbsOrigin(EntIndexToHScript(data.entindex_target):GetAbsOrigin()+EntIndexToHScript(data.entindex_target):GetForwardVector()*50)
		self:GetParent():SetForwardVector(EntIndexToHScript(data.entindex_target):GetForwardVector()*-1)
		self:GetAbility().buff = parent:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff", {duration = self.duration})
		self:GetAbility().debuff = EntIndexToHScript(data.entindex_target):AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff", {duration = self.duration})
		local caster = self:GetParent()
		local point = EntIndexToHScript(data.entindex_target):GetAbsOrigin()
		local origin = caster:GetOrigin()
		local min_dist = 1
		local max_dist = 100000 --不能用-1
		local direction = (point-origin)
		local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
		direction.z = 0
		direction = direction:Normalized()
	
		local target = GetGroundPosition( origin + direction*dist, nil )
		FindClearSpaceForUnit( caster, target, true )
		
		self:PlayEffects1( origin, target ,direction)
		self:GetAbility():UseResources(true, true, true, true)
	end
	return true
end

function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3:PlayEffects1( origin, target ,direction)
	
	local particle_cast = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
	local particle_end = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
	local sound_start = "Hero_Antimage.Blink_in"
	local sound_end = "Hero_Antimage.Blink_out"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward(effect_cast, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex( effect_cast )


	local effect_cast = ParticleManager:CreateParticle( particle_end, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end
-------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:OnCreated()
	self.damage_index = self:GetAbility():GetSpecialValueFor("damage_index")*0.01
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self:StartIntervalThink(self.interval)
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:OnIntervalThink()
	if not IsServer() then return end
	local healing = HealWithGain(self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*self.damage_index,self:GetParent(),self:GetParent(),self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), healing, nil)
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH= {nil, self:GetParent()},
	}
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_buff:OnDeath()
	self:GetAbility().buff:SafeDestroy()
	self:GetAbility().debuff:SafeDestroy()
	--print(self:GetAbility().buff)
	--print(self:GetAbility().debuff)
	--print("..")
end
-----------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:OnCreated()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:OnIntervalThink()
	if not IsServer() then return end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetAbility():GetCaster(),
		damage = self:GetAbility():GetCaster():GetAverageTrueAttackDamage(self:GetAbility():GetCaster()) * self:GetAbility():GetSpecialValueFor("damage_index")*0.01,
		damage_type = DAMAGE_TYPE_PURE ,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH= {nil, self:GetParent()},
	}
end
function modifier_heroTalent_npc_dota_hero_abyssal_underlord_3_debuff:OnDeath()
	--print("????")
	self:GetAbility().buff:SafeDestroy()
	self:GetAbility().debuff:SafeDestroy()
	print(self:GetAbility().buff)
	print(self:GetAbility().debuff)
	--print("..")
	self:GetAbility().buff:SetDuration(0,true)
	
end

