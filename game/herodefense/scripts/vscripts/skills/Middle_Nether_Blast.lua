
Middle_Nether_Blast = class({})


LinkLuaModifier("modifier_Middle_Nether_Blast_debuff_pre", "skills/Middle_Nether_Blast", LUA_MODIFIER_MOTION_NONE)



function Middle_Nether_Blast:IsHiddenWhenStolen() 		return false end
function Middle_Nether_Blast:IsRefreshable() 			return true end
function Middle_Nether_Blast:IsStealable() 				return true end
function Middle_Nether_Blast:IsNetherWardStealable()	return true end
function Middle_Nether_Blast:GetAOERadius() return self:GetSpecialValueFor("radius") end

function Middle_Nether_Blast:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local delay = self:GetSpecialValueFor("delay")
	local pfx_pre_name = "particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf"
	local pfx_main_name = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
	local pfx_min = ParticleManager:CreateParticle(pfx_pre_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_min, 0, Vector(pos.x, pos.y, pos.z + 128))
	ParticleManager:SetParticleControl(pfx_min, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx_min)
	local ability = self


	Timers:CreateTimer(delay, function()
		if not ability or ability:IsNull() then
            return
        end
		local pfx_main = ParticleManager:CreateParticle(pfx_main_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_main, 0, Vector(pos.x, pos.y, pos.z + 128))
		ParticleManager:SetParticleControl(pfx_main, 1, Vector(radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(pfx_main)
		caster:EmitSound("Hero_Pugna.NetherBlast")
		local enemies_balst = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ememy_balst in pairs(enemies_balst) do
			local buff = ememy_balst:AddNewModifier(caster, self, "modifier_Middle_Nether_Blast_debuff_pre", {duration = 0.01})
			local dmg = self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("intelligence_index") * caster:GetIntellect(false)
			local damageTable = {
								victim = ememy_balst,
								attacker = self:GetCaster(),
								damage = dmg,
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
			ApplyDamage(damageTable)
			if buff then
				buff:SafeDestroy()
			end


		end
		return nil
	end
	)
end




modifier_Middle_Nether_Blast_debuff_pre = class({})

function modifier_Middle_Nether_Blast_debuff_pre:IsDebuff()			return true end
function modifier_Middle_Nether_Blast_debuff_pre:IsHidden() 			return false end
function modifier_Middle_Nether_Blast_debuff_pre:IsPurgable() 		return false end
function modifier_Middle_Nether_Blast_debuff_pre:IsPurgeException() 	return false end
function modifier_Middle_Nether_Blast_debuff_pre:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Middle_Nether_Blast_debuff_pre:OnCreated(keys)
	if IsServer() then
		self.reduce = -self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_pre")
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_pugna_2") then
			self.reduce = self.reduce * 2
		end
	end
end
function modifier_Middle_Nether_Blast_debuff_pre:GetModifierMagicalResistanceBonus() return self.reduce end

