LinkLuaModifier("modifier_chaotic_meteor_swarm_thinker", "chaotic_spell/class_9/chaotic_meteor_swarm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_meteor_swarm_buff", "chaotic_spell/class_9/chaotic_meteor_swarm", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_meteor_swarm_debuff", "chaotic_spell/class_9/chaotic_meteor_swarm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_meteor_swarm_debuff_burn", "chaotic_spell/class_9/chaotic_meteor_swarm", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_chaotic_meteor_swarm_debuff_damage", "chaotic_spell/class_9/chaotic_meteor_swarm", LUA_MODIFIER_MOTION_NONE)




require("internal.ui_event.boss_entry")
chaotic_meteor_swarm = class({})

function chaotic_meteor_swarm:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/effect_main/fly.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/hit_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/burn_efect/effect.vpcf", context )
end


function chaotic_meteor_swarm:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_meteor_swarm:CastFilterResultLocation( vLoc )

	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	-- if IsValid(self.modifier) then
		
	-- 	local result = self.modifier:CheckPos(vLoc)
	-- 	if result==1 then
	-- 		return UF_SUCCESS
	-- 	elseif result==2 then
	-- 		self.error = "DOTA_HUB_CANT_CAST_Same_Pos"
	-- 		return UF_FAIL_CUSTOM
	-- 	elseif result==3 then
	-- 		self.error = "DOTA_HUB_CANT_CAST_Un_Connection"
	-- 		return UF_FAIL_CUSTOM
	-- 	end
	-- end

	return UF_SUCCESS
end
function chaotic_meteor_swarm:GetCustomCastErrorLocation( vLoc )
	return self.error
end

function chaotic_meteor_swarm:CreateCustomIndicator()
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/indicator/effect_immortal1.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleShouldCheckFoW(self.effect_cast,false)
		
	local radius = self:GetSpecialValueFor("radius")
	ParticleManager:SetParticleControl( self.effect_cast, 10, Vector(radius,radius,0))


end


function chaotic_meteor_swarm:UpdateCustomIndicator( loc )

	ParticleManager:SetParticleControl( self.effect_cast, 0,loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1,loc)
end
function chaotic_meteor_swarm:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end




function chaotic_meteor_swarm:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	if self:GetRuneType()==2 then
		radius = radius * (1+self:GetSpecialValueFor("rune_2_radius")*0.01)
	end
	return radius
end

-- 
function chaotic_meteor_swarm:GetBehavior()
	if self:GetCaster():HasModifier("modifier_chaotic_meteor_swarm_buff") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE  + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT
	end
	return self.BaseClass.GetBehavior(self)
end






function chaotic_meteor_swarm:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_chaotic_meteor_swarm_buff") then
		return 0
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end


function chaotic_meteor_swarm:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_chaotic_meteor_swarm_buff") then
		return 0.2
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function chaotic_meteor_swarm:Spawn()
	self.dataRecordList = {}
end

function chaotic_meteor_swarm:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	if not IsValid(self.modifier) then
		local cooldown_record = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self.modifier = caster:AddNewModifier(caster, self, "modifier_chaotic_meteor_swarm_buff", {duration =self:GetSpecialValueFor("time_require"),cooldown_record=cooldown_record})
	end

	if IsValid(self.modifier) then
		
		self.modifier:InitPos(pos)

		local count = self.modifier:GetStackCount()
		if count<=0 then
			self.modifier:SafeDestroy()
		end

	end




end





modifier_chaotic_meteor_swarm_buff = advanced_modifier({})

function modifier_chaotic_meteor_swarm_buff:IsHidden() return false end
function modifier_chaotic_meteor_swarm_buff:IsPurgable() return false end
function modifier_chaotic_meteor_swarm_buff:IsDebuff() return false end
function modifier_chaotic_meteor_swarm_buff:OnCreated(keys)
	-- self.sunbeam_bonus_day_vison = self:GetAbility():GetSpecialValueFor("sunbeam_bonus_day_vison")
	if IsServer() then
		local count = self:GetAbility():GetSpecialValueFor("count")
		if self:GetAbility():GetRuneType()==3 then
			count = count + self:GetAbility():GetSpecialValueFor("rune_3_count")
		end
		self:SetStackCount(count)
		self.posRecord = {}
		self.cooldown_record = keys.cooldown_record
	end
end
function modifier_chaotic_meteor_swarm_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end

		self:InitEffect()
		local stack =self:GetStackCount()
		if stack>=1 then
			local ability = self:GetAbility()
			local cooldown_reduction = math.min(ability:GetSpecialValueFor("cooldown_reduction")*stack,ability:GetSpecialValueFor("cooldown_reduction_max"))*0.01
			self.cooldown_record = self.cooldown_record *(1-cooldown_reduction)
		end
		ability:StartCooldown(self.cooldown_record)

		-- ParticleManager:DestroyParticle(self.effect_cast1,false)
	end
end
function modifier_chaotic_meteor_swarm_buff:InitPos(location)
	local data = {
		
		pos = location
	}
	if self:GetStackCount()>1 then
		local particle_cast = "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/indicator/effect_immortal1.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,nil )
		ParticleManager:SetParticleShouldCheckFoW(effect_cast,false)
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		ParticleManager:SetParticleControl( effect_cast, 0, location)
		ParticleManager:SetParticleControl( effect_cast, 1, location)
		ParticleManager:SetParticleControl( effect_cast, 10, Vector(radius,radius,0))
	
		data.particleID = effect_cast
	end



	
	-- data.pos.z = self.firstZ
	table.insert(self.posRecord,data)
	self:DecrementStackCount()
