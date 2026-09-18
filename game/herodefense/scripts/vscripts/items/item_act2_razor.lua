LinkLuaModifier("modifier_item_act2_razor", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_razor_cd", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_razor_unstable_field", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_razor_unstable_current", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_razor_unstable_buff", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_razor_static_link", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_razor_static_link_debuff", "items/item_act2_razor.lua", LUA_MODIFIER_MOTION_NONE)


item_act2_razor = class({})

function item_act2_razor:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_razor/razor_static_link.vpcf", context)
end

function item_act2_razor:GetIntrinsicModifierName()
    return "modifier_item_act2_razor"
end
function item_act2_razor:Spawn()
    if IsServer() then
		self:SetCurrentCharges(1)
	end
end
function item_act2_razor:GetBehavior()
    if self:GetCurrentCharges() >= self:GetSpecialValueFor("check2") then
       return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
    end
    return self.BaseClass.GetBehavior(self)
end

function item_act2_razor:OnSpellStart()
    local caster = self:GetCaster()
    local duration2 = self:GetSpecialValueFor("duration2")
    local radius2 = self:GetSpecialValueFor("radius2")
    local max2 = self:GetSpecialValueFor("max2")
    
    -- Start interval think for static link
    caster:AddNewModifier(caster, self, "modifier_item_act2_razor_static_link", {
        duration = duration2,
        radius = radius2,
        max_targets = max2
    })
end

----
modifier_item_act2_razor = advanced_modifier({})

function modifier_item_act2_razor:IsHidden() return true end
function modifier_item_act2_razor:IsDebuff() return false end
function modifier_item_act2_razor:IsPurgable() return false end
function modifier_item_act2_razor:RemoveOnDeath() return false end

function modifier_item_act2_razor:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.need = self.ability:GetSpecialValueFor("need")
    self.get = self.ability:GetSpecialValueFor("get")
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.cdback = self.ability:GetSpecialValueFor("cdback")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration1 = self.ability:GetSpecialValueFor("duration1")
    self.down1 = self.ability:GetSpecialValueFor("down1")
    self.check1 = self.ability:GetSpecialValueFor("check1")
    self.check2 = self.ability:GetSpecialValueFor("check2")
    self:SetStackCount(0)
    if Game_State:IsInChaoticEra() then
        self.need = self.need*0.5
    end
end

function modifier_item_act2_razor:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
    }
end

function modifier_item_act2_razor:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if (not attacker) or (attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID()) then return end
    if not IsEnemy(unit, self.parent) then return end

    --如果击杀的单位名正确直接加点数，否则加进度
    if unit:GetUnitName() == "npc_monster_challenge_008" then
        self:Check_GainCharge()
    else
        self:SetStackCount(self:GetStackCount()+1)
    end
    --进度满足，点数+1
    if self:GetStackCount() >= self.need then
        self:All_GainCharge()
        self:SetStackCount(0)
    end
end

function modifier_item_act2_razor:All_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do

        local ability = 
        hero:FindItemInInventory("item_act2_nevermore")
        or hero:FindItemInInventory("item_act2_leshrac")
        or hero:FindItemInInventory("item_act2_razor")
        or hero:FindItemInInventory("item_act2_enigma")
        or hero:FindItemInInventory("item_act2_slark")
        or hero:FindItemInInventory("item_act2_wolf")

        if ability then
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_razor:Check_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do
        local ability = 
        hero:FindItemInInventory("item_act2_razor")

        if ability then
            print("ITEM FOUND")
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_razor:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel())<=1 then
		return
	end
	local caster = self:GetCaster()
	caster:GameTimer(0.2, function()
		if IsValid(self) then
			if IsValid(self:GetAbility()) then
                local ability = keys.ability
                if ability and IsValid(ability) then
                    -- 返还冷却
                    local remaining_cooldown = ability:GetCooldownTimeRemaining()
                    local refund_amount = remaining_cooldown * (self.cdback * 0.01)
                    ability:EndCooldown()
                    ability:StartCooldown(math.max(0, remaining_cooldown - refund_amount))
                
                
                    -- 触发不稳定电场
                    local cd = self.parent:HasModifier("modifier_item_act2_razor_cd")
                    if not cd then
                        self:TriggerUnstableCurrent()
                        self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act2_razor_cd", {duration = self.cd})
                    end
                end
			end
		end
	end)
