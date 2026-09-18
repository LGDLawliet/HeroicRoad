LinkLuaModifier("modifier_allseeing_oness_favor_debuff", "modifier/chaotic_era_artifact/modifier_allseeing_oness_favor", LUA_MODIFIER_MOTION_NONE)

modifier_allseeing_oness_favor = advanced_modifier({})

function modifier_allseeing_oness_favor:IsHidden()return true end
function modifier_allseeing_oness_favor:IsDebuff()return false end
function modifier_allseeing_oness_favor:IsPurgable()return false end
function modifier_allseeing_oness_favor:IsPurgeException() 	return false end
function modifier_allseeing_oness_favor:RemoveOnDeath() return false end
function modifier_allseeing_oness_favor:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_allseeing_oness_favor:DestroyOnExpire() return false end
function modifier_allseeing_oness_favor:GetTexture() return "chaotic_era_spell/the_omexe_arena" end
function modifier_allseeing_oness_favor:OnCreated(keys)
	self.bonus_health_regen = GetChaticEra_Artifact_Special(self,"bonus_health_regen")
	if IsServer() then
		local parent = self:GetParent()

		local damage_index = GetChaticEra_Artifact_Special(self,"damage_index")
		local keys = {
			idKey = "allseeing_oness_favor",
			icon = "file://{images}/custom_game/chaotic_era/hud/artifact/allseeing_oness_favor.png",
			title = "allseeing_oness_favor",
			text = "HUD_allseeing_oness_favor_Info",
			keys={
				damage_index = {
					text= damage_index,
					bLocalize = 0,
				},
			}
		}

		local parent = self:GetParent()
		chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
		-- 检测是否成功的回调
		function (data)
			if chaotic_era_spawner:CheckHaveSameIdKey(data, "allseeing_oness_favor") then
				local nPlayerID = parent:GetPlayerOwnerID()
				SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
				return false
			end
			return true
		end,
		-- 是否清除(即仅能修饰一次)
		function ()
			return true
		end,
		-- 实例化修饰
		function (unit,attribute)
			unit:AddNewModifier(parent, nil, "modifier_allseeing_oness_favor_debuff", {})
		end)

	end
end
function modifier_allseeing_oness_favor:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE

    }
end

function modifier_allseeing_oness_favor:AdvancedGetModifierConstantHealthRegenAmpPercentage()

	return self.bonus_health_regen
end




modifier_allseeing_oness_favor_debuff = advanced_modifier({})

function modifier_allseeing_oness_favor_debuff:IsHidden()return false end
function modifier_allseeing_oness_favor_debuff:IsDebuff()return true end
function modifier_allseeing_oness_favor_debuff:IsPurgable()return false end
function modifier_allseeing_oness_favor_debuff:IsPurgeException() 	return false end
function modifier_allseeing_oness_favor_debuff:RemoveOnDeath() return false end
function modifier_allseeing_oness_favor_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_allseeing_oness_favor_debuff:DestroyOnExpire() return false end
function modifier_allseeing_oness_favor_debuff:GetTexture() return "chaotic_era_spell/allseeing_oness_favor" end
function modifier_allseeing_oness_favor_debuff:GetEffectName() return "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_overhead_debuff.vpcf" end

function modifier_allseeing_oness_favor_debuff:OnCreated(keys)
	if IsServer() then
		self.damage_index = GetChaticEra_Artifact_Special("allseeing_oness_favor","damage_index")*0.01
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage*interval*ability:GetSpecialValueFor("damage_per_tick")*0.01,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
		}
		self:StartIntervalThink(1)
		
	end

end

function modifier_allseeing_oness_favor_debuff:OnIntervalThink()
	local damage = self.damage_index*self:GetCaster():GetHealthRegen()
	if damage<=0 then
		return
	end
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end