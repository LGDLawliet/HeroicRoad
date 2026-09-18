LinkLuaModifier("modifier_item_act3_water", "items/item_act3_water.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_water_2", "items/item_act3_water.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_water_3", "items/item_act3_water.lua", LUA_MODIFIER_MOTION_NONE)
item_act3_water = class({})

function item_act3_water:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_scepter.vpcf", context )
    
end

function item_act3_water:Spawn()
    if IsServer() then
        self:SetCurrentCharges(0)
        if IsInToolsMode() then
            self:SetCurrentCharges(90)
        end
    end
end

function item_act3_water:GetIntrinsicModifierName()
    return "modifier_item_act3_water"
end

-- 主修饰器
modifier_item_act3_water = advanced_modifier({})

function modifier_item_act3_water:IsHidden() return true end
function modifier_item_act3_water:IsDebuff() return false end
function modifier_item_act3_water:IsPurgable() return false end
function modifier_item_act3_water:RemoveOnDeath() return false end

function modifier_item_act3_water:OnCreated()
    
        self.ability = self:GetAbility()
        self.parent = self.parent or self:GetParent()
        
        -- 获取KV配置参数
        self.interval = self.ability:GetSpecialValueFor("interval")
        self.regen_1 = self.ability:GetSpecialValueFor("regen_1")*0.01
        self.cd_1 = self.ability:GetSpecialValueFor("cd_1")
        self.need = self.ability:GetSpecialValueFor("need")
        self.check2 = self.ability:GetSpecialValueFor("check2")
        self.duration_2 = self.ability:GetSpecialValueFor("duration_2")
        self.check3 = self.ability:GetSpecialValueFor("check3")
        self.index_3 = self.ability:GetSpecialValueFor("index_3")*0.01
        self.radius_3 = self.ability:GetSpecialValueFor("radius_3")
        self.check4 = self.ability:GetSpecialValueFor("check4")
        self.casttime_4 = self.ability:GetSpecialValueFor("casttime_4")
        self.cd_4 = self.ability:GetSpecialValueFor("cd_4")
        self.point_cd = self.ability:GetSpecialValueFor("point_cd")
        
        self.damage_radius = 275
        self.damage_atk_index = 2.6
        self.damage_atb_index = 12
        self.base_damage = 400
        self.bonus_damage_pct = 0.03
        self.duration = 0.6
    if IsServer() then
        -- 计数器

        self.skill_count = 0
        -- 定时器
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_act3_water:OnIntervalThink()
    if not IsServer() then return end
    if not self.ability or not self.parent:IsAlive() then return end
    
    -- 水灵之祝效果：每interval秒回复已损失生命值和魔法值的regen_1%%并减少可刷新技能cd_1秒冷却时间
    -- 回复已损失生命值和魔法值
        local missing_hp = self.parent:GetMaxHealth() - self.parent:GetHealth()
        local missing_mana = self.parent:GetMaxMana() - self.parent:GetMana()
        local hp_restore = missing_hp * self.regen_1
        local mana_restore = missing_mana * self.regen_1
        
        self.parent:Heal(hp_restore, self.ability)
        self.parent:GiveMana(mana_restore)
        
        -- 减少可刷新技能冷却时间
        for i=0, self.parent:GetAbilityCount() - 1 do
            local Ability = self.parent:GetAbilityByIndex(i)
            if Ability ~= nil and (not Ability:IsCooldownReady()) then
                local new_cooldown = Ability:GetCooldownTimeRemaining()
                if Ability:IsRefreshable() then
                    new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - (self.ability:GetCurrentCharges() >= self.check4 and self.cd_4 or self.cd_1),0)
                elseif self.ability:GetCurrentCharges() >= self.check3 then
                    new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - (self.ability:GetCurrentCharges() >= self.check4 and self.cd_4 or self.cd_1)*self.index_3,0)
                end
                Ability:EndCooldown()
                Ability:StartCooldown(new_cooldown)
            end
        end
        
        -- %check2%灵能点被动：纯净之水
        if self.ability:GetCurrentCharges() >= self.check2 then
            -- 强驱散
            self.parent:Purge(false, true, false, true, true)
            -- 添加免疫伤害修饰器
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act3_water_2", {duration = self.duration_2})
        end
        
        -- %check3%灵能点被动：浩瀚之水
        if self.ability:GetCurrentCharges() >= self.check3 then
                -- 对周围radius_3范围内一个随机敌人触发洪流
                local enemies = FindUnitsInRadius(
                    self.parent:GetTeamNumber(),
                    self.parent:GetAbsOrigin(),
                    nil,
                    self.radius_3,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_NONE,
                    FIND_ANY_ORDER,
                    false
                )
                
                if #enemies > 0 then
                    local target = enemies[RandomInt(1, #enemies)]
                    if target and target:IsAlive() then
                        self:OnArrived(target:GetAbsOrigin())
                    end
                end
            end
end

function modifier_item_act3_water:OnArrived(pos)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	if not pos then return end

	local radius = self.damage_radius
    local adaptdamagetable = GetAdaptDamage(caster:GetAverageTrueAttackDamage(nil), self.damage_atk_index, caster:HDGetPrimaryStatValue(), self.damage_atb_index)
	local damage = (self.base_damage + adaptdamagetable.damage) * (1+self.ability:GetCurrentCharges()*self.bonus_damage_pct)
    local damage_type = adaptdamagetable.type

	local damageTable = {
		--victim = enemy,
		attacker = caster,
		damage = damage,
		damage_type = damage_type,
		ability = self.ability,
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}
	-- 特效音效
	local particle_name = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_scepter.vpcf"
	local torrent_particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(torrent_particle, 0, pos)
	ParticleManager:ReleaseParticleIndex(torrent_particle)
	EmitSoundOnLocationWithCaster(pos, "Ability.Torrent", caster)
	-- 伤害效果
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in ipairs(enemies) do
		if enemy ~= nil and not enemy:IsMagicImmune() then
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if enemy:IsAlive() then
				enemy:AddNewModifier(caster, self.ability, "modifier_item_act3_water_3", {duration = self.duration})
			end
		end
	end
end
function modifier_item_act3_water:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_CastPoint,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION
    }
    return funcs
end
function modifier_item_act3_water:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end
function modifier_item_act3_water:Advanced_GetModifier_CastPoint(event)
    if self.ability:GetCurrentCharges() >= self.check4 then
        return self.casttime_4
    end
end
function modifier_item_act3_water:OnAbilityExecuted(event)
    if not IsServer() then return end
    if not self.ability then return end
    
    local ability = event.ability
    local caster = event.unit
    
    -- 只统计玩家释放的技能
    if caster == self.parent and ability then
        -- 检查技能冷却时间是否不低于5秒
        if ability:GetCooldown(1) >= 5 then
            self.skill_count = self.skill_count + 1
            
            -- 每释放need次获得一灵能点
            if self.skill_count >= self.need then
                self.skill_count = 0
                self:GrowEvent()
            end
        end
    end
end
function modifier_item_act3_water:Advanced_GetModifierCooldownReduction()
    return self.ability:GetCurrentCharges()*self.point_cd
end

function modifier_item_act3_water:GrowEvent()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.ability:SetCurrentCharges(math.max(math.min(self.ability:GetCurrentCharges()+1, GetWave()*5), 1))
end

-- 纯净之水修饰器（免疫伤害）
modifier_item_act3_water_2 = advanced_modifier({})

function modifier_item_act3_water_2:IsHidden() return false end
function modifier_item_act3_water_2:IsDebuff() return false end
function modifier_item_act3_water_2:IsPurgable() return false end

function modifier_item_act3_water_2:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_item_act3_water_2:Advanced_GetModifierIncomingDamage_Percentage()
    return -100
end


----------------------
modifier_item_act3_water_3 = advanced_modifier({})

function modifier_item_act3_water_3:IsDebuff()				return true end
function modifier_item_act3_water_3:IsHidden() 			return true end
function modifier_item_act3_water_3:IsPurgable() 			return false end
function modifier_item_act3_water_3:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_item_act3_water_3:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_item_act3_water_3:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_item_act3_water_3:OnRefresh(keys) self:OnCreated(keys) end
function modifier_item_act3_water_3:IsMotionController() return true end
function modifier_item_act3_water_3:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_item_act3_water_3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_act3_water_3:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self.parent:GetAbsOrigin()):Length2D()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self.parent:GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end
function modifier_item_act3_water_3:OnIntervalThink()
	if not self:GetAbility() then self:SafeDestroy() return end
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 150
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self.parent:SetOrigin(next_pos)
end

function modifier_item_act3_water_3:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		self.pos = nil
		self.distance = nil 
	end
end