end

function modifier_item_act2_razor:TriggerUnstableCurrent()
    if not IsServer() then return end
    
    local caster = self.parent
    local ability = self.ability
    local radius = self.radius
    local damage = ability:GetCurrentCharges() * caster:HDGetPrimaryStatValue() * self.damage

    caster:AddNewModifier(caster, ability, "modifier_item_act2_razor_unstable_field", {radius = radius, damage = damage})
    -- 如果达到check1点数，添加效果
    if ability:GetCurrentCharges() >= self.check1 then
        caster:AddNewModifier(caster, ability, "modifier_item_act2_razor_unstable_buff", {
            duration = self.duration1,
            down1 = self.down1
        })
    end
end
----------
modifier_item_act2_razor_unstable_field = advanced_modifier({})
function modifier_item_act2_razor_unstable_field:IsHidden() return true end
function modifier_item_act2_razor_unstable_field:IsDebuff() return false end
function modifier_item_act2_razor_unstable_field:IsPurgable() return false end
function modifier_item_act2_razor_unstable_field:IsPurgeException() return false end

function modifier_item_act2_razor_unstable_field:OnCreated(keys)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.iRadius = keys.radius
	self.iSpeed = keys.radius*1.5
    self.iDamage = keys.damage
    self.enemy_number = 0

	--imba
	self.tEnemies = {}
	self.iDur = 1   --控制移动方向
	self.fCurDis = 0
	self.iEffectWidth = 100
	if IsServer() then
		self.hCaster:EmitSound("Ability.PlasmaField")
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, self.hCaster:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_item_act2_razor_unstable_field:OnIntervalThink()
	if IsServer() then
        local ability = self:GetAbility()
        if self.hCaster:IsAlive() then
            --先将搜寻到的敌人插入表中
            local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil,
             self.fCurDis+self.iEffectWidth,
              DOTA_UNIT_TARGET_TEAM_ENEMY,
               DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for _, enemy in pairs(enemies) do
                --如果是正向
				if self.iDur == 1 then
					if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.hCaster)>=(self.fCurDis-self.iEffectWidth) then
						enemy.IsFlag = false
						table.insert(self.tEnemies, enemy)
                    end
                --否则为反向
                else
                    --判断当前特效的距离，如果小于敌人与施法者的距离
					if self.fCurDis <= CalculateDistance(enemy,self.hCaster) then
						if not IsInTable(enemy,self.tEnemies)then
							enemy.IsFlag = false
							table.insert(self.tEnemies, enemy)
						end
					end
				end
            end
            --敌人入表结束
            if self.tEnemies then
                --取出单位造成伤害，并将已伤害标记为true
				for _, enemy in pairs(self.tEnemies) do
					if not enemy.IsFlag then
                        self.enemy_number = self.enemy_number + 1
						local iDamage = self.iDamage
	
						local tDamage = {
							ability = ability,
							attacker = self.hCaster,
							victim = enemy,
							damage = iDamage,
							damage_type = ability:GetAbilityDamageType(),
                            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
						}
						ApplyDamage(tDamage)
                        if enemy:IsAlive() then
                            -- 添加眩晕和沉默效果
                            enemy:AddNewModifier(self.hCaster, ability, "modifier_item_act2_razor_unstable_current", {duration = 0.5})
                        end

						enemy.IsFlag = true
					end
				end
            end
            
            --伤害结束，移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则结束
            if self.fCurDis == self.iRadius then
                self:SafeDestroy()
            end
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)
		end
	end
end

function modifier_item_act2_razor_unstable_field:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
-----
modifier_item_act2_razor_cd = advanced_modifier({})

function modifier_item_act2_razor_cd:IsHidden() return true end
function modifier_item_act2_razor_cd:IsDebuff() return false end
function modifier_item_act2_razor_cd:IsPurgable() return false end
function modifier_item_act2_razor_cd:RemoveOnDeath() return false end

-----
modifier_item_act2_razor_unstable_current = advanced_modifier({})

function modifier_item_act2_razor_unstable_current:IsHidden() return true end
function modifier_item_act2_razor_unstable_current:IsDebuff() return true end
function modifier_item_act2_razor_unstable_current:IsPurgable() return false end

