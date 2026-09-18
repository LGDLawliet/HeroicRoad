heroTalent_npc_dota_hero_lion = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lion", "heroTalent/heroTalent_npc_dota_hero_lion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lion_effect", "heroTalent/heroTalent_npc_dota_hero_lion", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_lion:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_lion"
end
function heroTalent_npc_dota_hero_lion:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end


modifier_heroTalent_npc_dota_hero_lion = class({})

function modifier_heroTalent_npc_dota_hero_lion:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_lion:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_lion:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_lion:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_lion:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_lion:OnCreated(keys)
	if IsServer() then
		self.mana_line_self = self:GetAbility():GetSpecialValueFor("mana_line_self")
		self.mana_line_ally = self:GetAbility():GetSpecialValueFor("mana_line_ally")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.5)
	end

end



function modifier_heroTalent_npc_dota_hero_lion:OnIntervalThink()
	if self:GetAbility():GetAutoCastState() then
		local caster = self:GetParent()
		if not caster:IsAlive() then
			return
		end
		if caster:GetManaPercent() <= self.mana_line_self then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, unit in ipairs(units) do
				if unit~=caster and unit:GetMana()>=self.mana_line_ally  then
					unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_lion_effect", {duration = 0.8})
					break
				end
			end
		end
	
	end


end





modifier_heroTalent_npc_dota_hero_lion_effect = class({})

function modifier_heroTalent_npc_dota_hero_lion_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_lion_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_lion_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_lion_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_lion_effect:RemoveOnDeath() return false end



function modifier_heroTalent_npc_dota_hero_lion_effect:OnCreated(keys)
	if IsServer() then
		
		

		local caster = self:GetCaster()
		local target = self:GetParent()
		local pfx_name ="particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_mouth", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_mouth", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		self:StartIntervalThink(0.1)
		caster:EmitSound("Hero_Lion.ManaDrain")
		
	end
end	

function modifier_heroTalent_npc_dota_hero_lion_effect:OnIntervalThink()
	if IsServer() then
		self.speed_int_index = self:GetAbility():GetSpecialValueFor("speed_int_index")
		
		self.gain = self:GetCaster():GetIntellect(false)*self.speed_int_index*0.1
		self.lose = self.gain*0.5

		self:GetParent():Script_ReduceMana(self.lose,self:GetAbility())
		self:GetCaster():GiveMana(self.gain)
	end
end

function modifier_heroTalent_npc_dota_hero_lion_effect:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end	


