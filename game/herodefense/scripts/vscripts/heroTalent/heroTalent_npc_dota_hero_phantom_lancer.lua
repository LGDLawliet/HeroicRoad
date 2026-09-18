LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_move", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_buff", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)





heroTalent_npc_dota_hero_phantom_lancer = class({})


function heroTalent_npc_dota_hero_phantom_lancer:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_phantom_lancer" end
function heroTalent_npc_dota_hero_phantom_lancer:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end
function heroTalent_npc_dota_hero_phantom_lancer:GetCastRange()
	return self:GetSpecialValueFor("max_dis")
end

modifier_heroTalent_npc_dota_hero_phantom_lancer = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer:IsDebuff()      return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:IsHidden()      return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
	}
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:OnOrder(keys)
	if keys.unit == self:GetParent() then
		if self:GetParent():PassivesDisabled() then
			return
		end
		if not self:GetParent():IsRealHero() then
			return false
		end
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_move") then
			self:GetParent():RemoveModifierByName("modifier_heroTalent_npc_dota_hero_phantom_lancer_move")

		end
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay") then
			self:GetParent():RemoveModifierByName("modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay")
		end
		if keys.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and not self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_move") then
			return
		end

		if not keys.target then
			return
		end
		self.agility_duration = self:GetAbility():GetSpecialValueFor("duration")
		self.max_distance = self:GetAbility():GetSpecialValueFor("max_dis")
		self.min_distance = self:GetAbility():GetSpecialValueFor("min_dis")
		if TG_Distance(self:GetParent():GetAbsOrigin(), keys.target:GetAbsOrigin()) > self.max_distance and keys.target ~= nil then
			self:GetParent():AddNewModifier(keys.target, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay", {})
		end
		if TG_Distance(self:GetParent():GetAbsOrigin(), keys.target:GetAbsOrigin()) <= self.max_distance and TG_Distance(self:GetParent():GetAbsOrigin(), keys.target:GetAbsOrigin()) > self.min_distance then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_phantom_lancer_move", {duration = self.agility_duration})
			self:GetParent():RemoveModifierByName("modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay")

		end
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer:OnCreated(keys)
	self.agility_duration = self:GetAbility():GetSpecialValueFor("duration")+1
	self.max_distance = self:GetAbility():GetSpecialValueFor("max_dis")
	self.min_distance = self:GetAbility():GetSpecialValueFor("min_dis")

end


--检测距离增加移动buff
modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay = class({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay:IsDebuff()      return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay:IsHidden()      return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay:OnCreated(keys)
	self.agility_duration = self:GetAbility():GetSpecialValueFor("duration")+1
	self.max_distance = self:GetAbility():GetSpecialValueFor("max_dis")
	self.min_distance = self:GetAbility():GetSpecialValueFor("min_dis")

	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move_delay:OnIntervalThink()
	if not self:GetCaster():IsAlive() then
		self:StartIntervalThink(-1)
		self:SafeDestroy()
		return
	end
	if TG_Distance(self:GetParent():GetAbsOrigin(), self:GetCaster():GetAbsOrigin()) <= self.max_distance then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_phantom_lancer_move", {duration = self.agility_duration})
		self:SafeDestroy()
		return
	end
end



--移动速度加成
modifier_heroTalent_npc_dota_hero_phantom_lancer_move = class({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:IsHidden()      return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:OnCreated(keys)
	if self:GetAbility()==nil then
		return
	end
	self.agility_duration = self:GetAbility():GetSpecialValueFor("duration")


	if IsServer() then
		self:GetCaster():EmitSound("Hero_PhantomLancer.PhantomEdge")

		self.pfx = ParticleManager:CreateParticle( "particles/econ/items/phantom_lancer/ti7_immortal_shoulder/pl_ti7_edge_boost.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.pfx,5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )

		self:AddParticle( self.pfx, false, false, -1, true, false )
	end
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:CheckState()
	return
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
		}
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_EVENT_ON_ATTACK,
			}
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:GetModifierMoveSpeed_Absolute()
  	return self:GetAbility():GetSpecialValueFor("speed")
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_phantom_lancer_buff", {duration = self.agility_duration})
	self:SafeDestroy()
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_move:OnDestroy(keys)
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end






--增加敏捷
modifier_heroTalent_npc_dota_hero_phantom_lancer_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:IsDebuff()      return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:IsHidden()      return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:OnCreated(keys)
	if IsServer() then
		self.bonus_agi = self:GetParent():GetAgility()*self:GetAbility():GetSpecialValueFor("bonus_agi")*0.01
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_buff:Advanced_GetModifierBonusStats_Agility()
  return self.bonus_agi
end

