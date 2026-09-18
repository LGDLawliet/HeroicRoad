LinkLuaModifier("modifier_item_act2_wolf", "items/item_act2_wolf.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_wolf_charge_cd", "items/item_act2_wolf.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_wolf_charge_buff", "items/item_act2_wolf.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_wolf_charge_debuff", "items/item_act2_wolf.lua", LUA_MODIFIER_MOTION_NONE)
item_act2_wolf = class({})
function item_act2_wolf:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", context)
end
function item_act2_wolf:GetIntrinsicModifierName()
    return "modifier_item_act2_wolf"
end
function item_act2_wolf:Spawn()
    if IsServer() then
		self:SetCurrentCharges(1)
	end
end
function item_act2_wolf:GetBehavior()
    if self:GetCurrentCharges() >= self:GetSpecialValueFor("check2") then
       return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
    end
    return self.BaseClass.GetBehavior(self)
end

function item_act2_wolf:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local num2 = self:GetSpecialValueFor("num2")
    local modifier = caster:FindModifierByName("modifier_item_act2_wolf")
    
    -- Strong dispel
    caster:Purge(false, true, false, true, false)

    local direction = (point - caster:GetAbsOrigin())
    direction.z = 0
    direction = direction:Normalized()
    modifier:TriggerCharge(direction, caster:GetAbsOrigin())
    
    -- Additional charges
    for i = 1, num2 - 1 do
        local random_angle = RandomFloat(-30, 30)
        local random_distance = RandomFloat(-225, 225)
        local random_position = caster:GetAbsOrigin() + Vector(math.cos(math.rad(random_angle)), math.sin(math.rad(random_angle)), 0) * random_distance
        local delay = i * 0.2
        
        caster:GameTimer(delay, function()
            modifier:TriggerCharge(direction, random_position)
        end)
    end
end

----
modifier_item_act2_wolf = advanced_modifier({})

function modifier_item_act2_wolf:IsHidden() return true end
function modifier_item_act2_wolf:IsDebuff() return false end
function modifier_item_act2_wolf:IsPurgable() return false end
function modifier_item_act2_wolf:RemoveOnDeath() return false end

function modifier_item_act2_wolf:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.need = self.ability:GetSpecialValueFor("need")
    self.get = self.ability:GetSpecialValueFor("get")
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.line = self.ability:GetSpecialValueFor("line")
    self.move = self.ability:GetSpecialValueFor("move")
    self.move_down = self.ability:GetSpecialValueFor("move_down")
    self.length = self.ability:GetSpecialValueFor("length")
    self.bonus_length = self.ability:GetSpecialValueFor("bonus_length")
    self.radius = self.length + self.ability:GetCurrentCharges()*self.bonus_length
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.check1 = self.ability:GetSpecialValueFor("check1")
    self.bonus1 = self.ability:GetSpecialValueFor("bonus1")*0.01
    self.outgoing1 = self.ability:GetSpecialValueFor("outgoing1")
    self.duration1 = self.ability:GetSpecialValueFor("duration1")
    self:SetStackCount(0)
    if Game_State:IsInChaoticEra() then
        self.need = self.need*0.5
        print(self.need)
    end

    -- 同一个modifier下的damagetable要在oncreate的时候就创立，随后进行补充以节省性能
    if IsServer() then
        self.damagetable = {
            attacker = self.parent,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.ability,
            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
        }
        self.prevLoc = self.parent:GetAbsOrigin()
        self.move_dis = 0
        self:StartIntervalThink(0.03)
    end
end

function modifier_item_act2_wolf:OnIntervalThink()
    if not self:GetAbility() then return end

    local caster = self:GetCaster()
    local dis = CalculateDistance(self.prevLoc, self.parent)
    self.move_dis = self.move_dis + dis
    if self.move_dis >= self.move - self.ability:GetCurrentCharges()*self.move_down then
        local cd = self.parent:HasModifier("modifier_item_act2_wolf_charge_cd")
        if not cd then
            self.radius = self.length + self.ability:GetCurrentCharges()*self.bonus_length
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            if #enemies >= 1 then
                local target = enemies[1]
                local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin())
                direction.z = 0
                direction = direction:Normalized()
                self:TriggerCharge(direction, caster:GetAbsOrigin())
                self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act2_wolf_charge_cd", {duration = self.cd})
            end
        end
        self.move_dis = 0
    end
    self.prevLoc = self:GetParent():GetAbsOrigin()
end

function modifier_item_act2_wolf:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
    }
end

