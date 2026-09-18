--重做完成
item_hd_dingzhi_luna_3_effects = class({})
LinkLuaModifier("modifier_item_hd_dingzhi_luna_3_effects", "player_artifact/item_hd_dingzhi_luna_3_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_3_effects_buff_1", "player_artifact/item_hd_dingzhi_luna_3_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_3_effects_buff_2", "player_artifact/item_hd_dingzhi_luna_3_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_3_effects_buff_3", "player_artifact/item_hd_dingzhi_luna_3_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_3_effects_lv40", "player_artifact/item_hd_dingzhi_luna_3_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_3_effects_trigger", "player_artifact/item_hd_dingzhi_luna_3_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_dingzhi_luna_3_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_dingzhi_luna_3_effects"
end

function item_hd_dingzhi_luna_3_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/dingzhi_luna_3/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/artifact/dingzhi_luna_3/pick_effect.vpcf.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/artifact/dingzhi_luna_3/lv10_effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/artifact/dingzhi_luna_3/get_buff.vpcf", context )
end
function item_hd_dingzhi_luna_3_effects:GetArtifactSpecialList()
    local list = {}
    list["76561198200656253"] = true
    return list
end
function item_hd_dingzhi_luna_3_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_luna_3_effects:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end

modifier_item_hd_dingzhi_luna_3_effects = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_3_effects:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_3_effects:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_3_effects:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_3_effects:GetTexture() return "item_artifact_73" end
function modifier_item_hd_dingzhi_luna_3_effects:RemoveOnDeath() return false end

function modifier_item_hd_dingzhi_luna_3_effects:OnCreated(keys)
    self.caster=  self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_3_effects")

    self.bonus_vision = self.ability:GetArtifactSpecialValueFor("bonus_vision")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.radius_1 = self.ability:GetArtifactSpecialValueFor("radius_1")
    self.bonus_2 = self.ability:GetArtifactSpecialValueFor("bonus_2")
    self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")
    self.atb_3 = self.ability:GetArtifactSpecialValueFor("atb_3")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.cut_10 = self.ability:GetArtifactSpecialValueFor("cut_10")*0.01
    self.duration_1= self.ability:GetArtifactSpecialValueFor("duration_1")

    self.radius_min = 750
    self.radius_max = 2000

    self.buff1 = 10
    self.buff2 = 4
    self.buff3 = 10
    if self.level >= 20 then
        self.buff1 = self.buff1 + self.bonus_2
        self.buff2 = self.buff2 + self.bonus_2
        self.buff3 = self.buff3 + self.bonus_2
    end
    if self.level >= 30 then
        self.interval = self.interval_3
    end
    if self.level >= 100 then
        self.radius_min = 350
        self.radius_max = 1000
    end
    self.atb = 15
    if IsInToolsMode() then
        self.interval = 1
    end
    if IsServer() then
        self.buff_table = {
            "modifier_item_hd_dingzhi_luna_3_effects_buff_1",
            "modifier_item_hd_dingzhi_luna_3_effects_buff_2",
            "modifier_item_hd_dingzhi_luna_3_effects_buff_3",
        }
        self:StartIntervalThink(self.interval) --第一次龙珠总是正常间隔，第二次再开始判断
    end
end

function modifier_item_hd_dingzhi_luna_3_effects:OnRefresh(keys)
    self.caster=  self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_3_effects")

    self.bonus_vision = self.ability:GetArtifactSpecialValueFor("bonus_vision")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.radius_1 = self.ability:GetArtifactSpecialValueFor("radius_1")
    self.bonus_2 = self.ability:GetArtifactSpecialValueFor("bonus_2")
    self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")
    self.atb_3 = self.ability:GetArtifactSpecialValueFor("atb_3")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.cut_10 = self.ability:GetArtifactSpecialValueFor("cut_10")*0.01
    self.duration_1= self.ability:GetArtifactSpecialValueFor("duration_1")

    self.radius_min = 750
    self.radius_max = 2000

    self.buff1 = 10
    self.buff2 = 4
    self.buff3 = 10
    if self.level >= 20 then
        self.buff1 = self.buff1 + self.bonus_2
        self.buff2 = self.buff2 + self.bonus_2
        self.buff3 = self.buff3 + self.bonus_2
    end
    if self.level >= 30 then
        self.interval = self.interval_3
    end
    if self.level >= 100 then
        self.radius_min = 350
        self.radius_max = 1000
    end
    self.atb = 15
    -- if IsInToolsMode() then
    --     self.interval = 10
    -- end
end

function modifier_item_hd_dingzhi_luna_3_effects:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetCaster()
    local radius_min  = self.radius_min
    local radius_max = self.radius_max
    local angle = RandomFloat(0, 2 * math.pi)
    local distance = math.sqrt(RandomFloat(radius_min^2, radius_max^2))  -- 平方根用于均匀分布
    local vec = parent:GetOrigin() + Vector(distance * math.cos(angle), distance * math.sin(angle))
    local pos = GetClearSpaceForUnit(parent, vec)
    parent:AddNewModifier(parent,self:GetAbility(),"modifier_item_hd_dingzhi_luna_3_effects_trigger",{duration = self.duration , pos = pos , level = self.level})
    if self.level >= 30 then
        MinimapEvent( caster:GetTeamNumber(), self:GetCaster(), pos.x, pos.y, DOTA_MINIMAP_EVENT_MOVE_TO_TARGET, 5)
    end
    
    if self.level >= 100 then
        AddFOWViewer(caster:GetTeamNumber(), pos, 400, self.duration, false)
    end


    local heroes = GetAllRealHeroes()
    local delay_index = 0.0
    if #heroes > 1 then
        for _, hero in pairs(heroes) do
            if hero ~= parent then
               if hero:HasModifier("modifier_item_hd_dingzhi_luna_3_effects") then
                delay_index = delay_index + 0.1
               end
            end
        end
    end


    self.buff1 = 10
    self.buff2 = 4
    if self.level >= 20 then
        self.buff1 = self.buff1 + self.bonus_2
        self.buff2 = self.buff2 + self.bonus_2
    end
    self.buff1 = self.buff1 * (1-delay_index)
    self.buff2 = self.buff2 * (1-delay_index)
end

function modifier_item_hd_dingzhi_luna_3_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_BONUS_VISION,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects:DeclareFuctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hd_dingzhi_luna_3_effects:Advanced_GetBonusVision()
    return self.bonus_vision
end

function modifier_item_hd_dingzhi_luna_3_effects:OnTooltip()
    return self.atb*self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects:Advanced_GetModifierBonusStats_Strength()
    return self.atb*self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects:Advanced_GetModifierBonusStats_Agility()
    return self.atb*self:GetStackCount()
end
        
function modifier_item_hd_dingzhi_luna_3_effects:Advanced_GetModifierBonusStats_Intellect()
    return self.atb*self:GetStackCount()
end
        
function modifier_item_hd_dingzhi_luna_3_effects:OnStackCountChanged(old_stack)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local parent = self:GetParent()
    if self:GetStackCount() >= 7 then
        local heroes = GetAllRealHeroes()
        local delay_index = 0.0
        if #heroes > 1 then
            for _, hero in pairs(heroes) do
                if hero ~= parent then
                if hero:HasModifier("modifier_item_hd_dingzhi_luna_3_effects") then
                    delay_index = delay_index + 0.1
                end
                end
            end
        end


        self.buff1 = 10
        self.buff2 = 4
        if self.level >= 20 then
            self.buff1 = self.buff1 + self.bonus_2
            self.buff2 = self.buff2 + self.bonus_2
        end
        self.buff1 = self.buff1 * (1-delay_index)
        self.buff2 = self.buff2 * (1-delay_index)

        self:SetStackCount(0)
        local particle = ParticleManager:CreateParticle("particles/rebuild/artifact/dingzhi_luna_3/lv10_effect.vpcf", PATTACH_POINT_FOLLOW, parent)
        ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        parent:EmitSound("Hero_Beastmaster.Primal_Roar.ti7")

        if self.level >= 10 then
            local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius_1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            for _, enemy in pairs(enemies) do
                
                enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.duration_1})
            end
        end

        if self.level >= 40 then
            caster:AddNewModifier(caster, nil, "modifier_item_hd_dingzhi_luna_3_effects_lv40", {stack = self.atb_3})
        end

        if self.level >= 70 then
            if self.chance_7 >= math.random(1,100) then
                self:SetStackCount(2)
            end
        end

        if self.level >= 100 then
            local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            for _, enemy in pairs(enemies) do
                local hp_cut = enemy:GetMaxHealth()*self.cut_10
                if enemy:IsChaoticEraBoss() then
                    hp_cut = 0.2
                end
                enemy:ModifyHealth(enemy:GetHealth()-hp_cut, self.ability, false, 0)
            end
        end

        local buff_name = self.buff_table[math.random(1,#self.buff_table)]
        if buff_name == "modifier_item_hd_dingzhi_luna_3_effects_buff_3" then
            self.caster:AddNewModifier(self.caster, nil, buff_name, {stack = self.buff3})
        else
            local heroes = GetAllRealHeroes()
            for _, hero in pairs(heroes) do
                local stack = buff_name == "modifier_item_hd_dingzhi_luna_3_effects_buff_1" and self.buff1 or self.buff2 
                hero:AddNewModifier(self.caster, nil, buff_name, {stack = stack})
            end
        end
    end
end
---------------------------------------------
modifier_item_hd_dingzhi_luna_3_effects_trigger = class({})

function modifier_item_hd_dingzhi_luna_3_effects_trigger:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_3_effects_trigger:IsHidden() return true end
function modifier_item_hd_dingzhi_luna_3_effects_trigger:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_3_effects_trigger:IsPurgeException() return false end
function modifier_item_hd_dingzhi_luna_3_effects_trigger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_dingzhi_luna_3_effects_trigger:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
        self.level = keys.level
		self.pos = StringToVector(keys.pos)
        self.effect_cast = ParticleManager:CreateParticle("particles/rebuild/artifact/dingzhi_luna_3/effect.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
        ParticleManager:SetParticleControl( self.effect_cast, 1, self.pos )
		ParticleManager:SetParticleControl(self.effect_cast, 61, Vector(0, 0, 0))

		-- self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/lunar_blessing/unlock1/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		-- ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		-- ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(200, 0, 0 ) )
		self:StartIntervalThink(0.2)
	end
end

function modifier_item_hd_dingzhi_luna_3_effects_trigger:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end
function modifier_item_hd_dingzhi_luna_3_effects_trigger:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    local heroes = GetAllRealHeroes()
    if #heroes >= 1 then
	    for i, hero in pairs(heroes) do
            if CalculateDistance(hero, self.pos) <= 250 then
                self:StartIntervalThink(-1)
                
                self:GetCaster():GameTimer(0.15, function()
                    local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_dingzhi_luna_3_effects")
                    if modifier then
                        modifier:SetStackCount(modifier:GetStackCount()+1)

                        local particle_cast = "particles/rebuild/artifact/dingzhi_luna_3/pick_effect.vpcf.vpcf"
                        local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, hero)
                        ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
                        ParticleManager:SetParticleControl(particle_cast_fx, 1, hero:GetAbsOrigin())
                        ParticleManager:ReleaseParticleIndex(particle_cast_fx)

                        if hero ~= self:GetCaster() then
                            local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
                            ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
                            ParticleManager:SetParticleControl(particle_cast_fx, 1, self:GetCaster():GetAbsOrigin())
                            ParticleManager:ReleaseParticleIndex(particle_cast_fx)
                        end
                    end
                    self:SafeDestroy()
                end)
                break
            end
        end
    end
end

modifier_item_hd_dingzhi_luna_3_effects_buff_1 = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_3_effects_buff_1:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_1:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_1:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_1:GetTexture() return "item_artifact_73" end
function modifier_item_hd_dingzhi_luna_3_effects_buff_1:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_1:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)

        local particle_aoe = "particles/rebuild/artifact/dingzhi_luna_3/get_buff.vpcf"
        local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(particle_aoe_fx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(400, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_aoe_fx)    
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_1:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + keys.stack)
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_1:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_1:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_1:OnTooltip()
    return self:GetStackCount()
