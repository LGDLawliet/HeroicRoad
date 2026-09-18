
Middle_Eldwurm_soul_Aethrak = class({})


LinkLuaModifier("modifier_Middle_Eldwurm_soul_Aethrak", "skills/Middle_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Aethrak_effect", "skills/Middle_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)


function Middle_Eldwurm_soul_Aethrak:GetIntrinsicModifierName() return "modifier_Middle_Eldwurm_soul_Aethrak" end
function Middle_Eldwurm_soul_Aethrak:IsHiddenWhenStolen() 		return false end
function Middle_Eldwurm_soul_Aethrak:IsRefreshable() 			return true  end




modifier_Middle_Eldwurm_soul_Aethrak= class({})

function modifier_Middle_Eldwurm_soul_Aethrak:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Aethrak:IsHidden() 			return true end
function modifier_Middle_Eldwurm_soul_Aethrak:IsPurgable() 		return false end
function modifier_Middle_Eldwurm_soul_Aethrak:IsPurgeException() 	return false end


function modifier_Middle_Eldwurm_soul_Aethrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Eldwurm_soul_Aethrak_effect", {})

	
	end
end















modifier_Middle_Eldwurm_soul_Aethrak_effect = class({})

function modifier_Middle_Eldwurm_soul_Aethrak_effect:IsDebuff() return false end
function modifier_Middle_Eldwurm_soul_Aethrak_effect:IsHidden() return false end
function modifier_Middle_Eldwurm_soul_Aethrak_effect:IsPurgable() return false end
function modifier_Middle_Eldwurm_soul_Aethrak_effect:IsPurgeException() return false end
function modifier_Middle_Eldwurm_soul_Aethrak_effect:DestroyOnExpire()	return false end
function modifier_Middle_Eldwurm_soul_Aethrak_effect:GetTexture() return "soul_of_aethrak" end

function modifier_Middle_Eldwurm_soul_Aethrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = ability:GetSpecialValueFor("bonus_move_speed")
	self.damage_index = 1
end


function modifier_Middle_Eldwurm_soul_Aethrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		

	}
end


function modifier_Middle_Eldwurm_soul_Aethrak_effect:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end
function modifier_Middle_Eldwurm_soul_Aethrak_effect:GetModifierMoveSpeedBonus_Constant()	return self.bonus_move_speed end

function modifier_Middle_Eldwurm_soul_Aethrak_effect:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if self:GetRemainingTime()<0 and self:GetCaster():GetRandomEffect(10,INT_TYPE,1) >=RandomInt(1, 100) then
		--触发雷霆
		self:SetDuration(2, true)
		local caster = self:GetCaster()
		local damage = self:GetParent():GetDamageMax()*self.damage_index
		local target = keys.target
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
		local pos = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
		ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, 2000))
		ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		ParticleManager:ReleaseParticleIndex(particle)
		target:EmitSound("Hero_Zuus.LightningBolt")
		local damageTable = {
			victim = target,
			attacker = caster,
			damage =  damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = ability,
			}
		ApplyDamage(damageTable)

	end


	
end
