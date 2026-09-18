

Advanced_Bristle_Back = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Bristle_Back_passive", "skills/Advanced_Bristle_Back", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bristle_Back_active", "skills/Advanced_Bristle_Back", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bristle_Back_debuff", "skills/Advanced_Bristle_Back", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Advanced_Bristle_Back:CheckKV(key)
	local table = {
		back_damage_reduction = 0.7,
		side_damage_reduction = 0.5,
		back_angle = 1,
		side_angle = 2,





	}
	local value = table[key] or -1
	return value

end
function Advanced_Bristle_Back:UnlockFirstCore(key)
	return true
end
function Advanced_Bristle_Back:UnlockSecondCore(key)
	return true
end
function Advanced_Bristle_Back:UnlockThirdCore(key)

	return true
end




function Advanced_Bristle_Back:IsHiddenWhenStolen() 		return false end
function Advanced_Bristle_Back:IsRefreshable() 			return true end
function Advanced_Bristle_Back:IsStealable() 			return false end
function Advanced_Bristle_Back:IsNetherWardStealable()	return false end
function Advanced_Bristle_Back:GetIntrinsicModifierName() return "modifier_Advanced_Bristle_Back_passive" end

function Advanced_Bristle_Back:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_Bristle_Back_active", {duration = self:GetSpecialValueFor("active_duration")})
	caster:EmitSound("DOTA_Item.Pipe.Activate")
end


modifier_Advanced_Bristle_Back_passive = advanced_modifier({})

function modifier_Advanced_Bristle_Back_passive:IsDebuff()			return false end
function modifier_Advanced_Bristle_Back_passive:IsHidden() 			return false end
function modifier_Advanced_Bristle_Back_passive:IsPurgable() 		return false end
function modifier_Advanced_Bristle_Back_passive:IsPurgeException() 	return false end
function modifier_Advanced_Bristle_Back_passive:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end

end



function modifier_Advanced_Bristle_Back_passive:OnIntervalThink()
	local release =0.05 *self:GetCaster():GetMaxHealth()
	if self:GetStackCount()>=release  then
		local gain = self:GetStackCount()/release 
		self:SetStackCount(0)
		self:start(gain)
	end
	if self:GetAbility().unlock1 then
		self:SetStackCount(self:GetStackCount()+self:GetParent():GetMaxHealth()*0.15)
	end
end

function modifier_Advanced_Bristle_Back_passive:start(gain,unit)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	self.level = ability.advanced_level
	local damage = self:GetAbility():GetSpecialValueFor("damage_index")*caster:GetStrength()*gain
	EmitSoundOn("Hero_Bristleback.QuillSpray.Cast", caster)
	local pfx_name = "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback") then
		pfx_name = "particles/econ/items/bristleback/bristle_spikey_spray/bristle_spikey_quill_spray.vpcf"
		damage = damage *1.3
	end
	if ability.unlock2 then
		damage = damage * 2
	end


	local pos
	if unit then
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT, unit)
		ParticleManager:ReleaseParticleIndex(pfx)
		pos = unit:GetAbsOrigin()
	else
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT, caster)
		ParticleManager:ReleaseParticleIndex(pfx)
		pos = caster:GetAbsOrigin()
	end

	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	  local i = ability:GetSpecialValueFor("effect_number")
	  local damageTable = {
		attacker = caster,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
	}
	local debuff_duration = 15
	if ability.unlock3 then
		debuff_duration = 1000
	end
	for _,enemy in pairs(enemies) do
		i=i-1
		local modifier = enemy:FindModifierByName("modifier_Advanced_Bristle_Back_debuff")
		local damage_outgoing = damage
		if modifier then
			damage_outgoing = damage_outgoing*(1+modifier:GetStackCount()*0.05)
		end
		
		damageTable.damage = damage_outgoing
		damageTable.victim = enemy
		ApplyDamage(damageTable) 
		--LV5解锁刺针扫射+
		if self.level>=5 then
			enemy:AddNewModifier(caster, ability, "modifier_Advanced_Bristle_Back_debuff", {duration = debuff_duration})
		end
		if i<1 then
			break
		end
	end
	if not unit then
		--LV20解锁多重扫射
		if self.level>=20 and 15 >=RandomInt(1, 100)  then
			Timers:CreateTimer(0.5, function()
				self:start(gain)
			end)
		end
	end

	



