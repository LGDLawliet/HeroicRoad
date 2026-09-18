--重做完成
chinese_event_guoqing_2025 = class({})
function chinese_event_guoqing_2025:GetIntrinsicModifierName()
	return "modifier_chinese_event_guoqing_2025"
end
function chinese_event_guoqing_2025:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/circle_ground_effects/circle_blue_2025.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/circle_ground_effects/circle_red_2025.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/circle_ground_effects/circle_green_2025.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/circle_ground_effects/circle_gold_2025.vpcf", context )
end
----
modifier_chinese_event_guoqing_2025 = advanced_modifier({})

function modifier_chinese_event_guoqing_2025:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025:IsHidden() return true end
function modifier_chinese_event_guoqing_2025:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025:GetTexture() return "consumables/seasonal_10th_anniversary_party_hat" end
function modifier_chinese_event_guoqing_2025:RemoveOnDeath() return false end
function modifier_chinese_event_guoqing_2025:DestroyOnExpire() return false end

function modifier_chinese_event_guoqing_2025:OnCreated()    
    self.interval = 25
    self.duration = 15
    self.create_radius = 800
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_chinese_event_guoqing_2025:OnIntervalThink()
    if Game_State:IsInBattle() then
        local random = math.random
        local base_chance = 50
        local chance_after_playerscount = base_chance - #GetAllRealHeroes()*5
        if chance_after_playerscount >= random(1,100) then
            self:CreateBuffAura()
        end
    end
end

function modifier_chinese_event_guoqing_2025:CreateBuffAura()
    if not IsServer() then return end
    local parent = self:GetParent()
    local radius = self.create_radius
    local duration = self.duration
    local vec = parent:GetOrigin() + Vector(RandomInt(-radius, radius),RandomInt(-radius, radius))
	local pos = GetClearSpaceForUnit(parent, vec)
    local buff_type = "modifier_chinese_event_guoqing_2025_"..RandomInt(1, 3)

    local random = math.random
    if 10 >= random(1,100) then
       buff_type = "modifier_chinese_event_guoqing_2025_gold"
    end
	parent:AddNewModifier(parent, nil, buff_type, {duration = duration , pos = pos})
end


---------------------------------------------
modifier_chinese_event_guoqing_2025_1 = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_1:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_1:IsHidden() return true end
function modifier_chinese_event_guoqing_2025_1:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_1:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_1:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chinese_event_guoqing_2025_1:OnCreated(keys)
    self.radius = 400
	if IsServer() then
		self.pos = StringToVector(keys.pos)
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/circle_ground_effects/circle_red_2025.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleShouldCheckFoW( self.effect_cast,false )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(self.radius, 0, 0 ) )
		self:StartIntervalThink(0.5)
	end
end

function modifier_chinese_event_guoqing_2025_1:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end
function modifier_chinese_event_guoqing_2025_1:OnIntervalThink()
    local caster = self:GetCaster()
    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #heroes >= 1 then
	    for i, hero in pairs(heroes) do
            local buff = hero:FindModifierByName("modifier_chinese_event_guoqing_2025_1_buff")
            if buff then
                buff:ForceRefresh()
                buff:SetDuration(1, true)
            else
                hero:AddNewModifier(caster, nil, "modifier_chinese_event_guoqing_2025_1_buff", {duration = 1})
            end
        end
    end
end

modifier_chinese_event_guoqing_2025_1_buff = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_1_buff:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_1_buff:IsHidden() return false end
function modifier_chinese_event_guoqing_2025_1_buff:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_1_buff:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_1_buff:GetTexture() return "ember_spirit_sleight_of_fist" end
function modifier_chinese_event_guoqing_2025_1_buff:OnCreated() 
    self.attack = 20
    self.spell = 30
    self.summon = 30
    self.outgoing = 40
end

function modifier_chinese_event_guoqing_2025_1_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_Summon_Intensity
    }
end
function modifier_chinese_event_guoqing_2025_1_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.outgoing
end
function modifier_chinese_event_guoqing_2025_1_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return self.attack
end
function modifier_chinese_event_guoqing_2025_1_buff:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell
end
function modifier_chinese_event_guoqing_2025_1_buff:Advanced_GetModifier_Summon_Intensity()
    return self.summon
end
----2----
modifier_chinese_event_guoqing_2025_2 = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_2:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_2:IsHidden() return true end
function modifier_chinese_event_guoqing_2025_2:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_2:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chinese_event_guoqing_2025_2:OnCreated(keys)
    self.radius = 400
	if IsServer() then
		self.pos = StringToVector(keys.pos)
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/circle_ground_effects/circle_blue_2025.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleShouldCheckFoW( self.effect_cast,false )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(self.radius, 0, 0 ) )
		self:StartIntervalThink(0.5)
	end
end

function modifier_chinese_event_guoqing_2025_2:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end

function modifier_chinese_event_guoqing_2025_2:OnIntervalThink()
    local caster = self:GetCaster()
    local cds_normal = 1.5
    local cds_unrefresh = 0.5
    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #heroes >= 1 then
	    for i, hero in pairs(heroes) do
            local buff = hero:FindModifierByName("modifier_chinese_event_guoqing_2025_2_buff")
            if buff then
                buff:ForceRefresh()
                buff:SetDuration(1, true)
            else
                hero:AddNewModifier(caster, nil, "modifier_chinese_event_guoqing_2025_2_buff", {duration = 1})
            end

            for i = 0, 11 do
                local Ability = hero:GetAbilityByIndex(i)
                if Ability ~= nil and (not Ability:IsCooldownReady()) then
                    if Ability:IsRefreshable() then
                        local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - cds_normal,0)
                        Ability:EndCooldown()
                        Ability:StartCooldown(new_cooldown)
                    elseif not Ability:IsRefreshable() then
                        local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - cds_unrefresh,0)
                        Ability:EndCooldown()
                        Ability:StartCooldown(new_cooldown)
                    end
                end
            end
        end
    end
