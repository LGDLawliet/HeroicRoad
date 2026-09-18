item_hd_balnock_spear = class({})
-- LinkLuaModifier("modifier_item_hd_balnock_spear_arua", "items/item_hd_balnock_spear", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_spear_arua_effect", "items/item_hd_balnock_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_balnock_spear", "items/item_hd_balnock_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_balnock_spear_passive", "items/item_hd_balnock_spear", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')

function item_hd_balnock_spear:GetIntrinsicModifierName()
	return "modifier_item_hd_balnock_spear"
end
function item_hd_balnock_spear:OnSpellStart()
	if not IsServer() then
		return
	end
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByName("modifier_item_hd_balnock_spear_passive")
		if modifier then
			local target = enemy
			local caster = self:GetCaster()
			if target:IsAlive() then
				
				local pos = target:GetAbsOrigin()
				local count =  modifier:GetStackCount()
				if count == 0 then--有modifier但是没有层数，也就是事实意义上的1层
					count = 1
				end

				local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, pos)
				ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
				ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
				
				target:GameTimer(0.2, function()
					if not target or target:IsNull() or not caster or caster:IsNull() then
						return
					end

					target:EmitSound("Hero_Disruptor.ThunderStrike.Target")
					local damageTable = {
						victim = target,
						attacker = caster,
						damage = caster:GetAverageTrueAttackDamage(nil) * self:GetSpecialValueFor("damage_index")*count ,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
					ApplyDamage(damageTable)
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)

					target:RemoveModifierByNameAndCaster("modifier_item_hd_balnock_spear_passive", caster)
				end)
			end
		end
	end
end
--------------------------------------------------------------------------------------------

modifier_item_hd_balnock_spear = advanced_modifier({})

function modifier_item_hd_balnock_spear:IsDebuff() return false end
function modifier_item_hd_balnock_spear:IsHidden() return true end
function modifier_item_hd_balnock_spear:IsPurgable() return false end


function modifier_item_hd_balnock_spear:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	
end

function modifier_item_hd_balnock_spear:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},                    --攻击降临	
	}
end
function modifier_item_hd_balnock_spear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end
function modifier_item_hd_balnock_spear:GetModifierMoveSpeedBonus_Constant()	return self.bonus_move end
function modifier_item_hd_balnock_spear:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_item_hd_balnock_spear:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local target = keys.target
			local caster = keys.attacker
			target:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_balnock_spear_passive", {})
		end
	end
end

--------------------------------------------------------------------------------------------

modifier_item_hd_balnock_spear_passive = advanced_modifier({})

function modifier_item_hd_balnock_spear_passive:IsDebuff() return true end
function modifier_item_hd_balnock_spear_passive:IsHidden() return false end
function modifier_item_hd_balnock_spear_passive:IsPurgable() return false end
function modifier_item_hd_balnock_spear_passive:GetTexture() return "item_balnock_spear" end



function modifier_item_hd_balnock_spear_passive:OnCreated(keys)
    self.ability = self:GetAbility()
	self.damage_index = self.ability:GetSpecialValueFor("damage_index")
	self.max_count = self.ability:GetSpecialValueFor("max_count")
end
function modifier_item_hd_balnock_spear_passive:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.damage_index = self.ability:GetSpecialValueFor("damage_index")
	self.max_count = self.ability:GetSpecialValueFor("max_count")

	self:SetStackCount(math.min((self:GetStackCount() + 1),self.max_count))
end



-------------------------------------------------------------------------