function modifier_item_act2_wolf:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if (not attacker) or (attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID()) then return end
    if not IsEnemy(unit, self.parent) then return end

    --如果击杀的单位名正确直接加点数，否则加进度
    if unit:GetUnitName() == "npc_monster_challenge_004" then
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

function modifier_item_act2_wolf:All_GainCharge()
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

function modifier_item_act2_wolf:Check_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do
        local ability = 
        hero:FindItemInInventory("item_act2_wolf")

        if ability then
            print("ITEM FOUND")
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end


function modifier_item_act2_wolf:TriggerCharge(direction, start_position)
    if not IsServer() then return end
    if not direction or not start_position then return end
    
    local caster = self.parent
    local ability = self.ability
    local damage = ability:GetCurrentCharges() * caster:HDGetPrimaryStatValue() * self.damage
    local duration = self.duration
    local speed = 3000
	local projectile_name = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf"
    self.radius = self.length + self.ability:GetCurrentCharges()*self.bonus_length
	local distance = self.radius+30
	local start_radius = 250
	local end_radius = 250

	local spawnPos = start_position
    local target_pos = spawnPos + direction* distance
	local info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = spawnPos,

	    bDeleteOnHit = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius =end_radius,
		vVelocity = direction * speed,

		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = true,
        ExtraData = {
            damage = damage,
            duration = duration,
        }
	}


    if self.ability:GetCurrentCharges() >= self.check1 then
        info.ExtraData.damage = info.ExtraData.damage *(1+self.bonus1)
        caster:AddNewModifier(caster, self.ability, "modifier_item_act2_wolf_charge_buff", {
            duration = self.duration1,
            outgoing1 = self.outgoing1
        })
    end

	local projectile = ProjectileManager:CreateLinearProjectile(info)
    caster:EmitSoundParams("Hero_Lycan.Howl",0,0.3,0)
    local enemies = FindUnitsInLine(caster:GetTeamNumber(), spawnPos, target_pos,nil, start_radius, info.iUnitTargetTeam, info.iUnitTargetType, info.iUnitTargetFlags)
    for _,enemy in pairs(enemies)do
        local distance = CalculateDistance(enemy,caster)
        local delay = distance/speed
        caster:GameTimer(delay,function()
            if enemy:IsAlive() and IsValid(self) then
                self.ability:OnProjectileHit_Item(enemy, info.ExtraData)
            end
        end)
    end
end

function item_act2_wolf:OnProjectileHit_Item(target, extraData)
    if not IsServer() then return end
    if not target then return end
    
    local caster = self:GetCaster()
    local damage = extraData.damage
    local duration = extraData.duration --破坏被动时长
    -- Apply damage
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = self,
        hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
    }
    ApplyDamage(damageTable)
    
    if target:IsAlive() then
        target:AddNewModifier(caster, self, "modifier_item_act2_wolf_charge_debuff", {duration = duration})
    end
end
-----
modifier_item_act2_wolf_charge_debuff = advanced_modifier({})

function modifier_item_act2_wolf_charge_debuff:IsHidden() return false end
function modifier_item_act2_wolf_charge_debuff:IsDebuff() return true end
function modifier_item_act2_wolf_charge_debuff:IsPurgable() return false end
function modifier_item_act2_wolf_charge_debuff:GetTexture() return "item_act2_wolf" end
function modifier_item_act2_wolf_charge_debuff:CheckState()
    return{
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end
-----
modifier_item_act2_wolf_charge_cd = advanced_modifier({})

function modifier_item_act2_wolf_charge_cd:IsHidden() return true end
function modifier_item_act2_wolf_charge_cd:IsDebuff() return false end
function modifier_item_act2_wolf_charge_cd:IsPurgable() return false end
function modifier_item_act2_wolf_charge_cd:RemoveOnDeath() return false end
function modifier_item_act2_wolf_charge_cd:GetTexture() return "item_act2_wolf" end

-----
modifier_item_act2_wolf_charge_buff = advanced_modifier({})

function modifier_item_act2_wolf_charge_buff:IsHidden() return false end
function modifier_item_act2_wolf_charge_buff:IsDebuff() return false end
function modifier_item_act2_wolf_charge_buff:IsPurgable() return false end
function modifier_item_act2_wolf_charge_buff:GetTexture() return "item_act2_wolf" end

function modifier_item_act2_wolf_charge_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

function modifier_item_act2_wolf_charge_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end

function modifier_item_act2_wolf_charge_buff:OnCreated(params)
    if IsServer() then
        self:SetStackCount(params.outgoing1)
    end
end 