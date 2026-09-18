
Advanced_Doom = Advanced_Doom or class({})

LinkLuaModifier("modifier_Advanced_Doom", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Doom_damage", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Doom_str", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Doom_break", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Doom_root", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Doom_destroy", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Doom_buff_unlock2", "skills/Advanced_Doom", LUA_MODIFIER_MOTION_NONE)



function Advanced_Doom:Precache( context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_aura.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/doom/unlock1/effect.vpcf", context )
	--PrecacheResource( "particle", "particles/rebuild/spell/doom/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/doom/origin/domm_aura.vpcf", context )--新增：我做的,为了区分所以我特地写反名字，记得看清楚
end


function Advanced_Doom:CheckKV(key)
	local table = {

		basic_damage =4,
		bonus_damage = 0.04,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Doom:GetBehavior(iLevel)
	if self:GetSpecialValueFor("advanced_level")>=15 then		
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_IMMEDIATE +DOTA_ABILITY_BEHAVIOR_NO_TARGET +DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
end
------------------------------------------------------------------------------------------------------------------
function Advanced_Doom:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_reactive_armor_unlock1",{})

	return true
end
function Advanced_Doom:UnlockSecondCore(key)
	return true
end
function Advanced_Doom:UnlockThirdCore(key)
	return true
end

function Advanced_Doom:GetHealthCost(iLevel)--新增：切换时消耗自身生命值
	return self:GetCaster():GetMaxHealth() * self:GetSpecialValueFor("max_hp_percent") * 0.01
end

function Advanced_Doom:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_Doom:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Doom", self:GetCaster())
	self:GetCaster():StopSound("Hero_DoomBringer.Doom")
end

function Advanced_Doom:OnToggle()
	if not IsServer() then
		return 
	end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Doom", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Doom", self:GetCaster())
	end
	
end

function Advanced_Doom:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Doom = advanced_modifier({})

function modifier_Advanced_Doom:IsDebuff()				return false end
function modifier_Advanced_Doom:IsHidden() 			return false end
function modifier_Advanced_Doom:IsPurgable() 			return false end
function modifier_Advanced_Doom:IsPurgeException() 	return false end

function modifier_Advanced_Doom:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.limit = self.ability:GetSpecialValueFor("limit")
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
		self.heal = self.ability:GetSpecialValueFor("bonus_heal")*0.01
		self.think = self.ability:GetSpecialValueFor("hit_time")
		self.str_duration = self.ability:GetSpecialValueFor("bonus_str_duration")
		self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/spell/doom/origin/domm_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)

		if self:GetAbility():GetUnlock(1)==1 then
			self.unlock1 = 3
		end
		if self:GetAbility():GetUnlock(2)==2   then
			self.unlock2 = 3
		end
		if self:GetAbility():GetUnlock(3)==3 then
			self.unlock3 = 3
		end


		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_ABSORIGIN_FOLLOW, "", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 0,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 1,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 3, Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 62, Vector(0,0,0))
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		self:GetParent():EmitSound("Hero_DoomBringer.Doom")

		self:StartIntervalThink(self.think)--修改：改为kv方便调整
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,--修改：对自身造成魔法伤害
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
	end
end

function modifier_Advanced_Doom:OnRefresh()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.limit = self.ability:GetSpecialValueFor("limit")
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
		self.heal = self.ability:GetSpecialValueFor("bonus_heal")*0.01
		self.think = self.ability:GetSpecialValueFor("hit_time")
		self.str_duration = self.ability:GetSpecialValueFor("bonus_str_duration")

		if self:GetAbility():GetUnlock(1)==1 then
			self.unlock1 = 3
		end
		if self:GetAbility():GetUnlock(2)==2 then
			self.unlock2 = 3
		end
		if self:GetAbility():GetUnlock(3)==3 then
			self.unlock3 = 3
		end


		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,--修改：对自身造成魔法伤害
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
	end
end

function modifier_Advanced_Doom:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end