function modifier_item_act2_razor_unstable_current:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_SILENCED] = true
    }
end
-----
modifier_item_act2_razor_unstable_buff = advanced_modifier({})

function modifier_item_act2_razor_unstable_buff:IsHidden() return false end
function modifier_item_act2_razor_unstable_buff:IsDebuff() return false end
function modifier_item_act2_razor_unstable_buff:IsPurgable() return false end
function modifier_item_act2_razor_unstable_buff:GetTexture() return "item_act2_razor" end

function modifier_item_act2_razor_unstable_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_act2_razor_unstable_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_act2_razor_unstable_buff:Advanced_GetModifierDamageOutgoing_Percentage()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end
function modifier_item_act2_razor_unstable_buff:Advanced_GetModifierSpellAmplifyBonus()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end
function modifier_item_act2_razor_unstable_buff:GetModifierMoveSpeedBonus_Percentage()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end

function modifier_item_act2_razor_unstable_buff:OnCreated(params)
    if IsServer() then
        self:SetStackCount(params.down1)
    end
end
-----
modifier_item_act2_razor_static_link = advanced_modifier({})

function modifier_item_act2_razor_static_link:IsHidden() return false end
function modifier_item_act2_razor_static_link:IsDebuff() return false end
function modifier_item_act2_razor_static_link:IsPurgable() return false end
function modifier_item_act2_razor_static_link:GetTexture() return "item_act2_razor" end

function modifier_item_act2_razor_static_link:OnCreated(params)
    if not IsServer() then return end
    self.radius = params.radius
    self.max_targets = params.max_targets
    self.linked_units = {}  -- 改为数组形式
    self.linked_count = 0   -- 添加计数器
    self:StartIntervalThink(0.5)
end

function modifier_item_act2_razor_static_link:OnIntervalThink()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local outgoing2 = ability:GetSpecialValueFor("outgoing2")
    
    -- 清理超出范围的单位
    for i = #self.linked_units, 1, -1 do
        local unit = self.linked_units[i]
        if not unit:IsNull() and unit:IsAlive() then
            local distance = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
            if distance > self.radius then
                unit:RemoveModifierByName("modifier_item_act2_razor_static_link_debuff")
                table.remove(self.linked_units, i)
                self.linked_count = self.linked_count - 1
            end
        else
            unit:RemoveModifierByName("modifier_item_act2_razor_static_link_debuff")
            table.remove(self.linked_units, i)
            self.linked_count = self.linked_count - 1
        end
    end
    
    -- 寻找新目标
    self:SetStackCount(self.linked_count * outgoing2)
    --print("Linked units count: " .. self.linked_count)
    
    if self.linked_count < self.max_targets then
        local units = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )
        
        for _, unit in pairs(units) do
            if not IsInTable(unit, self.linked_units) and self.linked_count < self.max_targets then
                table.insert(self.linked_units, unit)
                self.linked_count = self.linked_count + 1
                unit:AddNewModifier(caster, ability, "modifier_item_act2_razor_static_link_debuff", {duration = 1000})
            end
        end
    end
end

function modifier_item_act2_razor_static_link:OnDestroy()
    if not IsServer() then return end
    
    -- 清理所有链接
    for _, unit in ipairs(self.linked_units) do
        if not unit:IsNull() and unit:IsAlive() then
            unit:RemoveModifierByName("modifier_item_act2_razor_static_link_debuff")
        end
    end
end

function modifier_item_act2_razor_static_link:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_item_act2_razor_static_link:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end

-----
modifier_item_act2_razor_static_link_debuff = advanced_modifier({})

function modifier_item_act2_razor_static_link_debuff:IsHidden() return true end
function modifier_item_act2_razor_static_link_debuff:IsDebuff() return true end
function modifier_item_act2_razor_static_link_debuff:IsPurgable() return false end
function modifier_item_act2_razor_static_link_debuff:OnCreated(params)
    self.ability = self:GetAbility()
    self.outgoing2 = self.ability:GetSpecialValueFor("outgoing2")
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    if IsServer() then 
        -- 创建静电链接特效
        self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        --ParticleManager:ReleaseParticleIndex(self.particle)
    end
end

function modifier_item_act2_razor_static_link_debuff:OnDestroy(params)
    if IsServer() then 
        ParticleManager:DestroyParticle(self.particle, false)
    end
end


