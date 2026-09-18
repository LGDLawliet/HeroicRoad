
Advanced_eye_of_the_storm = class({})
LinkLuaModifier( "modifier_Advanced_eye_of_the_storm", "skills/Advanced_eye_of_the_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_eye_of_the_storm_buff", "skills/Advanced_eye_of_the_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_eye_of_the_storm_debuff", "skills/Advanced_eye_of_the_storm", LUA_MODIFIER_MOTION_NONE )

function Advanced_eye_of_the_storm:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_arcana/razor_arcana_v2_eye_of_the_storm.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eye_of_the_storm/main_effect.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_arcana/razor_arcana_eye_of_the_storm.vpcf", context )
end
function Advanced_eye_of_the_storm:GetCastRange(location , target)
	return self:GetSpecialValueFor("radius")
end
function Advanced_eye_of_the_storm:CheckKV(key)
	local table = {
		damage=0.08,
	}
	local value = table[key] or -1
	return value
end
function Advanced_eye_of_the_storm:UnlockFirstCore(key)
	return true
end
function Advanced_eye_of_the_storm:UnlockSecondCore(key)
	return true
end
function Advanced_eye_of_the_storm:UnlockThirdCore(key)
	return true
end
function Advanced_eye_of_the_storm:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )

    local already = caster:FindModifierByName("modifier_Advanced_eye_of_the_storm")
	if already then
		already:Destroy()
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_eye_of_the_storm", {duration = duration})
end

modifier_Advanced_eye_of_the_storm = advanced_modifier({})

function modifier_Advanced_eye_of_the_storm:IsHidden() return false end
function modifier_Advanced_eye_of_the_storm:IsDebuff() return false end
function modifier_Advanced_eye_of_the_storm:IsPurgable() return false end
function modifier_Advanced_eye_of_the_storm:OnCreated()
	self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.interval = self.ability:GetSpecialValueFor("interval")
    self.elecshocking = self.ability:GetSpecialValueFor("elecshocking")
	self.damage = self.ability:GetSpecialValueFor("damage")
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.armor_duration = self.ability:GetSpecialValueFor("armor_duration")
    self.armor_max = self.ability:GetSpecialValueFor("armor_max")
	self.attack = self.ability:GetSpecialValueFor("attack")
    self.attack_duration = self.ability:GetSpecialValueFor("attack_duration")
    self.attack_max = self.ability:GetSpecialValueFor("attack_max")
	self.level = self.ability:GetSpecialValueFor("advanced_level")
	self.count = self.ability:GetSpecialValueFor("count")

	self.unlocktype = nil
	if self.ability:GetUnlock(1)==1 then
		self.unlocktype = 1
	elseif self.ability:GetUnlock(2)==2 then
		self.unlocktype = 2
		self.interval = self.interval - 0.3
		self.armor = 10
		self.damage = 0
	elseif self.ability:GetUnlock(3)==3 then
		self.unlocktype = 3
		self.count = self.count + 15
	end

	if self.level >= 10 then
		self.interval = self.interval - 0.1
		self.count = self.count + 1
	end
    if IsServer() then
        self.strikes = 1 + self.count
        self.targets = {}

        self.damageTable = {
            -- victim = target,
            attacker = self.parent,
            -- damage = self.damage,
            damage_type = self.ability:GetAbilityDamageType(),
            ability = self.ability,
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
        }
        self:StartIntervalThink(self.interval)
        self:OnIntervalThink()
        self:PlayEffects1()
    end
end

function modifier_Advanced_eye_of_the_storm:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Razor.Storm.Loop"
	local sound_end = "Hero_Razor.StormEnd"
	StopSoundOn( sound_loop, self.parent )
	EmitSoundOn( sound_end, self.parent )
end
function modifier_Advanced_eye_of_the_storm:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_Advanced_eye_of_the_storm:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if IsServer() then
        if IsIceDamage(keys) or IsLightningDamage(keys) then
			if self.level < 5 then return end
            return 10
        end
    end
