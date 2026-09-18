chaotic_summon_spirit_of_miyamoto = class({})

LinkLuaModifier("modifier_chaotic_summon_spirit_of_miyamoto_buff", "chaotic_spell/class_9/chaotic_summon_spirit_of_miyamoto", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_spirit_of_miyamoto_passive", "chaotic_spell/class_6/chaotic_summon_spirit_of_miyamoto", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_spirit_of_miyamoto:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_weapon_ambient_v2.vpcf", context )
end


function chaotic_summon_spirit_of_miyamoto:IsSummonSpell()return true end
function chaotic_summon_spirit_of_miyamoto:OnSpellStart()

	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	
	local caster =self:GetCaster()
	
	local gain = self:GetEffectGain()



	local life_duration = self:GetSpecialValueFor("duration") 

	local base_health = self:GetSpecialValueFor("base_health")
	local base_armor = self:GetSpecialValueFor("base_armor")
	local base_damage = self:GetSpecialValueFor("base_damage")
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth() + base_health*gain
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false) + base_armor *gain

	-- local bonus_base_atk = self:GetSpecialValueFor("base_damage")
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)) + base_damage*gain
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_spirit_of_miyamoto",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf", PATTACH_POINT, unit)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	-- ParticleManager:SetParticleControlEnt( infest_particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(infest_particle, 1, Vector(200,0,0))
	ParticleManager:SetParticleControl(infest_particle, 5, Vector(250,1,1))
	DestroyParticleByDelayButNotImmediately(infest_particle,1)
	-- ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_Juggernaut.ArcanaTrigger")
	-- unit:StartGesture(ACT_DOTA_SPAWN)
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_spirit_of_miyamoto_buff", {})
	unit:AddActivityModifier("walk")
	if self:GetRuneType()==2 then
		local ability = unit:AddAbility("chaotic_kalia_swordcraft")
		if ability then
			ability:SetLevel(1)
		end
	end
	-- unit:AddActivityModifier("odachi")
end


modifier_chaotic_summon_spirit_of_miyamoto_buff = advanced_modifier({})

function modifier_chaotic_summon_spirit_of_miyamoto_buff:IsDebuff() return false end
function modifier_chaotic_summon_spirit_of_miyamoto_buff:IsHidden() return true end
function modifier_chaotic_summon_spirit_of_miyamoto_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_spirit_of_miyamoto_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_spirit_of_miyamoto_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_spirit_of_miyamoto_buff:OnCreated(keys)
	self.bonus_gain = self:GetAbility():GetSpecialValueFor("bonus_gain")
	if IsServer() then
		self.hero =  self:GetParent()


		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_Great_Cleave")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(30)
			self.creep_ability:SetFrozenCooldown(true)
			-- self.lighting:StartCooldown(600)
			self:StartIntervalThink(0.2)
		end

		self.draw = false
		self.modelName = self.hero:GetModelName()
		local model = self.hero:FirstMoveChild()
		-- self.modelName = self.hero:GetModelName()
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				print(model)
				-- PrintTable(model)
				print(model:GetModelName())
				if model:GetModelName()=="models/items/juggernaut/miyamoto_musash_weapon/miyamoto_musash_weapon.vmdl" then
					model:SetSkin(2)
					print("ok")

					local infest_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_2022_cc/jugg_2022_cc_weapon_ambient_v2.vpcf", PATTACH_POINT, model)
					ParticleManager:SetParticleControlEnt( infest_particle, 3, model, PATTACH_POINT_FOLLOW, "attach_weapon_core_fx" , model:GetOrigin(), true )
					ParticleManager:SetParticleControlEnt( infest_particle, 4, model, PATTACH_POINT_FOLLOW, "attach_weapon_core_end_fx" , model:GetOrigin(), true )
					-- ParticleManager:SetParticleControl(infest_particle, 5, Vector(250,1,1))
					self:AddParticle( infest_particle, false, false, -1, true, false )
		

					
				end
				self.lastModel = model
			end
			model = model:NextMovePeer()
		end
	
	end
end

function modifier_chaotic_summon_spirit_of_miyamoto_buff:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval
			parent:CastAbilityNoTarget(self.creep_ability, parent:GetPlayerOwnerID())

		end
	end
end

function modifier_chaotic_summon_spirit_of_miyamoto_buff:ADDeclareFunctions()
	local funcs =  {
		advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN_MUL,  --法术效用乘法叠加


    }
	if self:GetAbility():GetRuneType()==1 then
		self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
		table.insert(funcs,	advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION)
	
	end
    return funcs
   
end

function modifier_chaotic_summon_spirit_of_miyamoto_buff:Advanced_GetModifier_ChaoticSpellEffectGain_Mul() 
	return self.bonus_gain
end


function modifier_chaotic_summon_spirit_of_miyamoto_buff:Advanced_GetModifierCooldownReduction() 
	return self.rune_1_bonus
end