function modifier_Advanced_Doom:OnIntervalThink()
	if not self.ability then
		self:SafeDestroy()
		return
	end
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.limit = self.ability:GetSpecialValueFor("limit")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.think = self.ability:GetSpecialValueFor("hit_time")
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
	self.heal = self.ability:GetSpecialValueFor("bonus_heal")*0.01
	self.str_duration = self.ability:GetSpecialValueFor("bonus_str_duration")

	local damage = self.ability:GetSpecialValueFor( "basic_damage" ) + self.caster:HDGetPrimaryStatValue() * self.ability:GetSpecialValueFor( "bonus_damage" )--修改：改为力量技能
	self.damageTable.damage = damage
	if self.unlock3 then
		local healing = HealWithGain(self.damageTable.damage,self.caster,self.parent,self.ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
	else
		ApplyDamage(self.damageTable)
	end
	
	if self.unlock1 then
		self.duration_unlock1 = 3
		local particle_cast = "particles/rebuild/spell/doom/unlock1/effect.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt(effect_cast,0,self:GetCaster(),PATTACH_POINT_FOLLOW,"",self:GetCaster():GetOrigin(),true )
		DestroyParticleByDelay(effect_cast,3)
	end

	if self.unlock2 and self:GetAbility():GetAutoCastState() then
		local units_unlock2 = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

		for i,ally in pairs(units_unlock2) do
			ally:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Doom_damage", {duration = self.think + 0.01 ,duration_stack = self.think + 0.01})
			ally:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Doom_buff_unlock2", {duration = self.think + 0.01 ,duration_stack = self.think + 0.01})
			if i>=self.limit then
				break
			end
		end
	else	
		local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for i,enemy in pairs(units) do
			enemy:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Doom_break", {duration = self.think + 0.01 ,duration_stack = self.think + 0.01})
			if self.unlock1 then
				enemy:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Doom_damage", {duration = self.duration_unlock1 + 0.01 ,duration_stack = self.duration_unlock1 + 0.01})--修改：因kv化，调整了写法
			else
				enemy:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Doom_damage", {duration = self.think + 0.01 ,duration_stack = self.think + 0.01})--修改：因kv化，调整了写法
			end
		
			if i>=self.limit then
				break
			end
		end
	end
end

function modifier_Advanced_Doom:ADDeclareFunctions()
	local funcs =  {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self.parent,nil},	
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH = {self.parent,nil}
	}
	if self:GetAbility():GetUnlock(3)==3 then--不这样做无法在面板显示数值。
		table.insert(funcs,advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE)
		--print("插入成功！"..self.unlock3)
	end
	return funcs
end
		
		

function modifier_Advanced_Doom:Advanced_GetModifierIncomingDamage_Percentage()
	if self:GetAbility():GetAutoCastState() then
		return self:GetAbility():GetSpecialValueFor("damage_mul_extra")--易伤数值等同额外结算,因为是自动施法即使开关，为了方便适用故做半高调用
	end
	return 0 
end

function modifier_Advanced_Doom:Advanced_GetModifierHealAMP_Percentage()
	return 66
end

function modifier_Advanced_Doom:Advanced_GetModifierHealReceiveAMP_Percentage()
	return 66
end



function modifier_Advanced_Doom:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		if tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL		--伤害类型是技能伤害
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 		--不带反甲伤害标签
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 		--不带不造成吸血标签

			--该生命吸血受到吸血增强影响
            local life_steal_gain = self:GetParent():GetModifierLifeStealGain(1)
			local hp = 0
			hp=tg.damage*self.bonus_life_steal*life_steal_gain
            hp = hp-hp%1
			-- print("hp="..hp)
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            self.parent:Heal(hp, self.ability)

        end 
    end 
end


