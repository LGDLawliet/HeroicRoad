heroTalent_npc_dota_hero_chaos_knight_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chaos_knight_3", "heroTalent/heroTalent_npc_dota_hero_chaos_knight_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_chaos_knight_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_chaos_knight_3"
end


-- function heroTalent_npc_dota_hero_chaos_knight_3:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return 1000 - caster:GetCastRangeBonus()

-- end

modifier_heroTalent_npc_dota_hero_chaos_knight_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_chaos_knight_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:OnCreated(keys)
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")*0.5
		self.max_count = self:GetAbility():GetSpecialValueFor("max_count")
		self.damage = 0
	end
	
end
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:OnRefresh(keys)
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")*0.5
		self.max_count = self:GetAbility():GetSpecialValueFor("max_count")
		self.damage = 0
	end
	
end



-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_chaos_knight_3:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_heroTalent_npc_dota_hero_chaos_knight_3:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return
	end
    if  self:GetAbility():IsCooldownReady() then
		-- print("keys.damage=",keys.damage)
		local pass = false
		if keys.damage>self.damage then
			-- print("伤害ok")
			pass = true
		else
			if self.chance >= RandomInt(1,100) then
				pass = true
			end
		end
		
		if pass  then
			local count = 1
			if self.chance >= RandomInt(1,100) then
				count = count + 1
				if self.chance >= RandomInt(1,100) then
					count = count + 1
				end
			end
			self:GetParent():GameTimer(0.06, function()
				if not IsValid(self) then
					return
				end
				if IsValid(keys.target) and keys.target:IsAlive() then
					count = count - 1
					local modifier_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave =0,
						iDisableSplit = 0,
				
					}
					self:PlayEffects( keys.target )
					local attackEffectRecord = self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
					self:GetParent():PerformAttack(keys.target, false, true, true, true, false, false, true)--对一单位执行攻击。
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end
					if count>=1 then
						return 0.06
					end
				end
			end)
				

			
		end
		self.damage = keys.damage
     end
end

function modifier_heroTalent_npc_dota_hero_chaos_knight_3:PlayEffects( target )
	-- get resource
	local sound_cast = "Hero_ChaosKnight.ChaosStrike"
	local pfx_name = "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
