LinkLuaModifier("modifier_chaotic_lucent_beam_buff", "chaotic_spell/class_4/chaotic_lucent_beam", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_lucent_beam_auto", "chaotic_spell/class_4/chaotic_lucent_beam", LUA_MODIFIER_MOTION_NONE)
chaotic_lucent_beam = class({})

function chaotic_lucent_beam:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", context )
	PrecacheResource( "particle", "particles/ability_effects/ability_effects00001/ability_effects00001.vpcf", context )

end
function chaotic_lucent_beam:GetIntrinsicModifierName()
	return "modifier_chaotic_lucent_beam_auto"
end
function chaotic_lucent_beam:OnAbilityPhaseStart()
	self:PlayEffects1()
	return true 
end

function chaotic_lucent_beam:GetCastRange()
	
	local radius = self:GetSpecialValueFor("radius")
	if IsServer() then
		if self:GetCaster():GetUnitName() == "npc_hd_artifact_sci_blue_whale" then
			local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_artifact_58_chaotic_lucent_beam")
			if modifier and modifier.deepactive then
				radius = 50000
			end
		end
	end
	return radius
end

function chaotic_lucent_beam:OnSpellStart()
	local caster = self:GetCaster()
	self.type = self:GetRuneType()
	self.cost_get = self:GetSpecialValueFor("rune_1_tri")
	self.rune_1_chance = self:GetSpecialValueFor("rune_1_chance")
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i,enemy in pairs(enemies) do
	    self:CreateSingleLucent(enemy,1)
        i = i + 1 
        if i > self:GetSpecialValueFor("max") then
            break
        end
    end
end

function chaotic_lucent_beam:CreateSingleLucent(target,index)
    if not IsServer() then return end
    if not target then return end
    
    local index = index or 1
	local caster = self:GetCaster()
	local damage = (self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())*index
    local duration = self:GetSpecialValueFor("duration")
    local stack = self:GetSpecialValueFor("outgoing")
    local talent = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_luna_2")
    if talent then
        local level = talent:GetAbility():GetSpecialValueFor("level") 
        if caster:GetLevel() < level then
            damage = damage * (caster:GetLevel()/level)*0.6
        end
    end

	if self.type == 1 then
		caster:AddNewModifier(caster,self,"modifier_hd_trigger",{cost_get = self.cost_get})
		if self.rune_1_chance >= math.random(1,100) then
			self:EndCooldown()
		end
	end

	target:Freezing(caster, self, damage)
    caster:AddNewModifier(caster, self , "modifier_chaotic_lucent_beam_buff", {duration = duration, stack_time = duration , stack = stack})
	self:PlayEffects2( target )
end

function chaotic_lucent_beam:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(0.4,0,0) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0),
		true
	)

	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function chaotic_lucent_beam:PlayEffects2( target )
	local caster = self:GetCaster()
	local casterID 
	if caster:IsRealHero() then
		casterID = tostring(PlayerResource:GetSteamID(caster:GetPlayerOwnerID()))
	else
		casterID = tostring(PlayerResource:GetSteamID(caster:GetOwner():GetPlayerOwnerID()))
	end

	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	if casterID == "76561198101659620" or casterID == "76561198828335572" then
		particle_cast = "particles/ability_effects/ability_effects00001/ability_effects00001.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
		ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(300,0,0) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	else
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
		ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
		ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt(effect_cast,5,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		ParticleManager:SetParticleControlEnt(effect_cast,6,self:GetCaster(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end



-- 独立叠加--------
modifier_chaotic_lucent_beam_buff = advanced_modifier({})

function modifier_chaotic_lucent_beam_buff:IsDebuff() return false end
function modifier_chaotic_lucent_beam_buff:IsPurgable() return false end

function modifier_chaotic_lucent_beam_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_chaotic_lucent_beam_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_chaotic_lucent_beam_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end

function modifier_chaotic_lucent_beam_buff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_chaotic_lucent_beam_buff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_chaotic_lucent_beam_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return math.min(self:GetStackCount(), self:GetAbility():GetSpecialValueFor("outgoing_max"))
end
function modifier_chaotic_lucent_beam_buff:OnTooltip()
    return self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
end

--------------------------------------
modifier_chaotic_lucent_beam_auto = advanced_modifier({})

function modifier_chaotic_lucent_beam_auto:IsHidden()		return true end
function modifier_chaotic_lucent_beam_auto:IsPurgable()		return false end
function modifier_chaotic_lucent_beam_auto:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.6)
	end
end
function modifier_chaotic_lucent_beam_auto:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability and self:GetParent():IsAlive() then
		if HDCanAutoCast(caster, ability)==true then
			-- ability:OnSpellStart()
			-- ability:UseResources(true,true,true,true)
			self:GetParent():CastAbilityNoTarget(ability, self:GetParent():GetPlayerOwnerID())
		end
	end
end