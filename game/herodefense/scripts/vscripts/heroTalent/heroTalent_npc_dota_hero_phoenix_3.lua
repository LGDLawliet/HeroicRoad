heroTalent_npc_dota_hero_phoenix_3 = class({})
LinkLuaModifier( "modifier_herotalent_npc_dota_hero_phoenix_3", "herotalent/heroTalent_npc_dota_hero_phoenix_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_herotalent_npc_dota_hero_phoenix_3_active", "herotalent/heroTalent_npc_dota_hero_phoenix_3", LUA_MODIFIER_MOTION_NONE )






function heroTalent_npc_dota_hero_phoenix_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/phoenix_talent_3/supernovaecon/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", context )
    PrecacheResource( "model", "models/override_model/phoenix/solar_form.vmdl", context )
end

function heroTalent_npc_dota_hero_phoenix_3:GetIntrinsicModifierName()
	return "modifier_herotalent_npc_dota_hero_phoenix_3"
end

function heroTalent_npc_dota_hero_phoenix_3:GetCastRange()
	local caster = self:GetCaster()
	return 800 - caster:GetCastRangeBonus()
end

------------------------------以下是modifier部分--------------------------------------
--modifier1:光环----------------------------------------------------------------------
modifier_herotalent_npc_dota_hero_phoenix_3 = advanced_modifier({})

function modifier_herotalent_npc_dota_hero_phoenix_3:IsHidden()	return true end
function modifier_herotalent_npc_dota_hero_phoenix_3:IsDebuff()	return false end
function modifier_herotalent_npc_dota_hero_phoenix_3:IsPurgable()	return false end
function modifier_herotalent_npc_dota_hero_phoenix_3:IsPurgeException() return false end
function modifier_herotalent_npc_dota_hero_phoenix_3:RemoveOnDeath() return false end
function modifier_herotalent_npc_dota_hero_phoenix_3:GetAuraEntityReject(target)
	return false
end

function modifier_herotalent_npc_dota_hero_phoenix_3:IsAura() return self.enable end

function modifier_herotalent_npc_dota_hero_phoenix_3:GetAuraRadius()	return  self.radius end
function modifier_herotalent_npc_dota_hero_phoenix_3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_herotalent_npc_dota_hero_phoenix_3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_herotalent_npc_dota_hero_phoenix_3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_herotalent_npc_dota_hero_phoenix_3:GetModifierAura()	return "modifier_herotalent_npc_dota_hero_phoenix_3_active" end

function modifier_herotalent_npc_dota_hero_phoenix_3:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end


function modifier_herotalent_npc_dota_hero_phoenix_3:OnCreated(keys)

	if IsServer() then
        self.enable = true
        local ability = self:GetAbility()
        self.radius = ability:GetSpecialValueFor("radius")
        self.time_require = ability:GetSpecialValueFor("duration")

		self.game_time = GameRules:GetGameTime()
        self.timer = 0
		self:StartIntervalThink(0.1)
		local parent = self:GetParent()
		parent:SetOriginalModel("models/override_model/phoenix/solar_form.vmdl")
		local model = parent:FirstMoveChild()
		-- self.modelName = self.hero:GetModelName()
		local model_list = {}
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				table.insert(model_list,model)
			end
			model = model:NextMovePeer()
		end
		for _, model in ipairs(model_list) do
			UTIL_Remove(model)
		end	


        local heroes = GetAllRealHeroes()
        if #heroes>=2 then
            self.team_trigger = true
        end
        self.heroes_list = {}
        for _, hero in ipairs(heroes) do
            if hero~=parent then
                table.insert(self.heroes_list,hero)
            end
        end



        self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/phoenix_talent_3/supernovaecon/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end

end




function modifier_herotalent_npc_dota_hero_phoenix_3:OnRefresh(keys)
    if IsServer() then
        local ability = self:GetAbility()
        self.radius = ability:GetSpecialValueFor("radius")
        self.time_require = ability:GetSpecialValueFor("duration")

    end
end

