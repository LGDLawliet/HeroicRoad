heroTalent_npc_dota_hero_snapfire = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire", "heroTalent/heroTalent_npc_dota_hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire_buff", "heroTalent/heroTalent_npc_dota_hero_snapfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire_debuff", "heroTalent/heroTalent_npc_dota_hero_snapfire", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_snapfire:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_snapfire"
end



modifier_heroTalent_npc_dota_hero_snapfire = class({})

function modifier_heroTalent_npc_dota_hero_snapfire:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_snapfire:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_snapfire:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_snapfire:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.3)
	end
end
function modifier_heroTalent_npc_dota_hero_snapfire:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(true, true, true,true)
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_snapfire_buff",{})
	end
end




modifier_heroTalent_npc_dota_hero_snapfire_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_snapfire_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_buff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_buff:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnCreated( kv )
	if not IsServer() then return end
	if kv.stack then
		self:SetStackCount( kv.stack )
	else
		self:SetStackCount( 9 )
	end


	self.records = {}
	self:PlayEffects()
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnRefresh( kv )
	if not IsServer() then return end
	if kv.stack then
		self:SetStackCount( kv.stack )
	else
		self:SetStackCount(9 )
	end

	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnDestroy()
	if not IsServer() then return end

	-- stop sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_snapfire_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnAttack( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetStackCount()<=0 then return end

	-- record attack
	self.records[params.record] = true

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- decrement stack
	if self:GetStackCount()>0 then
		self:DecrementStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnAttackLanded( params )
	if self.records[params.record] then
		-- add modifier
		params.target:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_heroTalent_npc_dota_hero_snapfire_debuff", -- modifier name
			{ duration = self.slow } -- kv
		)
	end

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Target"
	EmitSoundOn( sound_cast, params.target )
end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnDamageCalculated(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.target:FindModifierByName("modifier_heroTalent_npc_dota_hero_snapfire_debuff")
			if modifier then
				modifier:SafeDestroy()
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:OnAttackRecordDestroy( params )
	if self.records[params.record] then
		self.records[params.record] = nil

		-- if table is empty and no stack left, destroy
		if next(self.records)==nil and self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_snapfire_buff:GetModifierProjectileName()
	if self:GetStackCount()<=0 then return end
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end


function modifier_heroTalent_npc_dota_hero_snapfire_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount()<=0 then return end
	return 800
end


function modifier_heroTalent_npc_dota_hero_snapfire_buff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
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
end







modifier_heroTalent_npc_dota_hero_snapfire_debuff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_snapfire_debuff:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_snapfire_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_snapfire_debuff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_debuff:IsPurgable()	return true end

function modifier_heroTalent_npc_dota_hero_snapfire_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_snapfire_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -40
end