function modifier_Advanced_Doom:OnDeath(keys)
    if IsServer() then
		--print("敌人死亡函数-生效")
		if keys.attacker == self.parent then
			keys.attacker:Heal(self.heal * keys.attacker:GetMaxHealth(), self.ability)
			--print("敌人死亡生命回复-生效")
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, self.heal * keys.attacker:GetMaxHealth(), nil)
			if self.ability.advanced_level >= 5 then
				keys.attacker:AddNewModifier(keys.attacker,self.ability,"modifier_Advanced_Doom_str",{duration = self.str_duration})
			end
			if self:GetAbility():GetAutoCastState() and self.ability.advanced_level >= 20 then
				local lifes = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, -1,
				DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for i,life in pairs(lifes) do
					life:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Doom_destroy", {duration = self.str_duration})--修改：因kv化，调整了写法
					
				end
			end
		end
    end
	
   
end

--------------------------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Doom_damage = modifier_Advanced_Doom_damage or class({})

function modifier_Advanced_Doom_damage:IsDebuff()				return true end
function modifier_Advanced_Doom_damage:IsHidden() 			return false end
function modifier_Advanced_Doom_damage:IsPurgable() 			return false end
function modifier_Advanced_Doom_damage:IsPurgeException() 	return false end
function modifier_Advanced_Doom_damage:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end
function modifier_Advanced_Doom_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Doom_damage:OnCreated(keys)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = GameRules:GetGameTime() +keys.duration_stack})
		self:IncrementStackCount()
		self:StartIntervalThink(0.06)
		self.timer = GameRules:GetGameTime()+0.5
		self.think =self:GetAbility():GetSpecialValueFor("hit_time")
		if self:GetAbility():GetUnlock(1)==1 then
			self.unlock1 = 3
		end
		if self:GetAbility():GetUnlock(2)==2 then
			self.unlock2 = 3
		end
		if self:GetAbility():GetUnlock(3)==3 then
			self.unlock3 = 3
		end

		if self.unlock2 then
			self.damageTable = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				-- damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self:GetAbility(), --Optional.
			}
		else
			self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
			}
		end
	end
end


function modifier_Advanced_Doom_damage:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		if self:GetAbility():GetUnlock(1)==1 then
			self.unlock1 = 3
		end
		if self:GetAbility():GetUnlock(2)==2 then
			self.unlock2 = 3
		end
		if self:GetAbility():GetUnlock(3)==3 then
			self.unlock3 = 3
		end

		if self.unlock2 then
			self.damageTable = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				-- damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(), --Optional.
			}
		else
			self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
			}
		end

		table.insert(self.tData, {dieTime = GameRules:GetGameTime() +keys.duration_stack })
		self:IncrementStackCount()
		self.think =self:GetAbility():GetSpecialValueFor("hit_time")
	end
end

function modifier_Advanced_Doom_damage:OnIntervalThink()
	if IsServer() then

		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
		if self.timer<=fGameTime then
			local ability = self:GetAbility()
			if not ability then
				self:SafeDestroy()
				return
			end
			self.timer = fGameTime + self.think--修改：匹配伤害间隔
		
			local caster = self:GetCaster()
			local damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:HDGetPrimaryStatValue() * ability:GetSpecialValueFor( "bonus_damage" )--修改：改为力量技能
			if self:GetAbility():GetAutoCastState() then
				self.damage_enemy_index = (ability:GetSpecialValueFor( "damage_mul" ) + ability:GetSpecialValueFor( "damage_mul_extra" ))*0.01
			else
				self.damage_enemy_index = ability:GetSpecialValueFor( "damage_mul" )*0.01
			end

			self.damageTable.damage = damage * self.damage_enemy_index * self:GetStackCount()
			ApplyDamage(self.damageTable)
		end
	end
end

--------------------------------------------------------高阶：斩杀缠绕------------------------------------------------------------------------
modifier_Advanced_Doom_break = advanced_modifier({})

function modifier_Advanced_Doom_break:IsDebuff()				return true end
function modifier_Advanced_Doom_break:IsHidden() 			return true end
function modifier_Advanced_Doom_break:IsPurgable() 			return false end
function modifier_Advanced_Doom_break:IsPurgeException() 	return false end

