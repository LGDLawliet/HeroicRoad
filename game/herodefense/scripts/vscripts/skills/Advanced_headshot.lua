Advanced_headshot = class({})
LinkLuaModifier( "modifier_Advanced_headshot_buff", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_headshot_debuff", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_headshot_lv20_debuff", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_headshot_unlock2", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_headshot_unlock2_debuff", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_headshot_unlock2_buff", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_headshot_unlock3", "skills/Advanced_headshot", LUA_MODIFIER_MOTION_NONE )
function Advanced_headshot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold_blood_bulk.vpcf", context )

end


function Advanced_headshot:GetIntrinsicModifierName()
	return "modifier_Advanced_headshot_buff"
end

function Advanced_headshot:OnAdvancedUpgrade()
	self:SetLevel(0)
	self:SetLevel(1)
end

function Advanced_headshot:CheckKV(key)
	local table = {

	
		bonus_damage =8,


	}
	local value = table[key] or -1
	return value

end



function Advanced_headshot:UnlockFirstCore(key)
	self:SetLevel(0)
	self:SetLevel(1)
	return true
end
function Advanced_headshot:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_headshot_unlock2",{})
	return true
end
function Advanced_headshot:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_headshot_unlock3",{})
	return true
end



modifier_Advanced_headshot_buff = modifier_Advanced_headshot_buff or class({})
function modifier_Advanced_headshot_buff:IsHidden()	return true end
function modifier_Advanced_headshot_buff:IsPurgable()	return false end

function modifier_Advanced_headshot_buff:OnCreated( kv )

	local ability = self:GetAbility()
	self.proc_chance = ability:GetSpecialValueFor( "proc_chance" ) 
	self.slow_duration =ability:GetSpecialValueFor( "slow_duration" )
	local level =   ability:GetSpecialValueFor("advanced_level")
	self.bonus_damage_index = 0.03
	self.healthPercent = 30
	if level>=5 then
		self.bonus_damage_index = 0.04
		if level>=10 then
			self.healthPercent = 50
			if level>=15 then
				self.slow_duration = 0.8
				if level>=20 then
					self.lv20 = true
					if ability.unlock1 then
						self.unlock1 = true
					end
				end
			end
		end
	end

end

function modifier_Advanced_headshot_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_headshot_buff:OnDestroy( kv )

end


function modifier_Advanced_headshot_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifier_Advanced_headshot_buff:GetModifierProcAttack_BonusDamage_Physical( keys )
	if IsServer() then
		local caster = self:GetCaster()
		if caster:PassivesDisabled() or not caster:IsApplyModifier() then
			return 0
		end
		local chance = self.proc_chance
		if self.lv20 then
			local modifier = keys.target:FindModifierByName("modifier_Advanced_headshot_lv20_debuff")
			if modifier then
				chance = chance + modifier:GetStackCount()
			end
		end
		chance = math.min(chance,120)

		if keys.layser or self:GetCaster():RollRandom(chance,1)  then
			
			keys.target:EmitSound("Hero_Sniper.MKG_impact")
			keys.target:AddNewModifier(
				caster,
				self:GetAbility(),
				"modifier_Advanced_headshot_debuff",
				{ 
					duration = self.slow_duration,
				} -- kv
			)
			if self.lv20 then
				keys.target:AddNewModifier(
					caster,
					self:GetAbility(),
					"modifier_Advanced_headshot_lv20_debuff",{} 
				)
			end
			local distance =  CalculateDistance(keys.target,caster)
			local bonus_damage = math.min(distance/100,30)*caster:GetAverageTrueAttackDamage(nil)*self.bonus_damage_index
			bonus_damage = bonus_damage +  self:GetAbility():GetSpecialValueFor( "bonus_damage" )
			if self.unlock1 then
				bonus_damage = bonus_damage + caster:GetAverageTrueAttackDamage(nil)*0.01 * (chance*1.4)
				self:PlayEffect(keys.target)
			end
			if keys.target:GetHealthPercent()<=self.healthPercent then 
				bonus_damage = bonus_damage * 1.5
			end
			return bonus_damage
		end
	end
