heroTalent_npc_dota_hero_arc_warden_2 = heroTalent_npc_dota_hero_arc_warden_2 or  class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker", "heroTalent/heroTalent_npc_dota_hero_arc_warden_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_arc_warden_2_buff", "heroTalent/heroTalent_npc_dota_hero_arc_warden_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_arc_warden_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/effect.vpcf", context )
end

function heroTalent_npc_dota_hero_arc_warden_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_arc_warden_2"
end
function heroTalent_npc_dota_hero_arc_warden_2:OnSpellStart()
	local caster = self:GetCaster()
	local particle = ParticleManager:CreateParticle("particles/rebuild/talent/arc_warden_2/cast_effect/effect.vpcf", PATTACH_CUSTOMORIGIN,nil)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
	DestroyParticleByDelay(particle,4)
	caster:EmitSound("Hero_ArcWarden.TempestDouble")

	CreateModifierThinker(caster, self, "modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker", {duration = self:GetSpecialValueFor("duration")}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
end

function heroTalent_npc_dota_hero_arc_warden_2:IsRefreshable()
	return false
end
function heroTalent_npc_dota_hero_arc_warden_2:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
---------------------------------------------------

modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker = class({})
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:IsAura()return true end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:OnCreated(keys)
	if IsServer() then
	
		local parent = self:GetParent()

		local particle = ParticleManager:CreateParticle("particles/rebuild/talent/arc_warden_2/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle, 0,parent:GetAbsOrigin())
		DestroyParticleByDelay(particle,self:GetAbility():GetSpecialValueFor("duration")+1)
	end
end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:OnDestroy(keys)
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetAuraRadius()return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetAuraDuration() return 0.05 end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetModifierAura()return "modifier_heroTalent_npc_dota_hero_arc_warden_2_buff" end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_thinker:GetAuraEntityReject(hEntity)

	local caster = self:GetCaster()
	if IsEnemy(caster,hEntity) then
		return false
	end
	if hEntity ~= self:GetCaster() then
		return true
	end
	return false
end

--------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_arc_warden_2_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:IsPurgable() 			return false end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:IsDebuff() return self.debuff end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:OnCreated(keys)
	if self:GetParent()~=self:GetCaster() then
		self.debuff = true
	end
	self.move = self:GetAbility():GetSpecialValueFor("move")
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	self.project = self:GetAbility():GetSpecialValueFor("project")
end

function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:GetModifierAttackSpeedBonus_Constant() return self:IsDebuff() and -self.speed or self.speed end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:GetModifierProjectileSpeedBonus() return self:IsDebuff() and -self.project or self.project end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:GetModifierMoveSpeedBonus_Constant() return  self:IsDebuff() and -self.move or self.move end
function modifier_heroTalent_npc_dota_hero_arc_warden_2_buff:GetModifierIgnoreMovespeedLimit() return   self:IsDebuff() and 0 or 1  end