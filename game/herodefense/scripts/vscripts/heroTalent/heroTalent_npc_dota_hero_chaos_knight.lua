LinkLuaModifier("modifier_heroTalent_npc_dota_hero_chaos_knight", "heroTalent/heroTalent_npc_dota_hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed", "heroTalent/heroTalent_npc_dota_hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_chaos_knight_silence", "heroTalent/heroTalent_npc_dota_hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_chaos_knight_broken", "heroTalent/heroTalent_npc_dota_hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_chaos_knight_all", "heroTalent/heroTalent_npc_dota_hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune", "heroTalent/heroTalent_npc_dota_hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_chaos_knight = class({})

function heroTalent_npc_dota_hero_chaos_knight:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_chaos_knight/chaos_knight_bolt_msg.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", context)
	PrecacheResource("particle", "particles/items_fx/black_king_bar_avatar.vpcf", context)
end

function heroTalent_npc_dota_hero_chaos_knight:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_chaos_knight"
end

function heroTalent_npc_dota_hero_chaos_knight:OnProjectileHit_ExtraData(target, location, extradata)
	if not IsServer() then return end
    if not target then return end

	local damage = math.floor(extradata.damage) -- 保证整数
    ApplyDamage({
        victim = target,
        attacker = self:GetCaster(),
        ability = self,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
		hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
    })


	local particle_target = "particles/units/heroes/hero_chaos_knight/chaos_knight_bolt_msg.vpcf"
	local sound_target = "Hero_ChaosKnight.ChaosBolt.Impact"

	local digit = tostring(damage):len()
	local number = damage

	local nFXIndex = ParticleManager:CreateParticle(particle_target, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(nFXIndex, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(0, number, 6))
	ParticleManager:SetParticleControl(nFXIndex, 2, Vector(2, digit+1, 0))
	ParticleManager:SetParticleControl(nFXIndex, 3, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(nFXIndex, 4, Vector(0, 0, 0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	EmitSoundOn(sound_target, target)
end

-- 主被动管理modifier
modifier_heroTalent_npc_dota_hero_chaos_knight = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_chaos_knight:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_chaos_knight:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.radius_1 = self.ability:GetSpecialValueFor("radius_1")
    self.max_1 = self.ability:GetSpecialValueFor("max_1")
    self.radius_1p = self.ability:GetSpecialValueFor("radius_1p")
    self.max_1p = self.ability:GetSpecialValueFor("max_1p")
    self.damage_index_1 = self.ability:GetSpecialValueFor("damage_index_1")
    self.incoming_2 = self.ability:GetSpecialValueFor("incoming_2")
    self.duration_3 = self.ability:GetSpecialValueFor("duration_3")
    self.damage_min = self.ability:GetSpecialValueFor("damage_min")
    self.damage_max = self.ability:GetSpecialValueFor("damage_max")
    self.duration_2 = self.ability:GetSpecialValueFor("duration_2")
    self.stun_duration_3 = self.ability:GetSpecialValueFor("stun_duration_3")

	self.talentgain_1 = self.ability:GetTalentGain(0.6)
	self.talentgain_2 = self.ability:GetTalentGain(1)
	self.damage_min_t = self.damage_min*self.talentgain_2
	self.damage_max_t = self.damage_max*self.talentgain_2
	self.duration_2_t = self.duration_2*self.talentgain_1
	self.stun_duration_3_t = self.stun_duration_3*self.talentgain_1

	if IsServer() then
		self.projectile_info = {
			--Target = target,
			Source = self:GetCaster(),
			Ability = self.ability,	
			EffectName = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
			iMoveSpeed = 700,
			--vSourceLoc = self:GetCaster():GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = false,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = true, --提供视野
			ExtraData = {}
		}
	end
end
function modifier_heroTalent_npc_dota_hero_chaos_knight:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_heroTalent_npc_dota_hero_chaos_knight:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_heroTalent_npc_dota_hero_chaos_knight:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
	local random = math.random
    if attacker ~= self.parent then return end
    if not target or not target:IsAlive() then return end
	if not self.ability:IsCooldownReady() then return end

	local value = random(1,100)
    if self.chance < value then return end

	self.talentgain_1 = self.ability:GetTalentGain(0.6)
	self.talentgain_2 = self.ability:GetTalentGain(1)
	self.ability:UseResources(true, true, true, true)
    -- 随机三种效果
    local effect = RandomInt(1, 3)
    local is_extreme = (value == self.chance) or (value == 1)
	if is_extreme == true then
		attacker:EmitSound("CNY_Beast.HandOfGodHealHero")
	end

    if effect == 1 then
        -- 混乱箭雨
		self.damage_min_t = self.damage_min*self.talentgain_2
		self.damage_max_t = self.damage_max*self.talentgain_2
		local rand_val = RandomFloat(self.damage_min_t, self.damage_max_t)
        local radius = (is_extreme and self.radius_1p) or self.radius_1
        local max_targets = (is_extreme and self.max_1p) or self.max_1
        local damage_pct = (is_extreme and self.damage_index_1) or 100
        local enemies = FindUnitsInRadius(
            self.parent:GetTeamNumber(),
            target:GetAbsOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false
        )
		local hero_level = self.parent:GetLevel()
		local str = self.parent:GetStrength()
		local base_damage = hero_level * str * rand_val * (damage_pct/100)

		local info = {
			--Target = enemy,
			Source = self.parent,
			Ability = self.ability,
			EffectName = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
			iMoveSpeed = 700,
			vSourceLoc = self.parent:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = true,
			ExtraData = {damage = base_damage}
		}
        for i,enemy in pairs(enemies) do
			if target ~= enemy then
				info.Target = enemy
				ProjectileManager:CreateTrackingProjectile(info)
				if i >= max_targets then
					break
				end
			end
        end
		info.Target = target
		ProjectileManager:CreateTrackingProjectile(info)

		local sound_cast = "Hero_ChaosKnight.ChaosBolt.Cast"
		EmitSoundOn(sound_cast, self:GetCaster())
		
    elseif effect == 2 then
        -- 实相打击
		self.duration_2_t = self.duration_2*self.talentgain_1
		local duration = target:GetHDStatusResistanceIndex(0.6)*self.duration_2_t
        if is_extreme then
            -- 强化：全部效果+易伤
            target:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed", {duration = duration})
            target:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_chaos_knight_silence", {duration = duration})
            target:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_chaos_knight_broken", {duration = duration})
            target:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_chaos_knight_all", {duration = duration, incoming = self.incoming_2})
        else
            local debuffs = {"modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed", "modifier_heroTalent_npc_dota_hero_chaos_knight_silence", "modifier_heroTalent_npc_dota_hero_chaos_knight_broken"}
            local debuff = debuffs[RandomInt(1, #debuffs)]
            target:AddNewModifier(self.parent, self.ability, debuff, {duration = duration})
        end
        -- 特效
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", PATTACH_WORLDORIGIN , target)
		local pos = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle_cast_fx, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(particle_cast_fx, 2,target:GetForwardVector())  --方向
		ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(particle_cast_fx, false)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end)

		target:EmitSound("Hero_ChaosKnight.RealityRift")
    elseif effect == 3 then
        -- 天劫重踏
		self.stun_duration_3_t = self.stun_duration_3*self.talentgain_1
        local enemies = FindUnitsInRadius(
            self.parent:GetTeamNumber(),
            self.parent:GetAbsOrigin(),
            nil,
            self.radius_1,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false
        )
        for _,enemy in pairs(enemies) do
			local duration = target:GetHDStatusResistanceIndex(0.6)*self.stun_duration_3_t
            enemy:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = duration})
        end
        self.parent:Purge(false, true, false, false, false)
        if is_extreme then
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune", {duration = self.duration_3})
        end
        -- 特效
		local caster = self:GetCaster()
		local particle_cast = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
		local sound_cast = "Hero_Centaur.HoofStomp"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius_1, self.radius_1, self.radius_1) )
		ParticleManager:SetParticleControlEnt(effect_cast,2,caster,PATTACH_POINT_FOLLOW,"attach_hoof_L",caster:GetOrigin(),true)
		ParticleManager:SetParticleControlEnt(effect_cast,2,caster,PATTACH_POINT_FOLLOW,"attach_hoof_R",caster:GetOrigin(),true)
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOnLocationWithCaster( caster:GetOrigin(), sound_cast, caster )
    end
end

function modifier_heroTalent_npc_dota_hero_chaos_knight:OnTooltip(keys)
	self.talentgain_1 = self.ability:GetTalentGain(0.6)
	self.talentgain_2 = self.ability:GetTalentGain(1)
	self.damage_min_t = self.damage_min*self.talentgain_2
	self.damage_max_t = self.damage_max*self.talentgain_2
	self.duration_2_t = self.duration_2*self.talentgain_1
	self.stun_duration_3_t = self.stun_duration_3*self.talentgain_1

	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self.damage_min_t*self.parent:GetLevel()
	end
	if self._tooltip == 2 then
		return  self.damage_max_t*self.parent:GetLevel()
	end
	if self._tooltip == 3 then
		return  self.duration_2_t
	end
	if self._tooltip == 4 then
		return self.stun_duration_3_t
	end
end

modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_disarmed:CheckState()
    return {[MODIFIER_STATE_DISARMED] = true}
end

modifier_heroTalent_npc_dota_hero_chaos_knight_silence = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_chaos_knight_silence:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_silence:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_silence:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_silence:CheckState()
    return {[MODIFIER_STATE_SILENCED] = true}
end

modifier_heroTalent_npc_dota_hero_chaos_knight_broken = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_chaos_knight_broken:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_broken:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_broken:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_broken:CheckState()
    return {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
end

modifier_heroTalent_npc_dota_hero_chaos_knight_all = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_chaos_knight_all:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_all:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_all:IsPurgable() return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_all:OnCreated(kv)
    if not IsServer() then return end
    self.incoming = kv.incoming or 0
	self:SetStackCount(self.incoming)
end
function modifier_heroTalent_npc_dota_hero_chaos_knight_all:ADDeclareFunctions()
    return {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function modifier_heroTalent_npc_dota_hero_chaos_knight_all:Advanced_GetModifierIncomingDamage_Percentage()
    return self:GetStackCount()
end

modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune:OnCreated(keys)
    if not IsServer() then return end
    self.effect = ParticleManager:CreateParticle("particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(self.effect, false, false, -1, false, false)
end
function modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune:OnDestroy()
    if not IsServer() then return end
    if self.effect then
        ParticleManager:DestroyParticle(self.effect, false)
        ParticleManager:ReleaseParticleIndex(self.effect)
    end
end
function modifier_heroTalent_npc_dota_hero_chaos_knight_magic_immune:CheckState()
     return {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
 end

