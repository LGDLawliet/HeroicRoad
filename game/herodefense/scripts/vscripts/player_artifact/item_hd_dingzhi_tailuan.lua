-- 重写完成
item_hd_dingzhi_tailuan = class({})
LinkLuaModifier("modifier_item_hd_dingzhi_tailuan", "player_artifact/item_hd_dingzhi_tailuan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_tailuan_cd", "player_artifact/item_hd_dingzhi_tailuan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_tailuan_lv30_cd", "player_artifact/item_hd_dingzhi_tailuan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_tailuan_lv30", "player_artifact/item_hd_dingzhi_tailuan.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_dingzhi_tailuan:GetIntrinsicModifierName()
	return "modifier_item_hd_dingzhi_tailuan"
end
function item_hd_dingzhi_tailuan:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", context )
end
function item_hd_dingzhi_tailuan:GetArtifactSpecialList()
    local list = {}
    list["76561198144262095"] = true
    return list
end

function item_hd_dingzhi_tailuan:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_tailuan:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end
modifier_item_hd_dingzhi_tailuan = advanced_modifier({})

function modifier_item_hd_dingzhi_tailuan:IsDebuff() return false end
function modifier_item_hd_dingzhi_tailuan:IsHidden() return self.level < 20 end
function modifier_item_hd_dingzhi_tailuan:IsPurgable() return false end
function modifier_item_hd_dingzhi_tailuan:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_tailuan:DestroyOnExpire() return false end
function modifier_item_hd_dingzhi_tailuan:GetTexture() return "item_artifact_58" end
function modifier_item_hd_dingzhi_tailuan:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_damage = self.ability:GetArtifactSpecialValueFor("bonus_damage")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.cd = self.ability:GetArtifactSpecialValueFor("cd")

    self.damage_1 = self.ability:GetArtifactSpecialValueFor("damage_1")
    self.line_1 = self.ability:GetArtifactSpecialValueFor("line_1")
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
    self.attack_speed_3 = self.ability:GetArtifactSpecialValueFor("attack_speed_3")
    self.cdbig_3 = self.ability:GetArtifactSpecialValueFor("cdbig_3")
    self.cdbig_4 = self.ability:GetArtifactSpecialValueFor("cdbig_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.stack_min_7 = self.ability:GetArtifactSpecialValueFor("stack_min_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_tailuan")
    if self.level >= 10 then
       self.damage = self.damage_1
       self.line = self.line_1
    end
    if self.level >= 40 then
       self.cdbig_3 = self.cdbig_4 
    end
end

function modifier_item_hd_dingzhi_tailuan:OnRefresh(keys)
    self.bonus_damage = self.ability:GetArtifactSpecialValueFor("bonus_damage")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.cd = self.ability:GetArtifactSpecialValueFor("cd")

    self.damage_1 = self.ability:GetArtifactSpecialValueFor("damage_1")
    self.line_1 = self.ability:GetArtifactSpecialValueFor("line_1")
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
    self.attack_speed_3 = self.ability:GetArtifactSpecialValueFor("attack_speed_3")
    self.cdbig_3 = self.ability:GetArtifactSpecialValueFor("cdbig_3")
    self.cdbig_4 = self.ability:GetArtifactSpecialValueFor("cdbig_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.stack_min_7 = self.ability:GetArtifactSpecialValueFor("stack_min_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_tailuan")
    if self.level >= 10 then
       self.damage = self.damage_1
       self.line = self.line_1
    end
    if self.level >= 40 then
       self.cdbig_3 = self.cdbig_4 
    end
end

function modifier_item_hd_dingzhi_tailuan:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hd_dingzhi_tailuan:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_item_hd_dingzhi_tailuan:Advanced_GetModifierBaseDamageOutgoing_Percentage()	
    local attack = self.bonus_damage
    if self.level >= 20 and self:GetStackCount() > 0 then
        attack = attack + self:GetStackCount()*self.attack_2
    end
    return attack
end

function modifier_item_hd_dingzhi_tailuan:OnTooltip()
    return self:GetStackCount()*self.attack_2
end

function modifier_item_hd_dingzhi_tailuan:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if not self:GetAbility() or not self:GetParent():IsAlive() then
		return
	end
    if self:GetParent():HasModifier("modifier_item_hd_dingzhi_tailuan_cd") then return end
    if self:GetParent():IsInSpecialAttack() then return end
    
    local chance = self.chance
    local cd = self.cd
    if self.level >= 40 and self:GetParent():HasModifier("modifier_item_hd_dingzhi_tailuan_lv30") then
       chance = self.chance_4
       cd = self.cd_4
    end
    
	if keys.attacker == self:GetParent() then
        local random = math.random
		if chance >= random(1,100) then
			self:Trigger(self:GetParent())
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_dingzhi_tailuan_cd", {duration = cd})
		end
	end
end

function modifier_item_hd_dingzhi_tailuan:Trigger(attachUnit)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damage = self.damage *caster:GetAverageTrueAttackDamage(nil)
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = ability,
    }
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
    if self.level >= 20 then
        self:SetStackCount(#enemies)
        if self.level >= 70 then
            self:SetStackCount(math.max(self.stack_min_7, #enemies))
        end
    end
	local hit = false
	for i,enemy in pairs(enemies) do
		hit = true
		damageTable.victim = enemy
        if enemy:GetHealthPercent() <= self.line then
            damageTable.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
        end
		enemy:ApplyMergeDamage( damageTable )
	end
    
    if self.level >= 30 and not self:GetParent():HasModifier("modifier_item_hd_dingzhi_tailuan_lv30_cd") then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_dingzhi_tailuan_lv30_cd", {duration = self.cdbig_3})
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_dingzhi_tailuan_lv30", {duration = self.duration_3, stack = self.attack_speed_3})
        local sound_cast = "Hero_Marci.Unleash.Cast"
	    EmitSoundOn( sound_cast, self:GetParent() )
        self:GetParent():GameTimer(0.15,function(...)
        EmitSoundOn( sound_cast, self:GetParent() )
        end)
    end
	self:PlayEffects( attachUnit,self.radius, hit )
end

function modifier_item_hd_dingzhi_tailuan:PlayEffects( attachUnit,radius, hit )
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf"
	local sound_cast = "Hero_Shredder.WhirlingDeath.Cast"
	local sound_target = "Hero_Shredder.WhirlingDeath.Damage"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, attachUnit )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		attachUnit,
		PATTACH_CENTER_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true 
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, attachUnit )
	if hit then
		EmitSoundOn( sound_target, attachUnit )
	end
end

--cd
modifier_item_hd_dingzhi_tailuan_cd = advanced_modifier({})

function modifier_item_hd_dingzhi_tailuan_cd:IsDebuff() return false end
function modifier_item_hd_dingzhi_tailuan_cd:IsHidden() return true end
function modifier_item_hd_dingzhi_tailuan_cd:IsPurgable() return false end
function modifier_item_hd_dingzhi_tailuan_cd:RemoveOnDeath() return false end
--cd
modifier_item_hd_dingzhi_tailuan_lv30_cd = advanced_modifier({})

function modifier_item_hd_dingzhi_tailuan_lv30_cd:IsDebuff() return false end
function modifier_item_hd_dingzhi_tailuan_lv30_cd:IsHidden() return true end
function modifier_item_hd_dingzhi_tailuan_lv30_cd:IsPurgable() return false end
function modifier_item_hd_dingzhi_tailuan_lv30_cd:RemoveOnDeath() return false end
--cd
modifier_item_hd_dingzhi_tailuan_lv30 = advanced_modifier({})

function modifier_item_hd_dingzhi_tailuan_lv30:IsDebuff() return false end
function modifier_item_hd_dingzhi_tailuan_lv30:IsHidden() return false end
function modifier_item_hd_dingzhi_tailuan_lv30:IsPurgable() return false end
function modifier_item_hd_dingzhi_tailuan_lv30:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_tailuan_lv30:GetTexture() return "item_artifact_58" end
function modifier_item_hd_dingzhi_tailuan_lv30:OnCreated(keys)
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_tailuan")
    self.attack_time_4 = self:GetAbility():GetArtifactSpecialValueFor("attack_time_4")
    if IsServer() then 
        self.stack = keys.stack
        self:SetStackCount(self.stack)
    end
end
function modifier_item_hd_dingzhi_tailuan_lv30:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }
end
function modifier_item_hd_dingzhi_tailuan_lv30:Advanced_GetModifierAttackSpeedPercentage()
    if not self:GetAbility() then return end
    return  self:GetStackCount()
end
function modifier_item_hd_dingzhi_tailuan_lv30:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
    }
end
function modifier_item_hd_dingzhi_tailuan_lv30:GetModifierBaseAttackTimeConstant()
    if not self:GetAbility() then return end
    return self.attack_time_4
end