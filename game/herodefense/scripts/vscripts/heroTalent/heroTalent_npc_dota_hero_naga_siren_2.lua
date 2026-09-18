heroTalent_npc_dota_hero_naga_siren_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_naga_siren_2", "heroTalent/heroTalent_npc_dota_hero_naga_siren_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff", "heroTalent/heroTalent_npc_dota_hero_naga_siren_2", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_naga_siren_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_naga_siren_2"
end

function heroTalent_npc_dota_hero_naga_siren_2:GetCastRange()
	local caster = self:GetCaster()
	return 400 - caster:GetCastRangeBonus()

end
function heroTalent_npc_dota_hero_naga_siren_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", context )

end
function heroTalent_npc_dota_hero_naga_siren_2:Spawn()
    self.achievement_count = 0
end
function heroTalent_npc_dota_hero_naga_siren_2:AddCount()
    self.achievement_count =  self.achievement_count+  1
end


function heroTalent_npc_dota_hero_naga_siren_2:OnCustomDataSettlement()
	if self.achievement_count>=1000 then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("rip_tide_rush_1")
		end
	end

end


modifier_heroTalent_npc_dota_hero_naga_siren_2 = class({})
function modifier_heroTalent_npc_dota_hero_naga_siren_2:IsDebuff()      return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_2:IsHidden()      return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_2:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_2:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_heroTalent_npc_dota_hero_naga_siren_2:OnCreated(keys)
	if IsServer() then
		self.damage_index = 0.35
		
		-- self.achievement_timer = GameRules:GetGameTime()
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"rip_tide_rush_1") then
			self.damage_index =self.damage_index +0.02
		end
	end
end

function modifier_heroTalent_npc_dota_hero_naga_siren_2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	
	self:IncrementStackCount()
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	local caster = self:GetCaster()
	if not caster:IsApplyModifier() then
		return
	end
	local pass = false
	if caster:HasModifier("modifier_item_hd_siren_clothing") then
		if caster:GetRandomEffect(10,INT_TYPE,1)>=RandomInt(1, 100) then
			pass = true
		end
	end
	if not pass then
		if self:GetStackCount()>=6 then
			self:SetStackCount(0)
			pass = true
		end
	end

	if pass then

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin())
		ParticleManager:SetParticleControl(effect_cast,1,Vector(400,0,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		-- caster:EmitSound("Hero_NagaSiren.RipTide.Precast")
		caster:EmitSound("Hero_NagaSiren.Riptide.Cast")
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #units<=0 then
			return
		end
		local damage = 0
		if caster:HasModifier("modifier_item_hd_siren_clothing") then
			damage = caster:GetAverageTrueAttackDamage(nil)*(self.damage_index+0.25)
		else
			damage = caster:GetAverageTrueAttackDamage(nil)*self.damage_index
		end
	
		local damageTable = {
			-- victim =keys.target,
			attacker = caster,
			damage =damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = ability, 
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, 
		}
	
		
		for i, unit in ipairs(units) do
			damageTable.victim = unit
			ApplyDamage( damageTable )
			unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff", {duration=4}) 
			if i>=5 then
				break
			end
		end
		ability:UseResources(true, true, true, true)
		ability:AddCount()

	end

	
end


modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:IsPurgable()	return true end
function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:OnCreated( kv )
	self.reduce = -math.min(math.floor(self:GetCaster():GetDamageMax()*0.02),40)
	if self:GetCaster():HasModifier("modifier_item_hd_siren_clothing") then
		self.reduce = self.reduce -10
	end
end

function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:OnRefresh( kv )
	self.reduce = -math.min(math.floor(self:GetCaster():GetDamageMax()*0.02),40)
	if self:GetCaster():HasModifier("modifier_item_hd_siren_clothing") then
		self.reduce = self.reduce -10
	end
end



function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_naga_siren_2_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.reduce
end