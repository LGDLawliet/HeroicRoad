
modifier_chaotic_era_super_boxing = advanced_modifier({})

function modifier_chaotic_era_super_boxing:IsHidden()return false end
function modifier_chaotic_era_super_boxing:IsDebuff()return false end
function modifier_chaotic_era_super_boxing:IsPurgable()return false end
function modifier_chaotic_era_super_boxing:IsPurgeException() 	return false end
function modifier_chaotic_era_super_boxing:RemoveOnDeath() return true end
function modifier_chaotic_era_super_boxing:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_super_boxing:GetTexture() return self.texture end
function modifier_chaotic_era_super_boxing:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_era_super_boxing/effect_main/effect", context )
end
function modifier_chaotic_era_super_boxing:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus1 = GetChaticEraCreep_BuffSpecial(self,"value1")
	self.bonus2 = GetChaticEraCreep_BuffSpecial(self,"value2")
    if IsServer() then
		-- self:SetStackCount(GetChaticEraCreep_BuffSpecial(self,"value1"))
    end
end



function modifier_chaotic_era_super_boxing:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}

	return funcs
end

function modifier_chaotic_era_super_boxing:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end


	if keys.target:IsMagicImmune() or keys.target:IsGiant() or keys.target:HasModifier("modifier_item_hd_dingzhi_shitking_effects") then
		return
	end
	if keys.damage<=0 then
		return
	end
	self:IncrementStackCount()
	if self:GetStackCount()>=self.bonus1 then
		self:SetStackCount(0)
		local caster_pos = keys.attacker:GetAbsOrigin()
		local pfx_min = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_era_super_boxing/effect_main/effect", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_min, 0,caster_pos)
		-- ParticleManager:SetParticleControl(pfx_min, 3, Vector(0, 100, 0))
		ParticleManager:SetParticleControlForward(pfx_min, 1, keys.attacker:GetForwardVector())  --方向
		ParticleManager:ReleaseParticleIndex(pfx_min)
		keys.attacker:EmitSound("Hero_Dark_Seer.NormalPunch.Lv1")

		local knockback =
		{
			knockback_duration = 0.2,
			duration = 0.2,
			knockback_distance = self.bonus2,
			knockback_height = 50,
			center_x = caster_pos.x,
			center_y = caster_pos.y,
			center_z = caster_pos.z,
		}
		keys.target:RemoveModifierByName("modifier_knockback")
		keys.target:AddNewModifier(keys.attacker, nil, "modifier_knockback", knockback)	
	end
	



end


function modifier_chaotic_era_super_boxing:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_super_boxing:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.bonus1
	elseif self._tooltip == 2 then
		return  self.bonus2
	end
end