end
function modifier_Advanced_eye_of_the_storm:OnDeath(keys)
    if not IsServer() then return end
	local unit = keys.unit
    if not IsEnemy(unit, self.parent) then return end
	if CalculateDistance(unit, self.parent) > self.radius then return end

	local buff = self.parent:FindModifierByName("modifier_Advanced_eye_of_the_storm_buff")
	if buff then
		buff:SetStackCount(math.min(buff:GetStackCount() + self.attack, self.attack_max))
		buff:SetDuration(self.attack_duration, true)
	else
		local newbuff = self.parent:AddNewModifier(self.parent, self.ability, "modifier_Advanced_eye_of_the_storm_buff", {duration = self.attack_duration})
		newbuff:SetStackCount(self.attack)
	end
end
function modifier_Advanced_eye_of_the_storm:OnIntervalThink()
	local targets = {}
	local team = DOTA_UNIT_TARGET_TEAM_ENEMY
	if self.unlocktype==3 then
		team = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetOrigin() ,nil, self.radius, team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	if #enemies<1 then return end
    -- 排序，找到最弱的那个
	table.sort( enemies, function( left, right )
		return left:GetHealth() < right:GetHealth()
	end)
    
    -- 选择最多strikes个不同目标
    local targetCount = 0
	for _,enemy in pairs(enemies) do
		if targetCount < self.strikes then
			targets[enemy] = true
            targetCount = targetCount + 1
		else
            break
        end
	end

    if targetCount >= 1 then
		local damage_original = self.damage * self.parent:GetAverageTrueAttackDamage(nil)
        local baseDamage = self.damage * self.parent:GetAverageTrueAttackDamage(nil)
        if self.parent:HasModifier("modifier_Primary_enchant_totem") or self.parent:HasModifier("modifier_Middle_enchant_totem") or self.parent:HasModifier("modifier_Advanced_enchant_totem") then
            damage_original = damage_original *0.27
			baseDamage = baseDamage * 0.27
        end
		
        for enemy,_ in pairs(targets) do
			if self.unlocktype==3 and not IsEnemy(enemy, self.parent) then
				baseDamage = damage_original*0.005
			else
				baseDamage = damage_original
			end

			if self.level >= 15 then
				if enemy:GetHealthPercent() >= 95 then
					local buff = self.parent:FindModifierByName("modifier_Advanced_eye_of_the_storm_buff")
					if buff then
						buff:SetStackCount(math.min(buff:GetStackCount() + 2, self.attack_max))
						buff:SetDuration(self.attack_duration, true)
					else
						local newbuff = self.parent:AddNewModifier(self.parent, self.ability, "modifier_Advanced_eye_of_the_storm_buff", {duration = self.attack_duration})
						newbuff:SetStackCount(2)
					end
				end
			end
			
			self:PlayEffects2(enemy)
            enemy:Elecshocking(self.parent, self.ability, self.elecshocking)
            self.damageTable.victim = enemy
            self.damageTable.damage = baseDamage
			if baseDamage > 0 then
            	ApplyDamage(self.damageTable)
			end
            if enemy:IsAlive() then
                local debuff = enemy:FindModifierByName("modifier_Advanced_eye_of_the_storm_debuff")
                if debuff then
                    if debuff:GetStackCount() >= self.armor_max then
                        debuff:SetDuration(self.armor_duration, true)
                    else
                        debuff:SetStackCount(math.min(debuff:GetStackCount() + self.armor, self.armor_max))
                        debuff:SetDuration(self.armor_duration, true)
                    end
                else
                    local newdebuff = enemy:AddNewModifier(self.parent, self.ability, "modifier_Advanced_eye_of_the_storm_debuff", {duration = self.armor_duration})
                    newdebuff:SetStackCount(self.armor)
                end
            end

			if self.level >= 20 then
				local random = math.random
				if 25 >= random(1,100) then
					self.parent:GameTimer(0.3,function()
						if IsValid(self) and self:GetAbility() and self.parent:IsAlive() then
							local target = FindStrongestEnemyInRangeAndPosition(self.parent, self.parent:GetAbsOrigin(), self.radius, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES )
							if target then
								self:PlayEffects3(target)
								target:AddNewModifier(self.parent, self, "modifier_stunned", {duration = 0.3})
								local debuff = target:FindModifierByName("modifier_Advanced_eye_of_the_storm_debuff")
								if debuff then
									if debuff:GetStackCount() >= self.armor_max then
										debuff:SetDuration(self.armor_duration, true)
									else
										debuff:SetStackCount(math.min(debuff:GetStackCount() + 3*self.armor, self.armor_max))
										debuff:SetDuration(self.armor_duration, true)
									end
								else
									local newdebuff = target:AddNewModifier(self.parent, self.ability, "modifier_Advanced_eye_of_the_storm_debuff", {duration = self.armor_duration})
									newdebuff:SetStackCount(3*self.armor)
								end
							end

							if self.unlocktype==1 then
								local random = math.random
								if 50 >= random(1,100) then
									self.parent:GameTimer(0.3,function()
										if IsValid(self) and self:GetAbility() and self.parent:IsAlive() then
											local target = FindStrongestEnemyInRangeAndPosition(self.parent, self.parent:GetAbsOrigin(), self.radius, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES )
											if target then
												self:PlayEffects4(target)
												self.damageTable.victim = enemy
												self.damageTable.damage = baseDamage*4
												ApplyDamage(self.damageTable)
											end
										end
									end)
								end
							end
						end
					end)
				end
			end
        end
    end