end

modifier_chinese_event_guoqing_2025_2_buff = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_2_buff:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_2_buff:IsHidden() return false end
function modifier_chinese_event_guoqing_2025_2_buff:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_2_buff:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_2_buff:GetTexture() return "faceless_void_time_zone" end

----3----
modifier_chinese_event_guoqing_2025_3 = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_3:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_3:IsHidden() return true end
function modifier_chinese_event_guoqing_2025_3:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_3:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chinese_event_guoqing_2025_3:OnCreated(keys)
    self.radius = 400
    self.heal = 0.01
    self.mana_regen = 0.01
	if IsServer() then
		self.pos = StringToVector(keys.pos)
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/circle_ground_effects/circle_green_2025.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleShouldCheckFoW( self.effect_cast,false )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(self.radius, 0, 0 ) )
		self:StartIntervalThink(0.5)
	end
end

function modifier_chinese_event_guoqing_2025_3:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end
function modifier_chinese_event_guoqing_2025_3:OnIntervalThink()
    local caster = self:GetCaster()
    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #heroes >= 1 then
	    for i, hero in pairs(heroes) do
            local buff = hero:FindModifierByName("modifier_chinese_event_guoqing_2025_3_buff")
            if buff then
                buff:ForceRefresh()
                buff:SetDuration(1, true)
            else
                hero:AddNewModifier(caster, nil, "modifier_chinese_event_guoqing_2025_3_buff", {duration = 1})
            end

            if hero:IsAlive() then
                hero:Heal(hero:GetMaxHealth()*self.heal, nil)
                hero:GiveMana(hero:GetMaxMana()*self.mana_regen)
            end
        end
    end
end

modifier_chinese_event_guoqing_2025_3_buff = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_3_buff:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_3_buff:IsHidden() return false end
function modifier_chinese_event_guoqing_2025_3_buff:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_3_buff:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_3_buff:GetTexture() return "greevil_natures_attendants" end
function modifier_chinese_event_guoqing_2025_3_buff:OnCreated() 
    self.incoming = 30
    self.profic = 50
end

function modifier_chinese_event_guoqing_2025_3_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
    }
end
function modifier_chinese_event_guoqing_2025_3_buff:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end
function modifier_chinese_event_guoqing_2025_3_buff:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end

----4----
modifier_chinese_event_guoqing_2025_gold = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_gold:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_gold:IsHidden() return true end
function modifier_chinese_event_guoqing_2025_gold:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_gold:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_gold:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chinese_event_guoqing_2025_gold:OnCreated(keys)
    self.radius = 400
    self.gold = 12
	if IsServer() then
		self.pos = StringToVector(keys.pos)
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/circle_ground_effects/circle_gold_2025.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleShouldCheckFoW( self.effect_cast,false )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(self.radius, 0, 0 ) )
		self:StartIntervalThink(0.5)
	end
end

function modifier_chinese_event_guoqing_2025_gold:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end
function modifier_chinese_event_guoqing_2025_gold:OnIntervalThink()
    local caster = self:GetCaster()
    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #heroes >= 1 then
	    for i, hero in pairs(heroes) do
            if hero then
                local buff = hero:FindModifierByName("modifier_chinese_event_guoqing_2025_gold_buff")
                if buff then
                    buff:ForceRefresh()
                    buff:SetDuration(1, true)
                else
                    hero:AddNewModifier(caster, nil, "modifier_chinese_event_guoqing_2025_gold_buff", {duration = 1})
                end
                hero:ModifyGoldFiltered(self.gold, true, DOTA_ModifyGold_CreepKill)  --金币奖励
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hero, self.gold, nil)
            end
        end
    end
end

modifier_chinese_event_guoqing_2025_gold_buff = advanced_modifier({})

function modifier_chinese_event_guoqing_2025_gold_buff:IsDebuff() return false end
function modifier_chinese_event_guoqing_2025_gold_buff:IsHidden() return false end
function modifier_chinese_event_guoqing_2025_gold_buff:IsPurgable() return false end
function modifier_chinese_event_guoqing_2025_gold_buff:IsPurgeException() return false end
function modifier_chinese_event_guoqing_2025_gold_buff:GetTexture() return "alchemist/midas_knuckles/alchemist_goblins_greed" end
function modifier_chinese_event_guoqing_2025_gold_buff:OnCreated() 
    self.gold = 30
end

function modifier_chinese_event_guoqing_2025_gold_buff:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil}
    }
end
function modifier_chinese_event_guoqing_2025_gold_buff:OnDeath(keys)
    if not IsServer() then return end
    local parent = self:GetParent()
    if (not parent) or (not parent:IsAlive()) then return end
    local unit = keys.unit
    if not unit then return end
    if unit:GetTeamNumber() ~= parent:GetTeamNumber() then
        parent:ModifyGoldFiltered(self.gold, true, DOTA_ModifyGold_CreepKill)  --金币奖励
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, parent, self.gold, nil)
    end
end
