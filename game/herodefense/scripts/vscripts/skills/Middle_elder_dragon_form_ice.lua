
Middle_elder_dragon_form_ice = class({})
LinkLuaModifier("modifier_Middle_elder_dragon_form_ice_transform", "skills/Middle_elder_dragon_form_ice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_elder_dragon_form_ice_transform_nova", "skills/Middle_elder_dragon_form_ice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_elder_dragon_form_ice_transform_slow", "skills/Middle_elder_dragon_form_ice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_elder_dragon_form_ice_transform_cd", "skills/Middle_elder_dragon_form_ice", LUA_MODIFIER_MOTION_NONE)
function Middle_elder_dragon_form_ice:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
end
-- 施法效果
function Middle_elder_dragon_form_ice:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local pos = caster:GetAbsOrigin()
	-- 冰霜新星
	self:IceNova(pos,1)
	-- 注销老变身状态，并更换为新变身状态
	caster:GameTimer(0.2,function ()
		local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
		if modifier then
			modifier:SafeDestroy()
		end
		caster.Form_MODIFIER_NAME = "modifier_Middle_elder_dragon_form_ice_transform"
		-- 变龙
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		EmitSoundOn("Hero_DragonKnight.ElderDragonForm", caster)
		local duration = ability:GetSpecialValueFor("duration")	
		caster:AddNewModifier(caster, ability, "modifier_Middle_elder_dragon_form_ice_transform", {duration = duration})
	end)
end

function Middle_elder_dragon_form_ice:IceNova(pos, radius_index, duration_index)
	if not IsServer() then return end
    if not pos then return end
	local caster = self:GetCaster()
	-- 传参
    local radius_index = radius_index or 1
    local duration_index = duration_index or 1
    local radius = self:GetSpecialValueFor("nova_radius")*radius_index
    local duration = self:GetSpecialValueFor("nova_duration")*duration_index

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do 
        local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	    local StatusResistance = enemy:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
        enemy:AddNewModifier(caster,self,"modifier_Middle_elder_dragon_form_ice_transform_nova",{duration = duration*StatusResistance})
    end


	-- 音效和特效
    EmitSoundOnLocationWithCaster(pos, "Hero_Crystal.CrystalNova", caster)
    local particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",PATTACH_WORLDORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0, pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
    caster:GameTimer(2.2,function()
        ParticleManager:DestroyParticle(particle, true)
    end)

end
-------------------------------------------------------------------------------------------------------------------------------
modifier_Middle_elder_dragon_form_ice_transform = advanced_modifier({})
function modifier_Middle_elder_dragon_form_ice_transform:IsHidden()	return false end
function modifier_Middle_elder_dragon_form_ice_transform:IsPurgable()	return false end
function modifier_Middle_elder_dragon_form_ice_transform:IsDebuff()	return false end
function modifier_Middle_elder_dragon_form_ice_transform:GetPriority() return MODIFIER_PRIORITY_ULTRA-1 end
function modifier_Middle_elder_dragon_form_ice_transform:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
		
	return decFuncs	
end
-- 更改形态，更换弹道和攻击声音
function modifier_Middle_elder_dragon_form_ice_transform:GetModifierModelScale() 
    return 40
end
function modifier_Middle_elder_dragon_form_ice_transform:GetAttackSound()
	return "Hero_DragonKnight.ElderDragonShoot2.Attack"
end
function modifier_Middle_elder_dragon_form_ice_transform:GetModifierModelChange()
	return "models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl"
end
function modifier_Middle_elder_dragon_form_ice_transform:GetModifierProjectileName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
end
-- 改变攻击形态
function modifier_Middle_elder_dragon_form_ice_transform:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	if self.caster:Script_GetAttackRange() <= 500 then
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	else
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")*0.2
	end
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
    self.slow_radius = self.ability:GetSpecialValueFor("slow_radius")
    self.ice_outgoing = self.ability:GetSpecialValueFor("ice_outgoing")
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.cd = self.ability:GetSpecialValueFor("cd")

    if IsServer() then
		-- 如果单位不是远程单位 则改变为远程
		if self.caster.IsRanger==false then
			self.caster.RangerFrom = self.caster.RangerFrom +  1   --变更为远程形态的状态数加一
			self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
		-- 更改龙的形态为火龙
		self:GetCaster():GameTimer(0.01, function()
			self.caster:SetSkin(2)
		end)
    end
