-- 重写完成
item_hd_autumn_staff = class({})
LinkLuaModifier("modifier_item_hd_autumn_staff", "player_artifact/item_hd_autumn_staff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_autumn_staff_buff", "player_artifact/item_hd_autumn_staff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_autumn_staff_cd", "player_artifact/item_hd_autumn_staff.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_autumn_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_autumn_staff"
end
function item_hd_autumn_staff:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/autumn_staff/effect.vpcf", context )
end

modifier_item_hd_autumn_staff = advanced_modifier({})

function modifier_item_hd_autumn_staff:IsDebuff() return false end
function modifier_item_hd_autumn_staff:IsHidden() return true end
function modifier_item_hd_autumn_staff:IsPurgable() return false end
function modifier_item_hd_autumn_staff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.cooldown_reduction = self.ability:GetArtifactSpecialValueFor("cooldown_reduction")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration") 
    self.cd = self.ability:GetArtifactSpecialValueFor("cd") 
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4") 
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4") 

    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7") 
    self.cd_7 = self.ability:GetArtifactSpecialValueFor("cd_7") 

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_autumn_staff")
    
    if self.level >= 40 then
       self.cd = self.cd_4
    end
    if self.level >= 70 then
       self.cd = self.cd_7
       self.duration = self.duration_7
    end
end

function modifier_item_hd_autumn_staff:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.cooldown_reduction = self.ability:GetArtifactSpecialValueFor("cooldown_reduction")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration") 
    self.cd = self.ability:GetArtifactSpecialValueFor("cd") 
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4") 
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4") 

    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7") 
    self.cd_7 = self.ability:GetArtifactSpecialValueFor("cd_7") 
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_autumn_staff")
    
    if self.level >= 40 then
       self.cd = self.cd_4
    end
    if self.level >= 70 then
        self.cd = self.cd_7
        self.duration = self.duration_7
     end
end
    
function modifier_item_hd_autumn_staff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
    return funcs
end

function modifier_item_hd_autumn_staff:Advanced_GetModifierCooldownReduction()
    return self.cooldown_reduction
end

function modifier_item_hd_autumn_staff:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
        local healer = keys.unit
        local target = keys.target
		if healer ~= self:GetParent() then return end
		if target == healer then return end
        -- if GetChaoticEraClass(target) == 4 then return end
        if not target:IsHero() or not target:IsAlive() then return end
        if IsEnemy(healer, target) then return end
        local modifier = target:FindModifierByName("modifier_item_hd_autumn_staff_cd")
		if modifier then return end

        local random = math.random
        if self.chance < random(1,100) then return end
        if self.level >= 40 then
            if self.chance_4 >= random(1,100) then
                local heroes = GetAllRealHeroes()
                for _,hero in pairs(heroes) do
                    if hero:IsAlive() then 
                        self:AutumnGift(hero)
                        hero:AddNewModifier(healer, self.ability, "modifier_item_hd_autumn_staff_cd", {duration = self.cd})
                    end
                end
            else
                self:AutumnGift(target)
                target:AddNewModifier(healer, self.ability, "modifier_item_hd_autumn_staff_cd", {duration = self.cd})
            end
        else
            self:AutumnGift(target)
            target:AddNewModifier(healer, self.ability, "modifier_item_hd_autumn_staff_cd", {duration = self.cd})
        end
	end
end

function modifier_item_hd_autumn_staff:AutumnGift(target)
    if not IsServer() then return end
    if not self.ability then return end
    if not target or not target:IsAlive() then return end
    local caster = self:GetCaster()
    if not caster:IsAlive() then return end
    target:AddNewModifier(caster, self.ability, "modifier_item_hd_autumn_staff_buff", {duration = self.duration, level = self.level})
    target:EmitSound("Hero_Treant.LeechSeed.Tick")
    if self.level >= 10 and GetChaoticEraClass(caster) == 4 then
        caster:EmitSound("Hero_Treant.LeechSeed.Tick")
        caster:AddNewModifier(caster, self.ability, "modifier_item_hd_autumn_staff_buff", {duration = self.duration, level = self.level})
    end
end
-----
modifier_item_hd_autumn_staff_cd = advanced_modifier({})

function modifier_item_hd_autumn_staff_cd:IsDebuff() return true end
function modifier_item_hd_autumn_staff_cd:IsHidden() return false end
function modifier_item_hd_autumn_staff_cd:IsPurgable() return false end
function modifier_item_hd_autumn_staff_cd:GetTexture() return "item_artifact_33" end
-----
modifier_item_hd_autumn_staff_buff = advanced_modifier({})

function modifier_item_hd_autumn_staff_buff:IsDebuff() return false end
function modifier_item_hd_autumn_staff_buff:IsHidden() return false end
function modifier_item_hd_autumn_staff_buff:IsPurgable() return false end
function modifier_item_hd_autumn_staff_buff:GetTexture() return "item_artifact_33" end
function modifier_item_hd_autumn_staff_buff:GetEffectName() return "particles/rebuild/artifact/autumn_staff/effect.vpcf" end
function modifier_item_hd_autumn_staff_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_autumn_staff_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration") 
    self.outgoing_1 = self.ability:GetArtifactSpecialValueFor("outgoing_1") 
    self.time_2 = self.ability:GetArtifactSpecialValueFor("time_2") 
    self.attack_speed_2 = self.ability:GetArtifactSpecialValueFor("attack_speed_2")
    self.cooldown_2 = self.ability:GetArtifactSpecialValueFor("cooldown_2") 
    self.profic_3 = self.ability:GetArtifactSpecialValueFor("profic_3") 
    self.chance_3 = self.ability:GetArtifactSpecialValueFor("chance_3") 
    self.time_7 = self.ability:GetArtifactSpecialValueFor("time_7") 

    if IsServer() then
        self.level = keys.level
        self:SetHasCustomTransmitterData( true )-- 同步cy
        if self.level >= 70 then
            self.time_2 = self.time_7
        end
    end
    self.timeline = self.duration - self.time_2

    if self:GetParent() == self:GetCaster() and GetChaoticEraClass(self:GetCaster()) == 4 then
        self.outgoing = self.outgoing+self.outgoing_1
    end
end

function modifier_item_hd_autumn_staff_buff:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration") 
    self.outgoing_1 = self.ability:GetArtifactSpecialValueFor("outgoing_1") 
    self.time_2 = self.ability:GetArtifactSpecialValueFor("time_2") 
    self.attack_speed_2 = self.ability:GetArtifactSpecialValueFor("attack_speed_2")
    self.cooldown_2 = self.ability:GetArtifactSpecialValueFor("cooldown_2") 
    self.profic_3 = self.ability:GetArtifactSpecialValueFor("profic_3") 
    self.chance_3 = self.ability:GetArtifactSpecialValueFor("chance_3") 
    self.time_7 = self.ability:GetArtifactSpecialValueFor("time_7") 

    if IsServer() then
        self.level = keys.level
        if self.level >= 70 then
            self.time_2 = self.time_7
        end
    end
    self.timeline = self.duration - self.time_2

    if self:GetParent() == self:GetCaster() and GetChaoticEraClass(self:GetCaster()) == 4 then
        self.outgoing = self.outgoing+self.outgoing_1
    end
end

function modifier_item_hd_autumn_staff_buff:OnDestroy(keys)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    if not self.ability then return end
    if self.level < 30 then return end
    
    local random = math.random
    if self.chance_3 >= random(1,100) then
        local caster = self:GetCaster()
        local modifier = caster:FindModifierByName("modifier_item_hd_autumn_staff")
        if modifier then
            modifier:AutumnGift(self:GetParent())
        end
    end
end

function modifier_item_hd_autumn_staff_buff:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_autumn_staff_buff:OnTooltip()
    if not self.ability then self:Destory() return end
	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    elseif self._tooltip == 2 and self.level >= 20 then
        return self:Advanced_GetModifierAttackSpeedPercentage()
    elseif self._tooltip == 3 and self.level >= 20 then
        return self:Advanced_GetModifierCooldownReduction()
    elseif self._tooltip == 4 and self.level >= 30 then
        return self:Advanced_GetModifier_TalentEffectGain()
    end
end

function modifier_item_hd_autumn_staff_buff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()}
    }
    if self.level >= 20 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE)
        table.insert(funcs,advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION)
    end
    if self.level >= 30 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN)
    end
    return funcs
end

function modifier_item_hd_autumn_staff_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self.ability then self:Destory() return end
    return self.outgoing
end
function modifier_item_hd_autumn_staff_buff:Advanced_GetModifierAttackSpeedPercentage()
    if not self.ability then self:Destory() return end
    if self:GetRemainingTime() >= self.timeline then
        return self.attack_speed_2
    end
    return 0
end
function modifier_item_hd_autumn_staff_buff:Advanced_GetModifierCooldownReduction()
    if not self.ability then self:Destory() return end
    if self:GetRemainingTime() >= self.timeline then
        return self.cooldown_2
    end
    return 0
end
function modifier_item_hd_autumn_staff_buff:Advanced_GetModifier_TalentEffectGain()
    if not self.ability then self:Destory() return end
    return self.profic_3
end

function modifier_item_hd_autumn_staff_buff:AddCustomTransmitterData( )
	return
	{
        level = self.level,
	}
end

function modifier_item_hd_autumn_staff_buff:HandleCustomTransmitterData( data )
    self.level = data.level
end