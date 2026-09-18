-- 重写完成
item_hd_dingzhi_saogang = class({})
LinkLuaModifier("modifier_item_hd_dingzhi_saogang", "player_artifact/item_hd_dingzhi_saogang.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_saogang_buff", "player_artifact/item_hd_dingzhi_saogang.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_saogang_cd", "player_artifact/item_hd_dingzhi_saogang.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_saogang_buff_lv40", "player_artifact/item_hd_dingzhi_saogang.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_dingzhi_saogang:GetIntrinsicModifierName()
	return "modifier_item_hd_dingzhi_saogang"
end
function item_hd_dingzhi_saogang:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/artifact/saogang/shield.vpcf", context )
end
function item_hd_dingzhi_saogang:GetArtifactSpecialList()
    local list = {}
    list["76561198295752005"] = true
    return list
end

function item_hd_dingzhi_saogang:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_saogang:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end

modifier_item_hd_dingzhi_saogang = advanced_modifier({})

function modifier_item_hd_dingzhi_saogang:IsDebuff() return false end
function modifier_item_hd_dingzhi_saogang:IsHidden() return true end
function modifier_item_hd_dingzhi_saogang:IsPurgable() return false end
function modifier_item_hd_dingzhi_saogang:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_mana = self.ability:GetArtifactSpecialValueFor("bonus_mana")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration") 
    self.cd = self.ability:GetArtifactSpecialValueFor("cd") 
    self.cd_1 = self.ability:GetArtifactSpecialValueFor("cd_1") 
    self.cd_7 = self.ability:GetArtifactSpecialValueFor("cd_7") 

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_saogang")
    
    if self.level >= 10 then
       self.cd = self.cd_1 
    end
    if self.level >= 70 then
        self.cd = self.cd_7
    end
end

function modifier_item_hd_dingzhi_saogang:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_mana = self.ability:GetArtifactSpecialValueFor("bonus_mana")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration") 
    self.cd = self.ability:GetArtifactSpecialValueFor("cd") 
    self.cd_1 = self.ability:GetArtifactSpecialValueFor("cd_1") 
    self.cd_7 = self.ability:GetArtifactSpecialValueFor("cd_7") 
    
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_saogang")
    
    if self.level >= 10 then
       self.cd = self.cd_1 
    end
    if self.level >= 70 then
        self.cd = self.cd_7
    end
end
    
function modifier_item_hd_dingzhi_saogang:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
    }
    return funcs
end

function modifier_item_hd_dingzhi_saogang:AdvancedGetModifierManaBonus()
    return self.bonus_mana
end

function modifier_item_hd_dingzhi_saogang:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
        local healer = keys.unit
        local target = keys.target
		if healer ~= self:GetParent() then return end
		if target == healer then return end
        if GetChaoticEraClass(target) == 4 then return end
        if not target:IsHero() or not target:IsAlive() then return end
        if IsEnemy(healer, target) then return end
        local modifier = target:FindModifierByName("modifier_item_hd_dingzhi_saogang_cd")
		if modifier then return end
		
        self:ShieldShoot(target)
        target:AddNewModifier(healer, self.ability, "modifier_item_hd_dingzhi_saogang_cd", {duration = self.cd})
	end
end

function modifier_item_hd_dingzhi_saogang:ShieldShoot(target)
    if not IsServer() then return end
    if not target then return end
    local caster = self:GetCaster()
    if not caster:IsAlive() then return end
    
    local delay = CalculateDistance(caster,target)/4000
    self.info = 
	{
		Target = target,
		Source = caster,
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
		iMoveSpeed = 4000,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = false,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = true, --提供视野
		ExtraData = {}   --额外的数据
	}

	ProjectileManager:CreateTrackingProjectile(self.info)


    caster:GameTimer(delay,function ()
        if not self.ability or not target:IsAlive() then return end
        target:AddNewModifier(caster, self.ability, "modifier_item_hd_dingzhi_saogang_buff", {duration = self.duration, level = self.level})
    end)
end
-----
modifier_item_hd_dingzhi_saogang_cd = advanced_modifier({})

function modifier_item_hd_dingzhi_saogang_cd:IsDebuff() return true end
function modifier_item_hd_dingzhi_saogang_cd:IsHidden() return false end
function modifier_item_hd_dingzhi_saogang_cd:IsPurgable() return false end
function modifier_item_hd_dingzhi_saogang_cd:GetTexture() return "item_artifact_62" end
-----
modifier_item_hd_dingzhi_saogang_buff_lv40 = advanced_modifier({})

function modifier_item_hd_dingzhi_saogang_buff_lv40:IsDebuff() return false end
function modifier_item_hd_dingzhi_saogang_buff_lv40:IsHidden() return true end
function modifier_item_hd_dingzhi_saogang_buff_lv40:IsPurgable() return false end
function modifier_item_hd_dingzhi_saogang_buff_lv40:OnCreated(keys)
    self.ability = self:GetAbility()
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
end
function modifier_item_hd_dingzhi_saogang_buff_lv40:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
end
function modifier_item_hd_dingzhi_saogang_buff_lv40:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_item_hd_dingzhi_saogang_buff_lv40:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not self.ability then self:Destory() return end
    return -self.incoming_4
