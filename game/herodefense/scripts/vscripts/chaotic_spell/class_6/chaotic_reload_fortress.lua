
chaotic_reload_fortress = class({})
LinkLuaModifier("modifier_chaotic_reload_fortress", "chaotic_spell/class_6/chaotic_reload_fortress", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_reload_fortress_debuff", "chaotic_spell/class_6/chaotic_reload_fortress", LUA_MODIFIER_MOTION_NONE)

function chaotic_reload_fortress:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_reload_fortress/effect_sheild/effect.vpcf", context )
end

function chaotic_reload_fortress:GetHealthCost(iLevel)
	local cost = self.BaseClass.GetHealthCost(self,iLevel)

	local caster = self:GetCaster()
	local stack = caster:GetModifierStackCount("modifier_chaotic_reload_fortress_debuff", caster)
	if stack>=1 then
		cost = cost + stack* self:GetSpecialValueFor("bonus_health_cost_per_second")
	end

	return cost
end



function chaotic_reload_fortress:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chaotic_reload_fortress", {})
		self.healingStack = 0
	else
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_chaotic_reload_fortress")
	end
end







modifier_chaotic_reload_fortress = modifier_chaotic_reload_fortress or advanced_modifier({})
function modifier_chaotic_reload_fortress:IsDebuff() return false end
function modifier_chaotic_reload_fortress:IsHidden() return true end
function modifier_chaotic_reload_fortress:IsPurgable() return false end
function modifier_chaotic_reload_fortress:IsPurgeException() return false end

function modifier_chaotic_reload_fortress:CheckState()
	local state={
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_chaotic_reload_fortress:OnCreated(keys)
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.forward_angle = self:GetAbility():GetSpecialValueFor("forward_angle")
	self.trigger_chance = self:GetAbility():GetSpecialValueFor("trigger_chance")
	self.healing_receive_amp = self:GetAbility():GetSpecialValueFor("healing_receive_amp")
	self.health_cost = self:GetAbility():GetSpecialValueFor("health_cost")
	self.bonus_health_cost_per_second = self:GetAbility():GetSpecialValueFor("bonus_health_cost_per_second")
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("debuff_duration")

	if IsServer() then
		local caster = self:GetCaster()
		local origin = caster:GetAbsOrigin()
		local targetPos = origin+caster:GetForwardVector()*50
		self.effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_era/chaotic_reload_fortress/effect_sheild/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.effect_cast1,10, origin )
		ParticleManager:SetParticleControlEnt( self.effect_cast1, 0, caster, PATTACH_POINT_FOLLOW, "" , caster:GetOrigin(), true )
		ParticleManager:SetParticleControlForward(self.effect_cast1, 0,caster:GetForwardVector())  --方向
		self:AddParticle( self.effect_cast1, false, false, -1, true, false )
		local newpos1 = RotatePosition(origin, QAngle(0, 60, 0), targetPos)
		local pfxdirection1 = (newpos1-origin):Normalized()
		local newpos2 = RotatePosition(origin, QAngle(0, -60, 0), targetPos)
		local pfxdirection2 = (newpos2-origin):Normalized()
		self.effect_cast2 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_era/chaotic_reload_fortress/effect_sheild/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, origin )
		ParticleManager:SetParticleControl( self.effect_cast2,10, origin )
		-- ParticleManager:SetParticleControlEnt( self.effect_cast2, 0, caster, PATTACH_POINT_FOLLOW, "" , caster:GetOrigin(), true )
		ParticleManager:SetParticleControlForward(self.effect_cast2, 0,pfxdirection1)  --方向
		self:AddParticle( self.effect_cast2, false, false, -1, true, false )
		self.effect_cast3 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_era/chaotic_reload_fortress/effect_sheild/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.effect_cast3, 0, origin )
		ParticleManager:SetParticleControl( self.effect_cast3,10, origin )
		-- ParticleManager:SetParticleControlEnt( self.effect_cast3, 0, caster, PATTACH_POINT_FOLLOW, "" , caster:GetOrigin(), true )
		ParticleManager:SetParticleControlForward(self.effect_cast3, 0,pfxdirection2)  --方向
		self:AddParticle( self.effect_cast3, false, false, -1, true, false )
		self:StartIntervalThink(0.15)
	end


end
function modifier_chaotic_reload_fortress:OnIntervalThink()
	local parent = self:GetParent()
	if not self.firstInit then
		self.firstInit = true
		ParticleManager:SetParticleControlEnt( self.effect_cast2, 0, parent, PATTACH_POINT_FOLLOW, "" , parent:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.effect_cast3, 0, parent, PATTACH_POINT_FOLLOW, "" , parent:GetOrigin(), true )
		self:StartIntervalThink(1)
	end
	local  ability = self:GetAbility()
	parent:AddNewModifier(parent, ability, "modifier_chaotic_reload_fortress_debuff", {duration = self.debuff_duration})
	-- ability:UseResources(true, true, true, true)
	if ability:GetRuneType()==1 then
		local damageTable = {
			victim = parent,
			attacker = parent,
			damage = ability:GetHealthCost(-1),
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags =  DOTA_DAMAGE_FLAG_REFLECTION,
			ability = ability, --Optional.
		}
		ApplyDamage(damageTable)
	else
		parent:ModifyHealth(parent:GetHealth()-ability:GetHealthCost(-1),ability,false,0)
	end
	
	-- if ability:GetHealthCost(-1)>=parent:GetHealth() then
	-- 	ability:ToggleAbility()
	-- end
	
	
	
end


function modifier_chaotic_reload_fortress:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE, -- 受到治疗增强

	}
	return funcs
end
function modifier_chaotic_reload_fortress:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	if keys.inflictor and keys.inflictor==self:GetAbility() then
		return 0
	end
	
	local parent = keys.target
	local attacker = keys.attacker
	local reduction = self.damage_reduction

	-- Check target position
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	-- calculate damage reduction
	if angle_diff < self.forward_angle then
		if parent:RollRandom(self.trigger_chance,1) then
			reduction = 1-math.min(reduction *0.01,0.99)
			reduction =100- math.pow(reduction,2)*100
			-- print("reduction=",reduction)
		end
		
		-- self:PlayEffects( true)
	end

	return -reduction
end


function modifier_chaotic_reload_fortress:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.healing_receive_amp
end


function modifier_chaotic_reload_fortress:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_chaotic_reload_fortress:GetModifierDisableTurning()
	return 1
end







modifier_chaotic_reload_fortress_debuff = modifier_chaotic_reload_fortress_debuff or advanced_modifier({})
function modifier_chaotic_reload_fortress_debuff:IsDebuff() return true end
function modifier_chaotic_reload_fortress_debuff:IsHidden() return false end
function modifier_chaotic_reload_fortress_debuff:IsPurgable() return false end
function modifier_chaotic_reload_fortress_debuff:IsPurgeException() return false end
function modifier_chaotic_reload_fortress_debuff:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_chaotic_reload_fortress_debuff:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end