end


function modifier_Advanced_headshot_buff:PlayEffect(target)
	local pfx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold_blood_bulk.vpcf",PATTACH_POINT_FOLLOW,target)
	ParticleManager:SetParticleControlForward(pfx, 1, CalculateDirection(self:GetCaster(),target)) 
	DestroyParticleByDelay(pfx,2)
end




modifier_Advanced_headshot_debuff = modifier_Advanced_headshot_debuff or class({})


function modifier_Advanced_headshot_debuff:IsHidden()	return false end
function modifier_Advanced_headshot_debuff:IsDebuff()	return true end
function modifier_Advanced_headshot_debuff:IsPurgable()	return true end
function modifier_Advanced_headshot_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor("move_slow")
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		self.slow = self.slow  * 2
	end
end


function modifier_Advanced_headshot_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_Advanced_headshot_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end
function modifier_Advanced_headshot_debuff:GetEffectName()
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_Advanced_headshot_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

















modifier_Advanced_headshot_lv20_debuff = modifier_Advanced_headshot_lv20_debuff or class({})
function modifier_Advanced_headshot_lv20_debuff:IsHidden()	return true end
function modifier_Advanced_headshot_lv20_debuff:IsPurgable()	return false end
function modifier_Advanced_headshot_lv20_debuff:IsDebuff() return 	true end
function modifier_Advanced_headshot_lv20_debuff:OnCreated( kv )

	if IsServer() then
		self:IncrementStackCount()
	end

end

function modifier_Advanced_headshot_lv20_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end










modifier_Advanced_headshot_unlock2 = class({})


function modifier_Advanced_headshot_unlock2:IsHidden()	return true end
function modifier_Advanced_headshot_unlock2:IsDebuff()	return false end
function modifier_Advanced_headshot_unlock2:IsStunDebuff()	return false end
function modifier_Advanced_headshot_unlock2:RemoveOnDeath()	return false end
function modifier_Advanced_headshot_unlock2:DestroyOnExpire()	return false end
function modifier_Advanced_headshot_unlock2:IsPurgable() 		return false end
function modifier_Advanced_headshot_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_headshot_unlock2:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )
		self:StartIntervalThink(5)
	end
end
function modifier_Advanced_headshot_unlock2:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_Advanced_headshot_unlock2:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		unit:AddNewModifier(caster,self:GetAbility(),"modifier_Advanced_headshot_unlock2_debuff",{})
	end

end

function modifier_Advanced_headshot_unlock2:OnIntervalThink()
	local modifier = self:GetParent():FindModifierByName("modifier_Advanced_headshot_unlock2_buff")
	if modifier then
		if modifier:GetStackCount()>=1200 then
			self:SafeDestroy()
		end
	end
end








modifier_Advanced_headshot_unlock2_debuff = class({})


function modifier_Advanced_headshot_unlock2_debuff:IsHidden()	return false end
function modifier_Advanced_headshot_unlock2_debuff:IsDebuff()	return false end
function modifier_Advanced_headshot_unlock2_debuff:IsStunDebuff()	return false end
function modifier_Advanced_headshot_unlock2_debuff:IsPurgable() 		return false end
function modifier_Advanced_headshot_unlock2_debuff:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_Advanced_headshot_unlock2_debuff:OnTakeDamage( params )

	if IsServer() then
		local Target = params.unit
		local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end
		if flDamage<=0 then
			return
		end
		self:DecrementStackCount()
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end



	end

	return 0.0

end
function modifier_Advanced_headshot_unlock2_debuff:OnCreated()
	if IsServer() then
		self:SetStackCount(10)
	end
end
function modifier_Advanced_headshot_unlock2_debuff:OnDestroy()
	if IsServer() then
		if self:GetStackCount()>0 then
			local caster = self:GetCaster()
			caster:AddNewModifier(caster,self:GetAbility(),"modifier_Advanced_headshot_unlock2_buff",{})
		end
	end
