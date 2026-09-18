chaotic_time_cleave = class({})
LinkLuaModifier("modifier_chaotic_time_cleave_passive", "chaotic_spell/class_9/chaotic_time_cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_time_cleave_damage", "chaotic_spell/class_9/chaotic_time_cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_time_cleave_debuff", "chaotic_spell/class_9/chaotic_time_cleave", LUA_MODIFIER_MOTION_NONE)

function chaotic_time_cleave:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/spell/chaotic_time_cleave/main_effect/effect_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cleave/eff_debuffhunters_mark_crosshair.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cleave/eff_damage_pos.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_time_cleave/slash_effect/effect_top.vpcf", context )


	
end


function chaotic_time_cleave:GetIntrinsicModifierName()
	return "modifier_chaotic_time_cleave_passive"
end

function chaotic_time_cleave:OnSpellStart()

    local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage_radius = 100
	local radius_record = 0
	local pos = caster:GetOrigin()
	local armor_reduction_duration = self:GetSpecialValueFor("armor_reduction_duration")
	local duration = self:GetSpecialValueFor("duration")
	local units = {}
	local gain = self:GetEffectGain()
	local type = self:GetRuneType() or 0

	caster:GameTimer(0.03,function()
		if IsValid(self) then
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),
				pos,
				nil,
				damage_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
				DOTA_UNIT_TARGET_FLAG_NONE,	
				FIND_ANY_ORDER,
				false
			)
		
			for _, target in ipairs(enemies) do
				if (target:GetOrigin() - pos):Length2D() > radius_record + 10 then
					if not units[target] then
						units[target] = true
						target:AddNewModifier(caster, self, "modifier_chaotic_time_cleave_damage", {duration = duration,gain=gain})
						if type ~= 2 then
							target:AddNewModifier(caster, self, "modifier_chaotic_time_cleave_debuff", {duration = armor_reduction_duration})
						end
					end
					
				end
			end
	
			if damage_radius <= radius then
				radius_record = damage_radius
				damage_radius = damage_radius + 100
				return 0.03
			end
		end
	end)

	local modifier = caster:FindModifierByName("modifier_chaotic_time_cleave_passive")

	if modifier then
		if self:GetRuneType()==1 then
			modifier:SetStackCount(math.floor(modifier:GetStackCount()-self:GetSpecialValueFor("stack_require")))
		else
			modifier:SetStackCount(0)
		end
		
	end
	self:SetActivated(false)
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_time_cleave/main_effect/effect_crit.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin())
	DestroyParticleByDelay(effect_cast,3)

	caster:EmitSound("chaotic_six_light_continuous_slash_cast")


	local rune_2_duration = self:GetSpecialValueFor("rune_2_duration")
	if self:GetRuneType()==2 then
		for index, data in ipairs(chaotic_era_spawner.spawnList) do
			-- print("data.delOnSpawn=",data.delOnSpawn)
			-- print("data.nextTime=",data.nextTime)
			if data.delOnSpawn~=true and  data.nextTime then
				-- print("test")
				data.nextTime = data.nextTime - rune_2_duration
			end
		end
	end


end

function chaotic_time_cleave:PlayEffect(target)
	local target_pos = target:GetOrigin() + Vector(0,0,128)
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_time_cleave/slash_effect/effect_top.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, target_pos)

	local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
	local pos_1 = target_pos + vDir * 300
	local pos_2 = target_pos - vDir *300 + Vector(0,0,RandomInt(-20, 180))
	ParticleManager:SetParticleControl( effect_cast, 2, pos_1)
	ParticleManager:SetParticleControl( effect_cast, 3, pos_2)

	DestroyParticleByDelay(effect_cast,3)
end








modifier_chaotic_time_cleave_passive = advanced_modifier({})

function modifier_chaotic_time_cleave_passive:IsHidden() 	return false end
function modifier_chaotic_time_cleave_passive:IsPurgable() 		    return false end
function modifier_chaotic_time_cleave_passive:IsPurgeException() return false end

function modifier_chaotic_time_cleave_passive:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.stack_require = math.floor(self.ability:GetSpecialValueFor("stack_require"))
	if IsServer() then
		-- self.stack_require = math.floor(self.ability:GetSpecialValueFor("stack_require"))
		self:GetAbility():SetActivated(false)
	end
end