function modifier_Advanced_Doom_break:OnCreated(keys)
	self.kill = self:GetAbility():GetSpecialValueFor("kill_line")*0.01
	self.root = self:GetAbility():GetSpecialValueFor("root_line")*0.01
	self.root_duration = self:GetAbility():GetSpecialValueFor("root_duration")
	self:StartIntervalThink(0.6)
end

function modifier_Advanced_Doom_break:OnRefresh(keys)
	self.kill = self:GetAbility():GetSpecialValueFor("kill_line")*0.01
	self.root = self:GetAbility():GetSpecialValueFor("root_line")*0.01
	self.root_duration = self:GetAbility():GetSpecialValueFor("root_duration")
end

function modifier_Advanced_Doom_break:OnIntervalThink()
	if IsServer() then 
		--print("服务端判定完成")
		if  self:GetParent():GetHealth() <= self:GetParent():GetMaxHealth()*self.kill then
        	TrueKill(self:GetCaster(), self:GetParent(), self:GetAbility())
    	end
		if  self:GetParent():GetHealth() >= self:GetParent():GetMaxHealth()*self.root and self:GetAbility().advanced_level >= 10 then
			self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_Doom_root",{duration = self.root_duration})
			--print("成功施加了缠绕")
		end
	
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Doom_root = advanced_modifier({})

function modifier_Advanced_Doom_root:IsDebuff()				return true end
function modifier_Advanced_Doom_root:IsHidden() 			return true end
function modifier_Advanced_Doom_root:IsPurgable() 			return false end
function modifier_Advanced_Doom_root:IsPurgeException() 	return false end
function modifier_Advanced_Doom_root:CheckState()
	return{
		[MODIFIER_STATE_ROOTED] = true,
	}
end

----------------------------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Doom_str = advanced_modifier({})

function modifier_Advanced_Doom_str:IsDebuff()				return false end
function modifier_Advanced_Doom_str:IsHidden() 			return false end
function modifier_Advanced_Doom_str:IsPurgable() 			return false end
function modifier_Advanced_Doom_str:IsPurgeException() 	return false end
function modifier_Advanced_Doom_str:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")	
end
function modifier_Advanced_Doom_str:OnRefresh(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")	
	self:SetStackCount(math.min(self:GetStackCount()+1,66))
end
function modifier_Advanced_Doom_str:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end
function modifier_Advanced_Doom_str:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_str*self:GetStackCount()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Doom_destroy = advanced_modifier({})

function modifier_Advanced_Doom_destroy:IsDebuff()				return true end
function modifier_Advanced_Doom_destroy:IsHidden() 			return false end
function modifier_Advanced_Doom_destroy:IsPurgable() 			return false end
function modifier_Advanced_Doom_destroy:IsPurgeException() 	return false end
function modifier_Advanced_Doom_destroy:OnCreated(keys)
	self.inv = self:GetAbility():GetSpecialValueFor("bonus_str")	
end
function modifier_Advanced_Doom_destroy:OnRefresh(keys)
	self.inv = self:GetAbility():GetSpecialValueFor("bonus_str")	
	self:SetStackCount(self:GetStackCount()+1)
end
function modifier_Advanced_Doom_destroy:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_Advanced_Doom_destroy:Advanced_GetModifierIncomingDamage_Percentage()
	return self.inv*self:GetStackCount()
end
function modifier_Advanced_Doom_destroy:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.inv*self:GetStackCount()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Doom_buff_unlock2 = advanced_modifier({})

function modifier_Advanced_Doom_buff_unlock2:IsDebuff()				return false end
function modifier_Advanced_Doom_buff_unlock2:IsHidden() 			return true end
function modifier_Advanced_Doom_buff_unlock2:IsPurgable() 			return false end
function modifier_Advanced_Doom_buff_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Doom_buff_unlock2:ADDeclareFunctions()
	return{advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,}
end
function modifier_Advanced_Doom_buff_unlock2:DeclareFunctions()
	return{MODIFIER_PROPERTY_MODEL_SCALE,}
end
function modifier_Advanced_Doom_buff_unlock2:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return	80
end
function modifier_Advanced_Doom_buff_unlock2:GetModifierModelScale()
	return	50
end