end


modifier_Advanced_headshot_unlock2_buff = class({})

function modifier_Advanced_headshot_unlock2_buff:IsDebuff()			return false end
function modifier_Advanced_headshot_unlock2_buff:IsHidden() 			return false end
function modifier_Advanced_headshot_unlock2_buff:IsPurgable() 		    return false end
function modifier_Advanced_headshot_unlock2_buff:IsPurgeException() return false end
function modifier_Advanced_headshot_unlock2_buff:RemoveOnDeath() return false end
-- function modifier_Advanced_headshot_unlock2_buff:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
function modifier_Advanced_headshot_unlock2_buff:OnCreated(keys)
    if not IsServer()  then
        return
    end
	self:SetStackCount(math.min(self:GetStackCount()+10,1200))
	

end
function modifier_Advanced_headshot_unlock2_buff:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_Advanced_headshot_unlock2_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,           --攻击力
	}
end


function modifier_Advanced_headshot_unlock2_buff:GetModifierBaseAttack_BonusDamage() return self:GetStackCount() end




modifier_Advanced_headshot_unlock3 = class({})


function modifier_Advanced_headshot_unlock3:IsHidden()	return true end
function modifier_Advanced_headshot_unlock3:IsDebuff()	return false end
function modifier_Advanced_headshot_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_headshot_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_headshot_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_headshot_unlock3:IsPurgable() 		return false end
function modifier_Advanced_headshot_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_headshot_unlock3:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK,
    }
end
function modifier_Advanced_headshot_unlock3:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
	end
end
function modifier_Advanced_headshot_unlock3:OnAttack(keys)
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then	

		local caster = self:GetCaster()
		if not caster:IsApplyModifier() then
			return
		end
		local time = GameRules:GetGameTime()
		if self.timer>=time then
			return
		end
		local ability = self:GetAbility()
		self.timer = GameRules:GetGameTime() + 2
		self:ReleaseLaser(keys.target)


	
		
		
		
		
	end
end


function modifier_Advanced_headshot_unlock3:ReleaseLaser(target)
	local caster = self:GetCaster()

	local pos = target:GetAttachmentOrigin(target:ScriptLookupAttachment( "attach_hitloc" ) )
	local vAttachmentSourcePos = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment( "attach_attack1" ) )
	local direction = (pos - vAttachmentSourcePos):Normalized()

	local target_pos = vAttachmentSourcePos+direction*math.max((CalculateDistance(pos,vAttachmentSourcePos)),3000)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 9, vAttachmentSourcePos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)

	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 9, vAttachmentSourcePos+Vector(0,0,25) )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)
	local new_pos = RotatePosition(vAttachmentSourcePos, QAngle(0, 90, 0), vAttachmentSourcePos+caster:GetForwardVector()*25)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 9, new_pos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)
	local new_pos = RotatePosition(vAttachmentSourcePos, QAngle(0, -90, 0), vAttachmentSourcePos+caster:GetForwardVector()*25)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 9, new_pos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)

	caster:EmitSound("Hero_Tinker.LaserImpact")
	local modifier = caster:FindModifierByName("modifier_Advanced_headshot_buff")
	
	if modifier then
		
		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), vAttachmentSourcePos,target_pos,nil, 150,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE)
		local damageTable =
		{
			-- victim = hitEnemy,
			attacker = caster,
			-- damage = caster:GetAverageTrueAttackDamage(nil)*3.5,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
		}
		
		for _, hitEnemy in pairs( tTargets ) do
			local keys = {
				target = hitEnemy,
				layser = 1,
			}
			local damage = modifier:GetModifierProcAttack_BonusDamage_Physical( keys )
			if damage>0 then
				damageTable.damage = damage * 6
				damageTable.victim = hitEnemy
				ApplyDamage( damageTable )

			end
			
			
		end
	end



end
