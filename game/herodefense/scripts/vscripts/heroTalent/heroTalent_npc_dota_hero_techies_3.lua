LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_techies_3", "heroTalent/heroTalent_npc_dota_hero_techies_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_techies_mine", "heroTalent/heroTalent_npc_dota_hero_techies_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_techies_mine_buff", "heroTalent/heroTalent_npc_dota_hero_techies_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_techies_mine_debuff", "heroTalent/heroTalent_npc_dota_hero_techies_3", LUA_MODIFIER_MOTION_NONE )
heroTalent_npc_dota_hero_techies_3 = class({})

function heroTalent_npc_dota_hero_techies_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_techies_3"
end

function heroTalent_npc_dota_hero_techies_3:OnSpellStart()
    if not IsServer() then
        return
    end
	local stack = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_techies_3")
	local line = self:GetSpecialValueFor("line")
    print(line)
	--line = 0
	if stack and stack:GetStackCount() >= line then
		self:PlaceMine()
        stack:SetStackCount(stack:GetStackCount() - line)
	end
end

function heroTalent_npc_dota_hero_techies_3:PlaceMine()
    local caster = self:GetCaster()
    local mine = CreateUnitByName("npc_dota_techies_mine", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
    mine:AddNewModifier(caster, self, "modifier_techies_mine", {})
	mine:AddNewModifier(caster, self, "modifier_invulnerable", {})
	mine:AddNewModifier(caster, self, "modifier_techies_mine_buff", {})
end
--------------------------------------------------------------------------------------------------------
modifier_techies_mine_buff = advanced_modifier({})

function modifier_techies_mine_buff:IsHidden() return true end
function modifier_techies_mine_buff:IsPurgable() return false end
function modifier_techies_mine_buff:RemoveOnDeath() return false end
function modifier_techies_mine_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_techies_mine_buff:Advanced_GetModifierIncomingDamage_Percentage()
	return -100
end
--------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_techies_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_techies_3:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_techies_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_techies_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_techies_3:OnCreated()
	self.each_kill = self:GetAbility():GetSpecialValueFor("each_kill")
	self.each_turn = self:GetAbility():GetSpecialValueFor("each_turn")
	self:SetStackCount(0)
end
function modifier_heroTalent_npc_dota_hero_techies_3:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_Wave_Start = {}
    }
end

function modifier_heroTalent_npc_dota_hero_techies_3:OnDeath(params)
    if params.attacker == self:GetParent() and params.unit:GetTeam() ~= self:GetParent():GetTeam() and params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
        if params.inflictor and params.inflictor:GetAbilityName() ~= "heroTalent_npc_dota_hero_techies_3" then
            self:SetStackCount(self:GetStackCount() + self.each_kill)
        end
    end
end

function modifier_heroTalent_npc_dota_hero_techies_3:OnWaveStart()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + self.each_turn)
	end
end
--------------------------------------------------------------------------------------------------------
modifier_techies_mine = advanced_modifier({})

function modifier_techies_mine:IsHidden() return true end
function modifier_techies_mine:IsPurgable() return false end

function modifier_techies_mine:OnCreated()
	self.check_radius = self:GetAbility():GetSpecialValueFor("check_radius")
	self.boom_radius = self:GetAbility():GetSpecialValueFor("boom_radius")
	self.boom_damage = self:GetAbility():GetSpecialValueFor("boom_damage")
	self.bonus_boom_damage = self:GetAbility():GetSpecialValueFor("bonus_boom_damage")
	self.friendly_index = self:GetAbility():GetSpecialValueFor("friendly_index")*0.01
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
end

function modifier_techies_mine:OnIntervalThink()
    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.check_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    if #enemies > 0 then
        self:Explode()
    end
end

function modifier_techies_mine:Explode()
	if not IsServer() then
		return
	end
	self:GetParent():GameTimer(0.8,function()
		
	
    local caster = self:GetCaster()
    local mine = self:GetParent()
    local damage = self.boom_damage + self.bonus_boom_damage*caster:GetIntellect(false)
    local radius = self.boom_radius
	local pos = self:GetParent():GetAbsOrigin()
	self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.Target")

    -- 添加地雷爆炸特效
    local pfx_aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_aoe, 0, pos)
	ParticleManager:SetParticleControl(pfx_aoe, 1, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex(pfx_aoe)
	ScreenShake( self:GetParent():GetOrigin(), 100.0, 100.0, 0.5, 10000.0, 0, true )
	--CameraShake(1,30)

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        mine:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, nil, "modifier_techies_mine_debuff", {duration = 0.1})
        local damageTable =
		{
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
        }
		if enemy:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			damageTable.damage = damageTable.damage*self.friendly_index
		end
		if enemy:GetUnitName() == "npc_monster_challenge_001" or enemy:GetUnitName() == "npc_hd_Supreme_Nevermore" or enemy:GetUnitName() == "npc_dota_hero_nevermore" then
			damageTable.damage = damageTable.damage*1.3
		end
		ApplyDamage(damageTable)
        if enemy:GetHealthPercent() <= 10 or not enemy:IsAlive() then
            enemy:ForceKill(false)
        end
    end
    mine:RemoveSelf()
	end)
end
-------------------------------------------------------------------------------------------------------- 
modifier_techies_mine_debuff = advanced_modifier({})

function modifier_techies_mine_debuff:IsHidden() return true end
function modifier_techies_mine_debuff:IsPurgable() return false end
function modifier_techies_mine_debuff:IsDebuff() return true end
function modifier_techies_mine_debuff:CheckState()
    return{
        [MODIFIER_STATE_STUNNED] = true,
    }
end
function modifier_techies_mine_debuff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_techies_mine_debuff:GetDisableHealing()
    return 1
end