end
-- 退出变身，属性复原
function modifier_Middle_elder_dragon_form_ice_transform:OnDestroy()
    if IsServer() then    	
		local caster =self:GetCaster()
		--如果单位不是远程单位 则改变为远程
		if caster.IsRanger==false then
			caster.RangerFrom = caster.RangerFrom -  1   --变更为远程形态的状态数减一
			--如果没有远程形态状态了变回近战
			if caster.RangerFrom==0 then
				caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end	
		end
    end
end
-- 攻击力，攻击距离，弹道速度
function modifier_Middle_elder_dragon_form_ice_transform:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end
function modifier_Middle_elder_dragon_form_ice_transform:Advanced_GetModifierSpellAmplifyBonus() return self.bonus_spell_amp end
function modifier_Middle_elder_dragon_form_ice_transform:Advanced_GetModifierAttackRangeBonus() return  self.bonus_attack_range end
function modifier_Middle_elder_dragon_form_ice_transform:GetModifierProjectileSpeedBonus() return 200 end
function modifier_Middle_elder_dragon_form_ice_transform:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    if not IsIceDamage(keys) then return end
        
    return self.ice_outgoing
end
-- 技能冰霜
function modifier_Middle_elder_dragon_form_ice_transform:OnTakeDamage(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local unit = keys.unit
    local caster = self:GetCaster()
    if attacker ~= caster then return end
	if keys.inflictor == self.ability then return end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return end
    if caster:HasModifier("modifier_Middle_elder_dragon_form_ice_transform_cd") then return end

    local random = math.random
	if self.chance >= random(1,100) then
		self.ability:IceNova(unit:GetAbsOrigin(), 1, 1)

		attacker:AddNewModifier(caster, self.ability, "modifier_Middle_elder_dragon_form_ice_transform_cd", {duration = self.cd})
	end
	return 0
end
-- 溅射攻击
function modifier_Middle_elder_dragon_form_ice_transform:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	
	local attacker = keys.attacker
	local caster = self:GetCaster()
	local target = keys.target
	local ability = self:GetAbility()

	if attacker ~= caster then return end
	if attacker:IsInSpecialAttack() then return end
	

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self.slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy:IsAlive() then
            local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	        local StatusResistance = enemy:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, ability, "modifier_Middle_elder_dragon_form_ice_transform_slow",{duration = self.slow_duration*StatusResistance})
		end
	end
end

-------------------------------------------------
modifier_Middle_elder_dragon_form_ice_transform_nova = advanced_modifier({})
function modifier_Middle_elder_dragon_form_ice_transform_nova:IsHidden()	return false end
function modifier_Middle_elder_dragon_form_ice_transform_nova:IsPurgable()	return false end
function modifier_Middle_elder_dragon_form_ice_transform_nova:IsDebuff()	return true end
function modifier_Middle_elder_dragon_form_ice_transform_nova:CheckState()
    return{
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }	
end
-------------------------------------------------
modifier_Middle_elder_dragon_form_ice_transform_slow = advanced_modifier({})
function modifier_Middle_elder_dragon_form_ice_transform_slow:IsHidden()	return false end
function modifier_Middle_elder_dragon_form_ice_transform_slow:IsPurgable()	return false end
function modifier_Middle_elder_dragon_form_ice_transform_slow:IsDebuff()	return true end
function modifier_Middle_elder_dragon_form_ice_transform_slow:OnCreated()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("slow")
end
function modifier_Middle_elder_dragon_form_ice_transform_slow:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
function modifier_Middle_elder_dragon_form_ice_transform_slow:GetModifierMoveSpeedBonus_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return -self.slow
end

-------------------------------------------------------------------------------------------------------------------------------
modifier_Middle_elder_dragon_form_ice_transform_cd = advanced_modifier({})
function modifier_Middle_elder_dragon_form_ice_transform_cd:IsHidden()	return true end
function modifier_Middle_elder_dragon_form_ice_transform_cd:IsPurgable()	return false end
function modifier_Middle_elder_dragon_form_ice_transform_cd:IsDebuff()	return false end