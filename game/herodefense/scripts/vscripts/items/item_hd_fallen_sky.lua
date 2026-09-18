item_hd_fallen_sky = class({})
-- LinkLuaModifier("modifier_item_hd_fallen_sky_arua", "items/item_hd_fallen_sky", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_fallen_sky_arua_effect", "items/item_hd_fallen_sky", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_fallen_sky", "items/item_hd_fallen_sky", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_fallen_sky_stunned", "items/item_hd_fallen_sky", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_fallen_sky:GetIntrinsicModifierName()
	return "modifier_item_hd_fallen_sky"
end

function item_hd_fallen_sky:GetAOERadius() return 500 end

function item_hd_fallen_sky:GetCastRange()
	local caster = self:GetCaster()
	return math.min(2000,1000 + caster:GetCastRangeBonus())-caster:GetCastRangeBonus()

end

function item_hd_fallen_sky:OnSpellStart()


	local pos = self:GetCursorPosition()
	self:ApplyEffect(pos,false)
	
end


function item_hd_fallen_sky:ApplyEffect(pos,dontMove)
	local caster    =   self:GetCaster()
	if not dontMove then
		caster:AddNewModifier(caster, self, "modifier_item_hd_fallen_sky_arua_effect", {duration = 0.5})
	end
	-- caster:AddNewModifier(caster, self, "modifier_item_hd_fallen_sky_arua_effect", {duration = 0.5})

	local particle = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, Vector(pos.x,pos.y,pos.z+1024))
	ParticleManager:SetParticleControl(particle, 1, pos)
	ParticleManager:SetParticleControl(particle, 2, Vector(0.5,0,0))
	-- print(pos)
	-- ParticleManager:ReleaseParticleIndex(particle)
	
	Timers:CreateTimer(0.5, function()
		if not self or self:IsNull() then
			return
		end
		caster:EmitSound("DOTA_Item.MeteorHammer.Impact")
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		
		local damage = (caster:GetIntellect(false)+caster:GetStrength())*6
		
		if not dontMove then
			FindClearSpaceForUnit(caster, pos, true)
		end
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), pos, nil,  500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		for _, unit in pairs(units) do
			local damageTable = {
				victim = unit,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self, --Optional.
				}
			ApplyDamage(damageTable)
			local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			unit:AddNewModifier(caster, self, "modifier_item_hd_fallen_sky_stunned", {duration = 2*StatusResistance})

		end
	end)

end


modifier_item_hd_fallen_sky = advanced_modifier({})

function modifier_item_hd_fallen_sky:IsDebuff() return false end
function modifier_item_hd_fallen_sky:IsHidden() return true end
function modifier_item_hd_fallen_sky:IsPurgable() return false end



function modifier_item_hd_fallen_sky:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	if IsServer() then
		self.timer = GameRules:GetGameTime()
	end
end



function modifier_item_hd_fallen_sky:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_EVENT_ON_ATTACK_LANDED
	
	}
end


function modifier_item_hd_fallen_sky:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_fallen_sky:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_fallen_sky:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_fallen_sky:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end






function modifier_item_hd_fallen_sky:OnAttackLanded(keys)
	if IsServer() then

		local ability = self:GetAbility()
		if keys.attacker == self:GetParent() then

			local target =keys.target
			local caster = self:GetCaster()
			local pos = target:GetAbsOrigin()
			local timer =  GameRules:GetGameTime()
			if self.timer>=timer then
				return
			end
			if target:IsAlive() and caster:IsApplyModifier() and caster:RollRandom(5,1)  then
				ability:ApplyEffect(pos,true)
				self.timer = GameRules:GetGameTime() +1
			end
			


		end
	end
end



function modifier_item_hd_fallen_sky:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end


modifier_item_hd_fallen_sky_arua_effect = class({})

function modifier_item_hd_fallen_sky_arua_effect:IsDebuff()			return false end
function modifier_item_hd_fallen_sky_arua_effect:IsHidden() 		return true end
function modifier_item_hd_fallen_sky_arua_effect:IsPurgable() 		return false end
function modifier_item_hd_fallen_sky_arua_effect:IsPurgeException() return false end
function modifier_item_hd_fallen_sky_arua_effect:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

function modifier_item_hd_fallen_sky_arua_effect:OnCreated()
	if IsServer() then
		local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
		next_pos.z = next_pos.z +2000
		self:GetParent():SetOrigin(next_pos)
	end
end

function modifier_item_hd_fallen_sky_arua_effect:OnDestroy()
	if IsServer() then
		local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
		self:GetParent():SetOrigin(next_pos)
	end
end




modifier_item_hd_fallen_sky_stunned = class({})

function modifier_item_hd_fallen_sky_stunned:IsDebuff()			return true end
function modifier_item_hd_fallen_sky_stunned:IsHidden() 			return false end
function modifier_item_hd_fallen_sky_stunned:IsPurgable() 		return true end
function modifier_item_hd_fallen_sky_stunned:IsPurgeException() 	return true end
function modifier_item_hd_fallen_sky_stunned:IsStunDebuff() return true end
function modifier_item_hd_fallen_sky_stunned:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_item_hd_fallen_sky_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_item_hd_fallen_sky_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_hd_fallen_sky_stunned:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_item_hd_fallen_sky_stunned:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end
function modifier_item_hd_fallen_sky_stunned:GetTexture()return "item_fallen_sky" end