
chaotic_alchemy = class({})
LinkLuaModifier("modifier_chaotic_alchemy", "chaotic_spell/class_2/chaotic_alchemy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_alchemy_rune_3", "chaotic_spell/class_2/chaotic_alchemy", LUA_MODIFIER_MOTION_NONE)


function chaotic_alchemy:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/newbloom_2020/high_five_newbloom_golden.vpcf", context )

end
function chaotic_alchemy:GetIntrinsicModifierName()
	return "modifier_chaotic_alchemy"
end







modifier_chaotic_alchemy = advanced_modifier({})

function modifier_chaotic_alchemy:IsHidden() return true end
function modifier_chaotic_alchemy:IsPurgable() return false end
function modifier_chaotic_alchemy:IsDebuff() return false end

function modifier_chaotic_alchemy:OnCreated(keys)
	
	if IsServer() then
		self.bonus = self:GetAbility():GetSpecialValueFor("bonus") 
		self.chance = self:GetAbility():GetSpecialValueFor("chance") 
		self.gain_scale = self:GetAbility():GetSpecialValueFor("gain_scale") 
		if self:GetAbility():GetRuneType()==1 then
			self.rune_1_bonus_gain = self:GetAbility():GetSpecialValueFor("rune_1_bonus_gain")
		end
		if self:GetAbility():GetRuneType()==2 then
			self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rune_2_interval"))
		end
	end
end
function modifier_chaotic_alchemy:OnRefresh(keys)
	
	if IsServer() then
		self.bonus = self:GetAbility():GetSpecialValueFor("bonus")
		self.chance = self:GetAbility():GetSpecialValueFor("chance") 
		self.gain_scale = self:GetAbility():GetSpecialValueFor("gain_scale") 
		if self:GetAbility():GetRuneType()==1 then
			self.rune_1_bonus_gain = self:GetAbility():GetSpecialValueFor("rune_1_bonus_gain")
		end
	end
end

function modifier_chaotic_alchemy:OnIntervalThink()
	local rune_2_bonus = self:GetAbility():GetSpecialValueFor("rune_2_bonus")*0.01
	local bonus =  math.floor(self:GetParent():GetGold()*rune_2_bonus)
	
	if bonus then
		if bonus>0 then
			chaotic_era_spawner:PlayerGetGoldBounty(self:GetParent(),bonus,self:GetAbility())
			SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_GOLD  ,self:GetParent(), bonus, nil)
			--print(bonus)
		end
	end
end


function modifier_chaotic_alchemy:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_DEATH = {nil, nil},

    }
end

function modifier_chaotic_alchemy:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		
		if attacker and attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() and IsEnemy(unit,attacker) then
			if attacker:PassivesDisabled() then
				return
			end
			local nPlayerID = attacker:GetPlayerOwnerID()
			local bonus = self.bonus *  self:GetAbility():GetEffectGain()
			local random = math.random
			if self.chance>=random(1, 100) then
				if self:GetAbility():GetRuneType()==3 then
					if self:GetAbility():GetSpecialValueFor("rune_3_chance") >= random(1,100) then
						local duration = random(8,18)--数据计算：平均数要触发13次
						attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_chaotic_alchemy_rune_3", {duration = duration*0.5})
					end
				end
				bonus = bonus * self.gain_scale
			end
			
			if self.rune_1_bonus_gain then
				local bonus_bounty = self.rune_1_bonus_gain
				if bonus_bounty>0 then
					local heroes = GetAllRealHeroes()
					for _, unit in pairs(heroes) do
						--if unit:GetPlayerOwnerID()~=nPlayerID then
							chaotic_era_spawner:PlayerGetGoldBounty(unit,bonus_bounty,self:GetAbility())
							SendOverheadEventMessage( unit, OVERHEAD_ALERT_GOLD  ,unit, bonus_bounty, nil)
						--	break
						--end
					end
				end
			end
			

			chaotic_era_spawner:PlayerGetGoldBounty(attacker,bonus,self:GetAbility())
			-- attacker:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )  
			SendOverheadEventMessage( PlayerResource:GetPlayer(nPlayerID), OVERHEAD_ALERT_GOLD  ,attacker, bonus, nil)
			self:PlayEffect(unit)
		end
	end
end


function modifier_chaotic_alchemy:PlayEffect(target)
	local particle_cast = "particles/econ/events/newbloom_2020/high_five_newbloom_golden.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,1.5)


end


--------------
modifier_chaotic_alchemy_rune_3 = advanced_modifier({})

function modifier_chaotic_alchemy_rune_3:IsHidden() return true end
function modifier_chaotic_alchemy_rune_3:IsPurgable() return false end
function modifier_chaotic_alchemy_rune_3:IsDebuff() return false end
function modifier_chaotic_alchemy_rune_3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_alchemy_rune_3:OnCreated(keys)
	self.bonus = math.floor(self:GetAbility():GetSpecialValueFor("bonus"))
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_chaotic_alchemy_rune_3:OnRefresh(keys)
	self.bonus = math.floor(self:GetAbility():GetSpecialValueFor("bonus"))

end
function modifier_chaotic_alchemy_rune_3:OnIntervalThink()
	chaotic_era_spawner:PlayerGetGoldBounty(self:GetParent(),self.bonus,self:GetAbility())
	SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_GOLD  ,self:GetParent(), self.bonus, nil)
end