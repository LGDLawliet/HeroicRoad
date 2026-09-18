item_hd_aghanims_shard = class({})

-- LinkLuaModifier("modifier_item_hd_aghanims_shard", "items/item_hd_aghanims_shard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_aghanims_shard_active", "items/item_hd_aghanims_shard", LUA_MODIFIER_MOTION_NONE)


function item_hd_aghanims_shard:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ultimate_scepter/effect.vpcf", context )
end

-- function item_hd_aghanims_shard:GetIntrinsicModifierName()
-- 	return "modifier_item_hd_aghanims_shard"
-- end

function item_hd_aghanims_shard:OnSpellStart()

	local caster    =   self:GetCaster()
	if caster:HasModifier("modifier_item_hd_aghanims_shard_active") then
		return
	end
	local pass = false
	for i=0, caster:GetAbilityCount() - 1 do
		local Ability = caster:GetAbilityByIndex(i)
		if Ability ~= nil then
			if Ability:GetSpecialValueFor("advanced_level")>=1 then
				skillshop:UpgradeAbilitiesPassLV25AndExp(Ability,100)
				skillshop:UpgradeAbilitiesPassLV25AndExp(Ability,100)
				skillshop:UpgradeAbilitiesPassLV25AndExp(Ability,100)
				skillshop:UpgradeAbilitiesPassLV25AndExp(Ability,100)
				skillshop:UpgradeAbilitiesPassLV25AndExp(Ability,100)

				pass = true
				break
			end
		end
	end


	if pass then
		local particle = ParticleManager:CreateParticle("particles/rebuild/items/ultimate_scepter/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,500))
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		DestroyParticleByDelay(particle,3)
		caster:AddNewModifier(caster, self, "modifier_item_hd_aghanims_shard_active", {})
		caster:EmitSound("hud.equip.agh_scepter")
		self:SpendCharge(0)

	end


end

-- modifier_item_hd_aghanims_shard = class({})

-- function modifier_item_hd_aghanims_shard:IsDebuff() return false end
-- function modifier_item_hd_aghanims_shard:IsHidden() return true end
-- function modifier_item_hd_aghanims_shard:IsPurgable() return false end
-- function modifier_item_hd_aghanims_shard:IsPurgeException() return false end


modifier_item_hd_aghanims_shard_active = class({})

function modifier_item_hd_aghanims_shard_active:IsDebuff() return false end
function modifier_item_hd_aghanims_shard_active:IsHidden() return false end
function modifier_item_hd_aghanims_shard_active:IsPurgable() return false end
function modifier_item_hd_aghanims_shard_active:IsPurgeException() return false end
function modifier_item_hd_aghanims_shard_active:RemoveOnDeath() return false end
function modifier_item_hd_aghanims_shard_active:GetTexture() return "item_aghanims_shard"  end