end

function modifier_chaotic_meteor_swarm_buff:InitEffect()
	for _, data in ipairs(self.posRecord) do
		if data.particleID then
			ParticleManager:DestroyParticle(data.particleID,false)
		end
		
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local duration = ability:GetSpecialValueFor("delay")
	-- caster:EmitSound("Hero_FacelessVoid.Chronosphere.MaceOfAeons")
	local radius =  ability:GetSpecialValueFor("radius")
	local gain= ability:GetEffectGain()
	
	for _, data in ipairs(self.posRecord) do
		local pos = data.pos
		CreateModifierThinker(caster, ability, "modifier_chaotic_meteor_swarm_thinker", {duration = duration,radius= radius,gain=gain}, pos, caster:GetTeamNumber(), false)
	end
end











modifier_chaotic_meteor_swarm_thinker = advanced_modifier({})

function modifier_chaotic_meteor_swarm_thinker:OnCreated(keys)
	if IsServer() then
		self.radius = keys.radius
		self.gain = keys.gain
		self:StartIntervalThink(math.max(self:GetRemainingTime()-1.3,0.1))
	end
end
function modifier_chaotic_meteor_swarm_thinker:OnIntervalThink()
	self:StartIntervalThink(-1)
	local dir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	local pfx_name = "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/effect_main/fly.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos+dir*900+Vector(0,0,1000))
	ParticleManager:SetParticleControl(pfx, 1, pos)
	ParticleManager:SetParticleControlForward(pfx, 1, -dir)
	ParticleManager:SetParticleControl(pfx, 61, Vector(0,1,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	parent:EmitSound("Hero_Invoker.ChaosMeteor.Cast")

end



function modifier_chaotic_meteor_swarm_thinker:OnDestroy(  )

    if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end
		parent:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
		local pfx_name = "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/hit_effect/effect.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0,parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 3,parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, ability:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		local burn_duration = ability:GetSpecialValueFor("burn_duration")* caster:GetModifierStatusNegativeGainIndex(1)
		for _, unit in ipairs(enemies) do
			unit:AddNewModifier(caster, ability, "modifier_chaotic_meteor_swarm_debuff_damage", {duration =0.03,gain=self.gain})
			--unit:AddNewModifier(caster, ability, "modifier_chaotic_meteor_swarm_debuff_burn", {duration =burn_duration,gain=self.gain})
		end
		ScreenShake( self:GetParent():GetOrigin(), 100.0, 100.0, 0.5, 10000.0, 0, true )
		CameraShake(1,30)
		UTIL_Remove(self:GetParent())
	end
end

modifier_chaotic_meteor_swarm_debuff_damage = advanced_modifier({})


function modifier_chaotic_meteor_swarm_debuff_damage:IsHidden() 			return true end
function modifier_chaotic_meteor_swarm_debuff_damage:IsPurgable() 			return false end
function modifier_chaotic_meteor_swarm_debuff_damage:IsPurgeException() 	return false end
function modifier_chaotic_meteor_swarm_debuff_damage:OnCreated(keys)
	if IsServer() then
		self.gain = keys.gain
		self.damage_index = 1
	end
end

function modifier_chaotic_meteor_swarm_debuff_damage:OnRefresh(keys)
	if IsServer() then
		if self:GetAbility():GetRuneType()==1 then
			self.damage_index = self.damage_index + self:GetAbility():GetSpecialValueFor("rune_1_damage_stack")*0.01
		end
	end
end


function modifier_chaotic_meteor_swarm_debuff_damage:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end
		if parent:IsAlive() then
			local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*caster:HDGetPrimaryStatValue()
			if self:GetAbility():GetRuneType()==2 then
				damage = damage*(1+ability:GetSpecialValueFor("rune_2_damage")*0.01)
			end
			if self:GetAbility():GetRuneType()==3 then
				damage = damage*(1+ability:GetSpecialValueFor("rune_3_damage")*0.01)
			end

			local damageTable = {
				victim = self:GetParent(),
				attacker = caster,
				damage = damage*self.damage_index*self.gain,
				damage_type = ability:GetAbilityDamageType(),
				ability = ability, --Optional.
				hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
			}
			ApplyDamage(damageTable)
		end

	end
end


modifier_chaotic_meteor_swarm_debuff_burn = advanced_modifier({})


function modifier_chaotic_meteor_swarm_debuff_burn:IsHidden() 			return true end
function modifier_chaotic_meteor_swarm_debuff_burn:IsPurgable() 			return false end
function modifier_chaotic_meteor_swarm_debuff_burn:IsPurgeException() 	return false end
function modifier_chaotic_meteor_swarm_debuff_burn:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/burn_efect/effect.vpcf" end
function modifier_chaotic_meteor_swarm_debuff_burn:OnCreated(keys)
	if IsServer() then
		self.gain = keys.gain
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		self.damageTable = {
			victim = self:GetParent(),
			attacker = caster,
			-- damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_meteor_swarm_debuff_burn:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local damage = ability:GetSpecialValueFor( "burn_base_damage" ) + ability:GetSpecialValueFor( "burn_bonus_damage" )*caster:HDGetPrimaryStatValue()
	self.damageTable.damage = damage*self.gain
	ApplyDamage(self.damageTable)

end


