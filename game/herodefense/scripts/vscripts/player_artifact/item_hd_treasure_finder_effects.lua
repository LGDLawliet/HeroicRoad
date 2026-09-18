--重做完成
item_hd_treasure_finder_effects = class({})
LinkLuaModifier("modifier_item_hd_treasure_finder_effects", "player_artifact/item_hd_treasure_finder_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_treasure_finder_effects_lv20", "player_artifact/item_hd_treasure_finder_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_treasure_finder_effects_trigger", "player_artifact/item_hd_treasure_finder_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_treasure_finder_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_treasure_finder_effects"
end
function item_hd_treasure_finder_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/lunar_blessing/unlock1/effect.vpcf", context )
end
modifier_item_hd_treasure_finder_effects = advanced_modifier({})

function modifier_item_hd_treasure_finder_effects:IsDebuff() return false end
function modifier_item_hd_treasure_finder_effects:IsHidden() return true end
function modifier_item_hd_treasure_finder_effects:IsPurgable() return false end
function modifier_item_hd_treasure_finder_effects:GetTexture() return "item_artifact_26" end
function modifier_item_hd_treasure_finder_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_treasure_finder_effects")
    self.bonus_vision = self.ability:GetArtifactSpecialValueFor("bonus_vision")
    self.chance_10  = self.ability:GetArtifactSpecialValueFor("chance_10")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_treasure_finder_effects:OnRefresh(keys)
    self.bonus_vision = self.ability:GetArtifactSpecialValueFor("bonus_vision")
    self.chance_10  = self.ability:GetArtifactSpecialValueFor("chance_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_treasure_finder_effects")
end

function modifier_item_hd_treasure_finder_effects:OnIntervalThink()
    local radius = self.ability:GetArtifactSpecialValueFor("radius")
    local duration = self.ability:GetArtifactSpecialValueFor("interval")
    local parent = self:GetCaster()
	if parent:IsAlive() then
        local vec = parent:GetOrigin() + Vector(RandomInt(-radius, radius),RandomInt(-radius, radius))
		local pos = GetClearSpaceForUnit(parent, vec)
		parent:AddNewModifier(parent,self:GetAbility(),"modifier_item_hd_treasure_finder_effects_trigger",{duration = 0.5*duration , pos = pos , level = self.level})

        if self.level >= 100 then
            local event_aura = parent:FindModifierByName("chinese_event_guoqing_2025")
            if event_aura and self.chance_10 >= math.random(1,100) then
                event_aura:CreateBuffAura()
            end
        end
	end
end

function modifier_item_hd_treasure_finder_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_BONUS_VISION,
    }
    return funcs
end

function modifier_item_hd_treasure_finder_effects:Advanced_GetBonusVision()
    return self.bonus_vision
end
---------------------------------------------
modifier_item_hd_treasure_finder_effects_trigger = class({})

function modifier_item_hd_treasure_finder_effects_trigger:IsDebuff() return false end
function modifier_item_hd_treasure_finder_effects_trigger:IsHidden() return true end
function modifier_item_hd_treasure_finder_effects_trigger:IsPurgable() return false end
function modifier_item_hd_treasure_finder_effects_trigger:IsPurgeException() return false end
function modifier_item_hd_treasure_finder_effects_trigger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_treasure_finder_effects_trigger:OnCreated(keys)
    if not self:GetAbility() then return end
    self.gold_lvl = self:GetAbility():GetArtifactSpecialValueFor("gold_lvl")
    self.gold_lvl_2 = self:GetAbility():GetArtifactSpecialValueFor("gold_lvl_2")
    self.gold_lvl_4 = self:GetAbility():GetArtifactSpecialValueFor("gold_lvl_4")
    self.gold_lvl_7 = self:GetAbility():GetArtifactSpecialValueFor("gold_lvl_7")
    self.index_1 = self:GetAbility():GetArtifactSpecialValueFor("index_1")*0.01
	if IsServer() then
        self.level = keys.level
		self.pos = StringToVector(keys.pos)
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/lunar_blessing/unlock1/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(200, 0, 0 ) )
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_hd_treasure_finder_effects_trigger:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end
function modifier_item_hd_treasure_finder_effects_trigger:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    local gold_lvl = self.gold_lvl
    if self.level >= 20 then
        gold_lvl = self.gold_lvl_2
    end
    if self.level >= 40 then
        gold_lvl = self.gold_lvl_4
    end
    if self.level >= 70 then
        gold_lvl = self.gold_lvl_7
    end
    
    local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #heroes >= 1 then
	    for i, hero in pairs(heroes) do
            local gold = hero:GetLevel()*gold_lvl
            hero:ModifyGoldFiltered(gold,true,DOTA_ModifyGold_CreepKill)  --金币奖励
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,hero, gold, nil)
            if self.level >= 10 then
                local index = self.index_1
                self:GetCaster():ModifyGoldFiltered(gold*index,true,DOTA_ModifyGold_CreepKill)  --金币奖励
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self:GetCaster(), gold*index, nil)
            end
            if self.level >= 30 then
                local item = hero:GetItemInSlot(15)
                if item:GetCurrentCharges() < 3 then
                    item:SetCurrentCharges(item:GetCurrentCharges() + 1)
                end
            end
            self:SafeDestroy()
            break
        end
    end
end

modifier_item_hd_treasure_finder_effects_lv20 = advanced_modifier({})

function modifier_item_hd_treasure_finder_effects_lv20:IsDebuff() return false end
function modifier_item_hd_treasure_finder_effects_lv20:IsHidden() return true end
function modifier_item_hd_treasure_finder_effects_lv20:IsPurgable() return false end
function modifier_item_hd_treasure_finder_effects_lv20:GetTexture() return "item_artifact_26" end

function modifier_item_hd_treasure_finder_effects_lv20:OnCreated()
    self.spell_amp = self:GetAbility():GetArtifactSpecialValueFor("spell_amp_2")
end
function modifier_item_hd_treasure_finder_effects_lv20:OnRefresh()
    self.spell_amp = self:GetAbility():GetArtifactSpecialValueFor("spell_amp_2")
end

function modifier_item_hd_treasure_finder_effects_lv20:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
    return funcs
end

function modifier_item_hd_treasure_finder_effects_lv20:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell_amp
end