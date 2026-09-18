-- 重写完成
item_hd_time_clock_effects = class({})
LinkLuaModifier("modifier_item_hd_time_clock_effects", "player_artifact/item_hd_time_clock_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_time_clock_effects_mp", "player_artifact/item_hd_time_clock_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_time_clock_effects_lv30", "player_artifact/item_hd_time_clock_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_time_clock_effects_lv40", "player_artifact/item_hd_time_clock_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_time_clock_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_time_clock_effects"
end
function item_hd_time_clock_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/claszureme_hourglass/effect.vpcf", context )
end

modifier_item_hd_time_clock_effects = advanced_modifier({})

function modifier_item_hd_time_clock_effects:IsDebuff() return false end
function modifier_item_hd_time_clock_effects:IsHidden() return true end
function modifier_item_hd_time_clock_effects:IsPurgable() return false end
function modifier_item_hd_time_clock_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    local caster = self:GetCaster()
    self.cooldown_reduction = self.ability:GetArtifactSpecialValueFor("cooldown_reduction")
    self.mpsteal = self.ability:GetArtifactSpecialValueFor("mpsteal")*0.01
    self.line = self.ability:GetArtifactSpecialValueFor("line") 
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing") 
    self.line_1 = self.ability:GetArtifactSpecialValueFor("line_1") 
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2") 
    self.incoming_max_2 = self.ability:GetArtifactSpecialValueFor("incoming_max_2") 
    self.mpneed_2 = self.ability:GetArtifactSpecialValueFor("mpneed_2") 
    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2") 
    self.chance_max_2 = self.ability:GetArtifactSpecialValueFor("chance_max_2") 
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3") 
    self.duration_buff_3 = self.ability:GetArtifactSpecialValueFor("duration_buff_3") 
    self.cd_3 = self.ability:GetArtifactSpecialValueFor("cd_3") 
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")  

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_time_clock_effects")
    
    if self.level >= 10 then
       self.line = self.line_1
    end
    if self.level >= 40 then
        caster:GameTimer(0.03,function ()
        caster:AddNewModifier(caster,self.ability,"modifier_item_hd_time_clock_effects_lv40",{})
       end) 
    end
    if self.level >= 70 then
        self.outgoing = self.outgoing_7
    end
end

function modifier_item_hd_time_clock_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    local caster = self:GetCaster()
    self.cooldown_reduction = self.ability:GetArtifactSpecialValueFor("cooldown_reduction")
    self.mpsteal = self.ability:GetArtifactSpecialValueFor("mpsteal")*0.01
    self.line = self.ability:GetArtifactSpecialValueFor("line") 
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing") 
    self.line_1 = self.ability:GetArtifactSpecialValueFor("line_1") 
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2") 
    self.incoming_max_2 = self.ability:GetArtifactSpecialValueFor("incoming_max_2") 
    self.mpneed_2 = self.ability:GetArtifactSpecialValueFor("mpneed_2") 
    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2") 
    self.chance_max_2 = self.ability:GetArtifactSpecialValueFor("chance_max_2") 
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3") 
    self.duration_buff_3 = self.ability:GetArtifactSpecialValueFor("duration_buff_3") 
    self.cd_3 = self.ability:GetArtifactSpecialValueFor("cd_3") 
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7") 

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_time_clock_effects")
    
    if self.level >= 10 then
       self.line = self.line_1
    end
    if self.level >= 40 then
        caster:GameTimer(0.03,function ()
        caster:AddNewModifier(caster,self.ability,"modifier_item_hd_time_clock_effects_lv40",{})
       end) 
    end
    if self.level >= 70 then
        self.outgoing = self.outgoing_7
    end
end
    
function modifier_item_hd_time_clock_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        
    }
    if self.level >= 20 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
    end 
    return funcs
end

function modifier_item_hd_time_clock_effects:Advanced_GetModifierCooldownReduction()
    return self.cooldown_reduction
end

function modifier_item_hd_time_clock_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
    if caster:GetManaPercent() > self.line or caster:HasModifier("modifier_item_hd_time_clock_effects_lv30") then
        return self.outgoing
    end
    return 0
end

function modifier_item_hd_time_clock_effects:OnTakeDamage(keys)
    if not IsServer() then return end
    local attacker = self:GetCaster()
    if attacker ~= keys.attacker then return end
    if not attacker:IsAlive() then return end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
    --延迟回蓝
    local mp = keys.damage*self.mpsteal
    local mp_modifier = attacker:FindModifierByName("modifier_item_hd_time_clock_effects_mp")
    if mp_modifier then
        mp_modifier:SetStackCount(mp_modifier:GetStackCount() + mp)
    else
        attacker:AddNewModifier(attacker,self.ability,"modifier_item_hd_time_clock_effects_mp",{stack = mp, level = self.level})
    end
end

function modifier_item_hd_time_clock_effects:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    if GetChaoticEraClass(caster) ~= 1 then return end
    local final_incoming = 0
    local skill_in_cd = 0
    for i=0, caster:GetAbilityCount() - 1 do
		local Ability = caster:GetAbilityByIndex(i)
		if Ability ~= nil and not Ability:IsCooldownReady() then
            skill_in_cd = skill_in_cd + 1
		end
	end
    final_incoming = math.min(self.incoming_2*skill_in_cd, self.incoming_max_2)

    local chance = math.min(math.floor(caster:GetMana()/100)*self.chance_2, self.chance_max_2)
    local random = math.random
    if chance >= random(1,100) then
       final_incoming = 100 
    end
    print(final_incoming)
    return -final_incoming