function modifier_herotalent_npc_dota_hero_phoenix_3:OnIntervalThink()

    -- 检测是否全部死亡或者无敌
    if self.team_trigger and  Game_State:IsInBattle()  then
        local parent = self:GetParent()
        if parent:IsAlive() then
            local pass =false
            -- 计时五秒
            for _, unit in ipairs(self.heroes_list) do
                if (unit:IsAlive() and not unit:IsInvulnerable() and not unit:IsOutOfGame() ) or unit:HasModifier("modifier_Primary_Omni_Slash_caster")
                or unit:HasModifier("modifier_Middle_Omni_Slash_caster")
                or unit:HasModifier("modifier_Advanced_Omni_Slash_caster")  then
                    pass = true
                    break
                end
            end
        
            if not pass then
                -- 那么开始计时
                local current =  GameRules:GetGameTime()
                self.timer = self.timer + current-self.game_time
                if  self.timer>=self.time_require then
                    self.enable = false
                    -- parent:ForceKill(false)
                    TrueKill(parent, parent, self:GetAbility())
                end

            else
                self.timer = 0
                self.enable = true
            end
        end
      
        self.game_time =GameRules:GetGameTime()
    end



    -- 检测特效
	if not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
            self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/phoenix_talent_3/supernovaecon/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
            self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end









function modifier_herotalent_npc_dota_hero_phoenix_3:CheckState()
    if not self.enable then
        return
    end
    if self.team_trigger then
        local data = {
            [MODIFIER_STATE_DISARMED] = true,--缴械
            [MODIFIER_STATE_INVULNERABLE] = true,--无敌
            [MODIFIER_STATE_FORCED_FLYING_VISION] = true,--高空视野
        }
        if IsServer() then
            if not Game_State:IsInBattle()  then
                data = {
                    [MODIFIER_STATE_DISARMED] = true,--缴械
                    [MODIFIER_STATE_FORCED_FLYING_VISION] = true,--高空视野
                }
            end
        end
        return data
    end
    local state = {
        [MODIFIER_STATE_DISARMED] = true,--缴械
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true,--高空视野
    }
    return state
end



function modifier_herotalent_npc_dota_hero_phoenix_3:DeclareFunctions()	
    local decFuncs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA
    }
    
    return decFuncs	
end

function modifier_herotalent_npc_dota_hero_phoenix_3:GetVisualZDelta( params )
    return 450
end


function modifier_herotalent_npc_dota_hero_phoenix_3:GetModifierModelChange()
	return "models/override_model/phoenix/solar_form.vmdl"
end
-- self.team_trigger
function modifier_herotalent_npc_dota_hero_phoenix_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RESPAWN_DISABLE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_Summon_Intensity_Percentage_MUL,
        advanced_MODIFIER_PROPERTY_Flying
    }
end
function modifier_herotalent_npc_dota_hero_phoenix_3:Advanced_GetModifierRespawnDisable(keys)
    return  self.team_trigger and 1 or 0
end

function modifier_herotalent_npc_dota_hero_phoenix_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if IsClient() then
        return 0
    end
    if self.team_trigger then
        if keys.inflictor and keys.inflictor==self:GetAbility() then
            return 0
        end
        return -100
    end
    return 0


end

function modifier_herotalent_npc_dota_hero_phoenix_3:Advanced_GetModifier_Summon_Intensity_Percentage_Mul(keys)
    if IsClient() then
        return 0
    end
    if self.team_trigger then
        return -100
    end
    return 0


end

function modifier_herotalent_npc_dota_hero_phoenix_3:Advanced_GetModifier_Flying()	
    if not self.enable then
        return 0
    end
	return 1
end



--modifier2:active------------------------------------------------------------------
modifier_herotalent_npc_dota_hero_phoenix_3_active = advanced_modifier({})

function modifier_herotalent_npc_dota_hero_phoenix_3_active:IsDebuff() return true end
function modifier_herotalent_npc_dota_hero_phoenix_3_active:IsHidden() return true end
function modifier_herotalent_npc_dota_hero_phoenix_3_active:IsPurgable() return false end


function modifier_herotalent_npc_dota_hero_phoenix_3_active:OnCreated()
    if IsServer() then
		self.parent	= self:GetParent()
		self:StartIntervalThink(1)

        self.damage_index = self:GetAbility():GetSpecialValueFor("damage_index")*0.01
        self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            -- damage = damage,
            ability = self:GetAbility(),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
     }
	end
end
function modifier_herotalent_npc_dota_hero_phoenix_3_active:OnIntervalThink()
	if IsServer() then

		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end 
		local damage = (self.base_damage + self.damage_index*caster:GetMaxHealth())
        self.damageTable.damage = damage
		ApplyDamage( self.damageTable)	
	end
end