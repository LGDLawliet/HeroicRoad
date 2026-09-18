heroTalent_npc_dota_hero_sniper_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sniper_3", "heroTalent/heroTalent_npc_dota_hero_sniper_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sniper_3_debuff", "heroTalent/heroTalent_npc_dota_hero_sniper_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_sniper_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sniper_3"
end


function heroTalent_npc_dota_hero_sniper_3:ReleaseLaser(target)
	local caster = self:GetCaster()

	local pos = target:GetAttachmentOrigin(target:ScriptLookupAttachment( "attach_hitloc" ) )
	local vAttachmentSourcePos = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment( "attach_attack1" ) )
	local direction = (pos - vAttachmentSourcePos):Normalized()

	local target_pos = vAttachmentSourcePos+direction*math.max((CalculateDistance(pos,vAttachmentSourcePos)),800)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 9, vAttachmentSourcePos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)

	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 9, vAttachmentSourcePos+Vector(0,0,25) )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)
	local new_pos = RotatePosition(vAttachmentSourcePos, QAngle(0, 90, 0), vAttachmentSourcePos+caster:GetForwardVector()*25)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 9, new_pos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)
	local new_pos = RotatePosition(vAttachmentSourcePos, QAngle(0, -90, 0), vAttachmentSourcePos+caster:GetForwardVector()*25)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 9, new_pos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)

	caster:EmitSound("Hero_Tinker.LaserImpact")

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), vAttachmentSourcePos,target_pos,nil, 100,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)
	local damageTable =
	{
		-- victim = hitEnemy,
		attacker = caster,
		damage = caster:GetAverageTrueAttackDamage(nil)*3.5,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self,
	}
	
	for _, hitEnemy in pairs( tTargets ) do
		damageTable.victim = hitEnemy
		ApplyDamage( damageTable )
		
	end

end




-- function heroTalent_npc_dota_hero_sniper_3:OnProjectileHit_ExtraData(target, location, keys)
-- 	if not target then
-- 		return
-- 	end

-- 	local damageTable = {
-- 		victim = target,
-- 		attacker = self:GetCaster(),
-- 		damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*2.5,
-- 		damage_type = DAMAGE_TYPE_PHYSICAL,
-- 		ability = self, --Optional.
-- 	}

-- 	ApplyDamage(damageTable)
-- 	target:EmitSound("Hero_Sniper.AssassinateDamage")

-- end










modifier_heroTalent_npc_dota_hero_sniper_3 = class({})

function modifier_heroTalent_npc_dota_hero_sniper_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sniper_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sniper_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sniper_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sniper_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_sniper_3:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK,
    }
end
function modifier_heroTalent_npc_dota_hero_sniper_3:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
	end
end
function modifier_heroTalent_npc_dota_hero_sniper_3:OnAttack(keys)
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then	

		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() or not caster:IsApplyModifier() then
			return
		end
		local time = GameRules:GetGameTime()
		if self.timer>=time then
			return
		end
		local ability = self:GetAbility()
		if ability then	
			-- print("1111")
			self.timer = GameRules:GetGameTime() + 2
			-- keys.attacker:AttackNoEarlierThan( time, 9999)
			ability:ReleaseLaser(keys.target)
			caster:AddNewModifier(caster,self:GetAbility(),"modifier_heroTalent_npc_dota_hero_sniper_3_debuff",{duration = 2})
		end


	
		
		
		
		
	end
end





modifier_heroTalent_npc_dota_hero_sniper_3_debuff = class({})

function modifier_heroTalent_npc_dota_hero_sniper_3_debuff:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sniper_3_debuff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sniper_3_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sniper_3_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sniper_3_debuff:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_sniper_3_debuff:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}

	return state
end