end

function modifier_Advanced_eye_of_the_storm:PlayEffects1()
    local caster = self.parent
	local particle_cast = "particles/rebuild/spell/eye_of_the_storm/main_effect.vpcf"
	local sound_cast = "Hero_Razor.Storm.Cast"
	local sound_loop = "Hero_Razor.Storm.Loop"

	self.particle = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
	self:AddParticle( self.particle, false, false, -1, true, false )
	EmitSoundOn( sound_cast, self.parent )
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_Advanced_eye_of_the_storm:PlayEffects2( enemy )
	local particle_cast = "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf"
	local sound_cast = "Hero_razor.lightning"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() + Vector(0,0,1000) )
	ParticleManager:SetParticleControlEnt(effect_cast,1,enemy,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, enemy )
end

function modifier_Advanced_eye_of_the_storm:PlayEffects3( enemy )
	local particle_cast = "particles/econ/items/razor/razor_arcana/razor_arcana_v2_eye_of_the_storm.vpcf"
	local sound_cast = "Hero_razor.lightning"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() + Vector(0,0,1000) )
	ParticleManager:SetParticleControlEnt(effect_cast,1,enemy,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, enemy )
end

function modifier_Advanced_eye_of_the_storm:PlayEffects4( enemy )
	local particle_cast = "particles/econ/items/razor/razor_arcana/razor_arcana_eye_of_the_storm.vpcf"
	local sound_cast = "Hero_razor.lightning"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() + Vector(0,0,1000) )
	ParticleManager:SetParticleControlEnt(effect_cast,1,enemy,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, enemy )
end
---
modifier_Advanced_eye_of_the_storm_buff = advanced_modifier({})

function modifier_Advanced_eye_of_the_storm_buff:IsHidden() return false end
function modifier_Advanced_eye_of_the_storm_buff:IsDebuff() return false end
function modifier_Advanced_eye_of_the_storm_buff:IsPurgable() return false end
function modifier_Advanced_eye_of_the_storm_buff:GetTexture() return "razor_eye_of_the_storm" end
function modifier_Advanced_eye_of_the_storm_buff:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_Advanced_eye_of_the_storm_buff:OnTooltip() return self:GetStackCount() end
function modifier_Advanced_eye_of_the_storm_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_Advanced_eye_of_the_storm_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount()
end
---
modifier_Advanced_eye_of_the_storm_debuff = advanced_modifier({})

function modifier_Advanced_eye_of_the_storm_debuff:IsHidden() return false end
function modifier_Advanced_eye_of_the_storm_debuff:IsDebuff() return true end
function modifier_Advanced_eye_of_the_storm_debuff:IsPurgable() return false end
function modifier_Advanced_eye_of_the_storm_debuff:GetTexture() return "razor_eye_of_the_storm" end
function modifier_Advanced_eye_of_the_storm_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_Advanced_eye_of_the_storm_debuff:ADDeclareFunctions() return {advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_Advanced_eye_of_the_storm_debuff:Advanced_GetModifierPhysicalArmorBonus() return -self:GetStackCount() end
function modifier_Advanced_eye_of_the_storm_debuff:OnTooltip() return self:GetStackCount() end
