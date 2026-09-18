LinkLuaModifier("modifier_chaotic_blood_aura", "chaotic_spell/class_7/chaotic_blood_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_blood_aura_thinker", "chaotic_spell/class_7/chaotic_blood_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_blood_aura_buff", "chaotic_spell/class_7/chaotic_blood_aura.lua", LUA_MODIFIER_MOTION_NONE)

chaotic_blood_aura = class({})

function chaotic_blood_aura:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_spell_bloodbath_bubbles.vpcf", context )
end

function chaotic_blood_aura:GetAOERadius()
    local radius = self:GetSpecialValueFor("radius")

    if self:GetRuneType() == 1 then
        radius = radius * (1-self:GetSpecialValueFor("rune_1_radius")*0.01) 
    end
    if self:GetRuneType() == 2 then
        radius = radius * (1+self:GetSpecialValueFor("rune_2_radius")*0.01) 
    end

	return  radius
end

function chaotic_blood_aura:GetBehavior()
    if self:GetRuneType() == 3 then
       return  DOTA_ABILITY_BEHAVIOR_NO_TARGET
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function chaotic_blood_aura:GetHealthCost()
	return 200
end

function chaotic_blood_aura:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local index = 0
    if self:GetRuneType() == 1 then
        radius = radius * (1-self:GetSpecialValueFor("rune_1_radius")*0.01) 
    end
    if self:GetRuneType() == 2 then
        radius = radius * (1+self:GetSpecialValueFor("rune_2_radius")*0.01) 
        index = 1
    end

    local gain = caster:GetModifierDurationGainIndex(index)

    if self:GetRuneType() == 3 then
        local heroes = GetAllRealHeroes()
        for _,hero in pairs(heroes) do
            hero:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_blood_aura_buff", {duration = duration*self:GetSpecialValueFor("rune_3_duration")*0.01})
        end
        return
    end

	local thinker =CreateModifierThinker(
		caster,
		self,
		"modifier_chaotic_blood_aura_thinker",
		{
			duration = duration*gain,
			radius = radius,
		},
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)
end

---------------------------------------------------------------------------
modifier_chaotic_blood_aura_thinker = advanced_modifier({})


function modifier_chaotic_blood_aura_thinker:IsHidden()return false end

function modifier_chaotic_blood_aura_thinker:OnCreated(keys)
    if IsServer() then
        self.radius = keys.radius
        
        -- 播放施法特效
        self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_spell_bloodbath_bubbles.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius,self.radius,self.radius))
        -- 播放施法音效
        EmitSoundOn("Hero_Bloodseeker.BloodBath", self:GetCaster())

        self:StartIntervalThink(1)
    end
end

function modifier_chaotic_blood_aura_thinker:OnIntervalThink()
	if not IsServer() then
        return
    end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end

    local targetteam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    if ability:GetRuneType() == 1 then
        targetteam = DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY
    end


	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		self.radius,	
		targetteam,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		 DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	
		FIND_ANY_ORDER,	
		false	
	)

    
	for _,unit in pairs(units) do

        local modifier = unit:FindModifierByName("modifier_chaotic_blood_aura_buff")
		if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(1.1,true)
		else
			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaotic_blood_aura_buff", {duration = 1.1})
		end
	end
end

function modifier_chaotic_blood_aura_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	UTIL_Remove( self:GetParent() )

end

------------------------------------------------------
modifier_chaotic_blood_aura_buff = advanced_modifier({})

function modifier_chaotic_blood_aura_buff:IsHidden() 	return false end
function modifier_chaotic_blood_aura_buff:IsDebuff() 		return false end
function modifier_chaotic_blood_aura_buff:IsPurgable() 			return false end

function modifier_chaotic_blood_aura_buff:OnCreated()
    self.atb = self:GetAbility():GetSpecialValueFor("atb")
    self.atb_caster = self:GetAbility():GetSpecialValueFor("atb_caster")
    self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
    self.hp_cost = self:GetAbility():GetSpecialValueFor("hp_cost")*0.01
    if IsServer() then 
        self:StartIntervalThink(1)
    end
end 

function modifier_chaotic_blood_aura_buff:OnIntervalThink()
    if not self:GetAbility() then 
        self:Destroy() 
        return 
    end

    local hp_cost = self:GetParent():GetHealth()*self.hp_cost
    if self:GetAbility() and self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
        hp_cost = self:GetParent():GetHealth()*self:GetAbility():GetSpecialValueFor("rune_1_hp_cost")*0.01
    end
    self:GetParent():ModifyHealth(self:GetParent():GetHealth()-hp_cost, self:GetAbility(), false, 0)
end

function modifier_chaotic_blood_aura_buff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_chaotic_blood_aura_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then 
        self:Destroy() 
        return 
    end
    if self:GetParent() == self:GetCaster() then
        return 0
    end
    return self.outgoing
end
function modifier_chaotic_blood_aura_buff:Advanced_GetModifierBonusStats_Strength()
    if not self:GetAbility() then 
        self:Destroy() 
        return 
    end
    if self:GetParent() == self:GetCaster() then
        return self.atb_caster
    end
    return self.atb
end
function modifier_chaotic_blood_aura_buff:Advanced_GetModifierBonusStats_Agility()
    if not self:GetAbility() then 
        self:Destroy() 
        return 
    end
    if self:GetParent() == self:GetCaster() then
        return self.atb_caster
    end
    return self.atb
end 
function modifier_chaotic_blood_aura_buff:Advanced_GetModifierBonusStats_Intellect()
    if not self:GetAbility() then 
        self:Destroy() 
        return 
    end
    if self:GetParent() == self:GetCaster() then
        return self.atb_caster
    end
    return self.atb
end