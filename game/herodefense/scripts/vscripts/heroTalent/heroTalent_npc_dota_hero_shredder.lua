heroTalent_npc_dota_hero_shredder = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_shredder", "heroTalent/heroTalent_npc_dota_hero_shredder", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_shredder_effect", "heroTalent/heroTalent_npc_dota_hero_shredder", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_shredder:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_shredder"
end


function heroTalent_npc_dota_hero_shredder:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end


modifier_heroTalent_npc_dota_hero_shredder = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_shredder:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_shredder:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_shredder:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_shredder:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shredder:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_shredder:OnCreated(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.armor_damage = self:GetAbility():GetSpecialValueFor("armor_damage")
	self.limit = self:GetAbility():GetSpecialValueFor("limit")
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/timbersaw_telent/timbersaw_ti9_chakram_stay.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(500,0,0) )
		ParticleManager:SetParticleControl( self.nFXIndex, 15, Vector(250,229,0) )
		ParticleManager:SetParticleControl( self.nFXIndex, 16, Vector(1,0,0) )
	
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self.timer = 0
		self:StartIntervalThink(0.5)	
	end
end


function modifier_heroTalent_npc_dota_hero_shredder:OnIntervalThink()
	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
			
		end
		return
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/timbersaw_telent/timbersaw_ti9_chakram_stay.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(500,0,0) )
			ParticleManager:SetParticleControl( self.nFXIndex, 15, Vector(250,229,0) )
			ParticleManager:SetParticleControl( self.nFXIndex, 16, Vector(1,0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
	self.timer = self.timer +0.5
	if self.timer>=1 then
		local caster = self:GetCaster()
		self.timer = self.timer - 1
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
		local damageTable = {
			attacker = caster,
			damage = caster:GetPhysicalArmorValue(false)*self.armor_damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}
		
		for i, unit in pairs(units) do
			damageTable.victim = unit
			ApplyDamage(damageTable)
			if i>=self.limit then
				break
			end
		end
	end

end

function modifier_heroTalent_npc_dota_hero_shredder:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_heroTalent_npc_dota_hero_shredder:Advanced_GetModifierPhysicalArmorBonus()
	return self:GetParent():GetLevel()*self:GetAbility():GetSpecialValueFor("armor")
end