end
-----
modifier_item_hd_time_clock_effects_mp = advanced_modifier({})

function modifier_item_hd_time_clock_effects_mp:IsDebuff() return false end
function modifier_item_hd_time_clock_effects_mp:IsHidden() return false end
function modifier_item_hd_time_clock_effects_mp:IsPurgable() return false end
function modifier_item_hd_time_clock_effects_mp:GetTexture() return "item_artifact_32" end
function modifier_item_hd_time_clock_effects_mp:OnCreated(keys)
    self.ability =self:GetAbility()
    self.mp_regen_bonus_1 = self.ability:GetArtifactSpecialValueFor("mp_regen_bonus_1") 
	if IsServer() then
        self.level = keys.level
        self.delay = self.ability:GetArtifactSpecialValueFor("delay")
        self.delay_7 = self.ability:GetArtifactSpecialValueFor("delay_7")
		self:SetStackCount(keys.stack)
        if self.level >= 70 then
           self.delay = self.delay_7 
        end
		self:StartIntervalThink(self.delay)
        self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end

function modifier_item_hd_time_clock_effects_mp:OnRefresh(keys)
	if IsServer() then
        self.level = keys.level
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_item_hd_time_clock_effects_mp:OnIntervalThink()
	local parent = self:GetParent()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

    parent:GiveMana(self:GetStackCount())
    parent:EmitSoundParams("Hero_Antimage.ManaVoidCast", 0, 0.1, 0)
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControl(self.particle, 0, parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)
	self:SetStackCount(0)
	self:SafeDestroy()
end

function modifier_item_hd_time_clock_effects_mp:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
    }
    return funcs
end

function modifier_item_hd_time_clock_effects_mp:AdvancedGetModifierConstantManaRegenAmpPercentage()
    if self.level >= 10 then
       return self.mp_regen_bonus_1 
    end
    return
end

function modifier_item_hd_time_clock_effects_mp:AddCustomTransmitterData( )
	return
	{
        level = self.level,
	}
end

function modifier_item_hd_time_clock_effects_mp:HandleCustomTransmitterData( data )
    self.level = data.level
end
-----
modifier_item_hd_time_clock_effects_lv30 = advanced_modifier({})

function modifier_item_hd_time_clock_effects_lv30:IsDebuff() return false end
function modifier_item_hd_time_clock_effects_lv30:IsHidden() return false end
function modifier_item_hd_time_clock_effects_lv30:IsPurgable() return false end
function modifier_item_hd_time_clock_effects_lv30:GetTexture() return "item_artifact_32" end
function modifier_item_hd_time_clock_effects_lv30:OnCreated(keys)
    self.ability = self:GetAbility()
    self.duration_buff_3 = self.ability:GetArtifactSpecialValueFor("duration_buff_3")
    if not self:GetAbility() then return end
    
    if IsServer() then
        self:StartIntervalThink(0.75)
        self:OnIntervalThink()
    end
end

function modifier_item_hd_time_clock_effects_lv30:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    if self:GetRemainingTime() <= self.duration_buff_3 then return end
    local caster = self:GetCaster()
    local particle = ParticleManager:CreateParticle("particles/rebuild/spell/claszureme_hourglass/effect.vpcf", PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
    caster:Purge(false, true, false, true, true) --可移除眩晕的强驱散
end

function modifier_item_hd_time_clock_effects_lv30:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_item_hd_time_clock_effects_lv30:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destory() return end
    if self:GetRemainingTime() <= self.duration_buff_3 then return end
    return -100
end
-----

modifier_item_hd_time_clock_effects_lv40 = advanced_modifier({})

function modifier_item_hd_time_clock_effects_lv40:IsDebuff() return false end
function modifier_item_hd_time_clock_effects_lv40:IsHidden() return true end
function modifier_item_hd_time_clock_effects_lv40:IsPurgable() return false end
function modifier_item_hd_time_clock_effects_lv40:RemoveOnDeath() return false end
function modifier_item_hd_time_clock_effects_lv40:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.atb_mana_4 = self.ability:GetArtifactSpecialValueFor("atb_mana_4") 
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4") 
    self.bonus_4 = self.ability:GetArtifactSpecialValueFor("bonus_4") *0.01
    self.mana = 0
    self.count = 0
    self.point_check = 0
    if IsServer() then
        self:StartIntervalThink(1)
    end
end
function modifier_item_hd_time_clock_effects_lv40:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    self.count = self.count + 1
    if self.count >= self.interval_4 then
        self.count = 0
        self.point_check = self.point_check + 1
    end
    self.mana = (self.parent:HDGetPrimaryStatValue()*self.atb_mana_4 - self.parent:GetIntellect(false)*8) *(1 + self.point_check*self.bonus_4)
    print(self.mana)
end
function modifier_item_hd_time_clock_effects_lv40:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end
function modifier_item_hd_time_clock_effects_lv40:AdvancedGetModifierManaBonus()
    if not self:GetAbility() then self:Destroy() return end
	return self.mana
end