end

-----
modifier_item_hd_dingzhi_luna_3_effects_buff_2 = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_3_effects_buff_2:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_2:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_2:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_2:GetTexture() return "item_artifact_73" end
function modifier_item_hd_dingzhi_luna_3_effects_buff_2:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_2:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
         local particle_aoe = "particles/rebuild/artifact/dingzhi_luna_3/get_buff.vpcf"
        local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(particle_aoe_fx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(400, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_aoe_fx)  
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_2:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + keys.stack)
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_2:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_2:Advanced_GetModifierIncomingDamage_Percentage()
    return -self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_2:OnTooltip()
    return self:GetStackCount()
end

-----
modifier_item_hd_dingzhi_luna_3_effects_buff_3 = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_3:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_3:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_3_effects_buff_3:GetTexture() return "item_artifact_73" end
function modifier_item_hd_dingzhi_luna_3_effects_buff_3:RemoveOnDeath() return false end

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
         local particle_aoe = "particles/rebuild/artifact/dingzhi_luna_3/get_buff.vpcf"
        local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(particle_aoe_fx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(400, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_aoe_fx)  
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + keys.stack)
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_buff_3:OnTooltip()
    return self:GetStackCount()
end

-----
modifier_item_hd_dingzhi_luna_3_effects_lv40 = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_3_effects_lv40:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_3_effects_lv40:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_3_effects_lv40:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_3_effects_lv40:GetTexture() return "item_artifact_73" end
function modifier_item_hd_dingzhi_luna_3_effects_lv40:RemoveOnDeath() return false end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + keys.stack)
    end
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:Advanced_GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:Advanced_GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:Advanced_GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_item_hd_dingzhi_luna_3_effects_lv40:OnTooltip()
    return self:GetStackCount()
end