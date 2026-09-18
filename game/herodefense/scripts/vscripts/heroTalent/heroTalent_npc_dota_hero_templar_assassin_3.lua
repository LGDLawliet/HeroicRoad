heroTalent_npc_dota_hero_templar_assassin_3 = heroTalent_npc_dota_hero_templar_assassin_3 or class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_templar_assassin_3", "heroTalent/heroTalent_npc_dota_hero_templar_assassin_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect", "heroTalent/heroTalent_npc_dota_hero_templar_assassin_3", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_templar_assassin_3:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_templar_assassin_3:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_templar_assassin_3:IsStealable() 				return true end
function heroTalent_npc_dota_hero_templar_assassin_3:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_templar_assassin_3:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_templar_assassin_3" end
-- particles/rebuild/talent/templar_assassin_2/effect/shockwave/effect.vpcf
function heroTalent_npc_dota_hero_templar_assassin_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/templar_assassin_3/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf", context )


end

function heroTalent_npc_dota_hero_templar_assassin_3:OnCustomDataSettlement()
	if (_G.GAME_SUCCESS or _G.GAME_ENDLESS_WAVE_COUNT>=1) and _G.GAME_Reincarnation_Wave>=1 then

		local heroes = GetAllRealHeroes()
		local table = {
			npc_dota_hero_sven = true,
			npc_dota_hero_phantom_assassin = true,
			npc_dota_hero_juggernaut = true,
			npc_dota_hero_ember_spirit = true,
			-- npc_dota_hero_sven = true,

		}
		local count = 0
		for _, unit in ipairs(heroes) do
			if table[unit:GetUnitName()] then
				count = count + 1
			end
		end
		if count>=4 then
			local caster = self:GetCaster()
			local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
			if modifier then
				modifier:UnlockCustomData("jedi_knight_1")
			end
		end
	end
end


-- jedi_knight_1

modifier_heroTalent_npc_dota_hero_templar_assassin_3 = modifier_heroTalent_npc_dota_hero_templar_assassin_3 or  advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_templar_assassin_3:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_templar_assassin_3:Advanced_GetModifierAttackRangeOverride() return  250 end


function modifier_heroTalent_npc_dota_hero_templar_assassin_3:OnCreated(keys)
	self.bonus_attack_speed = 20
    if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"jedi_knight_1") then
			self.bonus_attack_speed =23
		end
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
        self:StartIntervalThink(0.3)     
		self.caster.IsRanger = false
		self.caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK )
    end
end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算

	}
end






function modifier_heroTalent_npc_dota_hero_templar_assassin_3:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() or    parent.origin_model_name ~= parent:GetModelName()  then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/templar_assassin_3/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end

function modifier_heroTalent_npc_dota_hero_templar_assassin_3:Advanced_GetModifierAttackSpeedPercentage() 
    return self.bonus_attack_speed
end



function modifier_heroTalent_npc_dota_hero_templar_assassin_3:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect", {duration = 0.1})
		end
	end
end


function modifier_heroTalent_npc_dota_hero_templar_assassin_3:OnDamageCalculated(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local modifier = keys.target:FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect")
			if modifier then
				modifier:SafeDestroy()
			end
		end
	end
end


function modifier_heroTalent_npc_dota_hero_templar_assassin_3:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
    }

	return funcs

end


modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect = modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect:OnCreated()
	if IsServer() then
		
		local parent = self:GetParent()
		local effect = ParticleManager:CreateParticle( "particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		local pos = parent:GetOrigin()
		ParticleManager:SetParticleControl(effect,1,pos)
		ParticleManager:SetParticleControl(effect,3,pos+Vector(RandomInt(-30, 30),RandomInt(-30, 30),0))
		ParticleManager:ReleaseParticleIndex(effect)
	end

end


function modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_templar_assassin_3_effect:Advanced_GetModifierPhysicalArmorBonus()
    return -15
end