function modifier_chaotic_time_cleave_passive:OnRefresh()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.stack_require = math.floor(self.ability:GetSpecialValueFor("stack_require"))
end


function modifier_chaotic_time_cleave_passive:ADDeclareFunctions()
	local funcs =  {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		
    }
    return funcs
   
end

function modifier_chaotic_time_cleave_passive:OnAttackLanded( params )
	if IsServer() then
        if params.attacker==self.parent and params.target ~= self.parnet then
            if self:GetAbility():GetRuneType()==1 then
				self:SetStackCount(self:GetStackCount()+1)
			else
				self:SetStackCount(math.min(self.stack_require,self:GetStackCount()+1))
			end
            if self:GetStackCount()>=self.stack_require then
                self:GetAbility():SetActivated(true)
            end
        end
    end
end

function modifier_chaotic_time_cleave_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_chaotic_time_cleave_passive:OnTooltip()
	return math.max(self.stack_require - self:GetStackCount(), 0)
end


modifier_chaotic_time_cleave_damage = advanced_modifier({})

function modifier_chaotic_time_cleave_damage:IsHidden() 	return true end
function modifier_chaotic_time_cleave_damage:IsPurgable() 		    return false end
function modifier_chaotic_time_cleave_damage:IsPurgeException() return false end
function modifier_chaotic_time_cleave_damage:IsDebuff() return true end
function modifier_chaotic_time_cleave_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_time_cleave_damage:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.duration = self.ability:GetSpecialValueFor("duration")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		self.gain = keys.gain
		self.ability:PlayEffect(self.parent)
	end
end

function modifier_chaotic_time_cleave_damage:OnDestroy()

	if not IsServer() then
		return
	end
	if not self:GetAbility() then
		return
	end
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_cleave/eff_damage_pos.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin())
	DestroyParticleByDelay(effect_cast,1)
	self.parent:EmitSound("Hero_Pudge.Dismember")
	local damage = self.caster:GetAverageTrueAttackDamage(nil) * self.bonus_damage * self.gain
	local damageTable = {
		victim = self.parent,
		attacker = self.caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE , 
		ability = self.ability,
		hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE
	}

	local arti_douqi = self:GetCaster():FindAbilityByName("item_hd_douqi_effects")
	local arti_douqi_level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_douqi_effects")
	if arti_douqi and arti_douqi_level then
		if arti_douqi_level >= 40 then
			damageTable.hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		end
	end
	
	ApplyDamage(damageTable)

	self.parent:EmitSound("Hero_Juggernaut.OmniSlash")
end

function modifier_chaotic_time_cleave_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_chaotic_time_cleave_damage:OnTooltip()
	return self.duration
end

function modifier_chaotic_time_cleave_damage:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		-- [MODIFIER_STATE_DISARMED] = true,
	}
	if self:GetAbility():GetRuneType() == 2 then
		state = {}
	end
	return state
end

modifier_chaotic_time_cleave_debuff = advanced_modifier({})

function modifier_chaotic_time_cleave_debuff:IsHidden() 	return false end
function modifier_chaotic_time_cleave_debuff:IsPurgable() 		    return false end
function modifier_chaotic_time_cleave_debuff:IsPurgeException() return false end
function modifier_chaotic_time_cleave_debuff:IsDebuff() return true end
function modifier_chaotic_time_cleave_debuff:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_cleave/eff_debuffhunters_mark_crosshair.vpcf" end
function modifier_chaotic_time_cleave_debuff:OnCreated()
	self.ability = self:GetAbility()
	self.armor_reduction = self.ability:GetSpecialValueFor("armor_reduction")
	if self.ability:GetRuneType() == 2 then
		self:Destroy()
	end
end

function modifier_chaotic_time_cleave_debuff:OnRefresh()
	self.ability = self:GetAbility()
	self.armor_reduction = self.ability:GetSpecialValueFor("armor_reduction")
	if self.ability:GetRuneType() == 2 then
		self:Destroy()
	end
end

function modifier_chaotic_time_cleave_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_chaotic_time_cleave_debuff:Advanced_GetModifierPhysicalArmorBonus()
	if self.ability:GetRuneType() == 2 then
		self:Destroy()
	end
	return -self.armor_reduction
end

function modifier_chaotic_time_cleave_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_time_cleave_debuff:OnTooltip()
	return self:Advanced_GetModifierPhysicalArmorBonus()
end