end
-----
modifier_item_hd_dingzhi_saogang_buff = advanced_modifier({})

function modifier_item_hd_dingzhi_saogang_buff:IsDebuff() return false end
function modifier_item_hd_dingzhi_saogang_buff:IsHidden() return false end
function modifier_item_hd_dingzhi_saogang_buff:IsPurgable() return false end
function modifier_item_hd_dingzhi_saogang_buff:GetPriority() return 10 end
function modifier_item_hd_dingzhi_saogang_buff:GetTexture() return "item_artifact_62" end
function modifier_item_hd_dingzhi_saogang_buff:GetEffectName() return "particles/rebuild/artifact/saogang/shield.vpcf" end
function modifier_item_hd_dingzhi_saogang_buff:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_dingzhi_saogang_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.armor = self.ability:GetArtifactSpecialValueFor("armor") 

    self.hp_1 = self.ability:GetArtifactSpecialValueFor("hp_1") 
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2") 
    self.incoming_high_2 = self.ability:GetArtifactSpecialValueFor("incoming_high_2") 
    self.outgoing_3 = self.ability:GetArtifactSpecialValueFor("outgoing_3") 
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4") 
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4") 
    self.armor_7 = self.ability:GetArtifactSpecialValueFor("armor_7") 
    if IsServer() then
       self.level = keys.level
       self:SetHasCustomTransmitterData( true )-- 同步cy
    end

    if self.level >= 20 then
       self.incoming = self.incoming_2 
    end
    if self.level >= 70 then
       self.armor = self.armor_7 
    end
end

function modifier_item_hd_dingzhi_saogang_buff:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.armor = self.ability:GetArtifactSpecialValueFor("armor") 

    self.hp_1 = self.ability:GetArtifactSpecialValueFor("hp_1") 
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2") 
    self.incoming_high_2 = self.ability:GetArtifactSpecialValueFor("incoming_high_2") 
    self.outgoing_3 = self.ability:GetArtifactSpecialValueFor("outgoing_3") 
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4") 
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4") 
    self.armor_7 = self.ability:GetArtifactSpecialValueFor("armor_7") 

    if IsServer() then
       self.level = keys.level
       self:SetHasCustomTransmitterData( true )-- 同步cy
    end

    if self.level >= 20 then
       self.incoming = self.incoming_2 
    end
    if self.level >= 70 then
        self.armor = self.armor_7 
     end
end
function modifier_item_hd_dingzhi_saogang_buff:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_dingzhi_saogang_buff:OnTooltip()
    if not self.ability then self:Destory() return end
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
    elseif self._tooltip == 2 then
        return self.armor
    end
end

function modifier_item_hd_dingzhi_saogang_buff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()}
    }
    if self.level >= 10 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE)
    end
    if self.level >= 30 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
    end
    return funcs
end

function modifier_item_hd_dingzhi_saogang_buff:OnTakeDamage(keys)
    if not self.ability then self:Destory() return end
	if not IsServer() then return end
	local unit = keys.unit
    local caster = self:GetCaster()
    if self.level < 40 then return end
	if not unit or unit ~= self:GetParent() then return end
	if not unit:IsAlive() then
		unit:SetHealth(1+keys.damage)
		local random = math.random
        if GetChaoticEraClass(caster) == 4 then
            unit:AddNewModifier(caster, self.ability, "modifier_item_hd_dingzhi_saogang_buff_lv40",{duration = self.duration_4})
        end
        if self.chance_4 >= random(1,100) then
            self:Destroy()
        end
	end

end
function modifier_item_hd_dingzhi_saogang_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not self.ability then self:Destory() return end
    local parent = self:GetParent()
    if parent:GetHealthPercent() >= self.line_2 then
        return -self.incoming_high_2
    end
    return -self.incoming
end
function modifier_item_hd_dingzhi_saogang_buff:Advanced_GetModifierPhysicalArmorBonusPercentage()
    if not self.ability then self:Destory() return end
    return self.armor
end
function modifier_item_hd_dingzhi_saogang_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not self.ability then self:Destory() return end
    local caster = self:GetCaster()
    if GetChaoticEraClass(caster) ~= 4 then return end
    return self.outgoing_3
end
function modifier_item_hd_dingzhi_saogang_buff:AdvancedGetModifierExtraHealthPercentage()
    if not self.ability then self:Destory() return end
    return self.hp_1
end

function modifier_item_hd_dingzhi_saogang_buff:AddCustomTransmitterData( )
	return
	{
        level = self.level,
	}
end

function modifier_item_hd_dingzhi_saogang_buff:HandleCustomTransmitterData( data )
    self.level = data.level
end