end


function modifier_Advanced_Bristle_Back_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	if parent:PassivesDisabled() then
		return 0
	end

	if IsClient() then
		if  parent:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback_2") then
			return  (0 - passive:GetSpecialValueFor("back_damage_reduction"))
		end
		return 0
	end
	if not  keys.attacker then
		return 0
	end
	if  keys.attacker:IsBuilding() or parent:IsIllusion() then
		return
	end
	self.level = passive.advanced_level
	local take_damage=keys.damage

	--LV15解锁能量充盈
	if self.level>=15 and take_damage<20 then
		-- print("damage change")
		take_damage = 20
	end


	if take_damage<=0 then
		return
	end
	local cast_angle = VectorToAngles(parent:GetForwardVector() * -1)
	local angle = VectorToAngles((keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
	local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
	local min_degree = parent:HasModifier("modifier_Advanced_Bristle_Back_active") and 180 or (passive:GetSpecialValueFor("side_angle"))/2
	local back_angle = passive:GetSpecialValueFor("back_angle")
	--LV10解锁蜷缩+
	if self.level>=10 and parent:HasModifier("modifier_Advanced_Bristle_Back_active")  then
		back_angle = 360
	end
	if parent:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback_2") then
		degree = 0
	end

	if degree <= min_degree then
		local reduce = 0
		parent:EmitSound("Hero_Bristleback.Bristleback")
		if degree > back_angle/2 then  --如果大于后背的角度进行边减免
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_side_dmg.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)
			local side_reduce = passive:GetSpecialValueFor("side_damage_reduction") 
			local stack = math.min( take_damage * (side_reduce / 100),parent:GetMaxHealth())
			self:SetStackCount(self:GetStackCount() + stack)
			-- self:SetStackCount(self:GetStackCount() + take_damage * (side_reduce / 100))
			reduce = (0 - side_reduce)
		else    --如果是后背角度进行背减免
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)
			local back_reduce = passive:GetSpecialValueFor("back_damage_reduction") 
			local stack = math.min( take_damage * (back_reduce / 100),parent:GetMaxHealth())
			self:SetStackCount(self:GetStackCount() + stack)
			-- self:SetStackCount(self:GetStackCount() + take_damage * (back_reduce / 100))
			reduce = (0 -back_reduce)
		end
		return reduce
	end
end

function modifier_Advanced_Bristle_Back_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

modifier_Advanced_Bristle_Back_active = class({})

function modifier_Advanced_Bristle_Back_active:IsDebuff()			return false end
function modifier_Advanced_Bristle_Back_active:IsHidden() 			return false end
function modifier_Advanced_Bristle_Back_active:IsPurgable() 			return true end
function modifier_Advanced_Bristle_Back_active:IsPurgeException() 	return true end
function modifier_Advanced_Bristle_Back_active:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_defense_stance_shield.vpcf" end
function modifier_Advanced_Bristle_Back_active:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_Bristle_Back_active:ShouldUseOverheadOffset() return true end
-- function modifier_Advanced_Bristle_Back_active:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
-- function modifier_Advanced_Bristle_Back_active:GetModifierMoveSpeedBonus_Percentage() return (0 - 100) end
function modifier_Advanced_Bristle_Back_active:CheckState()
    return {
      
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
    }
end












--刺针扫射+

modifier_Advanced_Bristle_Back_debuff = class({})

function modifier_Advanced_Bristle_Back_debuff:IsDebuff() return true end
function modifier_Advanced_Bristle_Back_debuff:IsHidden() return false end
function modifier_Advanced_Bristle_Back_debuff:IsPurgable() return false end


function modifier_Advanced_Bristle_Back_debuff:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Bristle_Back_debuff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		if self:GetStackCount()%6==0  then
			local ability = self:GetAbility()
			if ability.unlock2 then
				local modifier =self:GetCaster():FindModifierByName("modifier_Advanced_Bristle_Back_passive")
				if modifier then
					modifier:start(3,self:GetParent())
				end
			end
		end
	end
end

function modifier_Advanced_Bristle_Back_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end
