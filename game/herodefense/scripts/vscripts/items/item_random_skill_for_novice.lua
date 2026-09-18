item_random_skill_for_novice = class({})

-- LinkLuaModifier("modifier_item_hd_aghanims_shard", "items/item_hd_aghanims_shard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_random_skill_for_novice_active", "items/item_random_skill_for_novice", LUA_MODIFIER_MOTION_NONE)



-- function item_hd_aghanims_shard:GetIntrinsicModifierName()
-- 	return "modifier_item_hd_aghanims_shard"
-- end

function item_random_skill_for_novice:OnSpellStart()
    if IsClient() then
		return
	end

	local caster    =   self:GetCaster()
	if caster:HasModifier("modifier_item_random_skill_for_novice_active") then
		return
	end
	local pass = false
	
    local Ability = self:GetParent():GetAbilityByIndex(1)
    local name = Ability:GetAbilityName()
    local cost = Ability.upgrade_cost
    local newAbilityName = Ability.level3_id
    local total_cost = cost*28  +5000
    --print("total_cost",total_cost)
    if Ability ~= nil then
        
        if Ability.classlevel ==2 then
            --获取技能的等级是否为3
            if Ability:GetLevel() == 3 then
               --获取技能升级所需的金钱
               
               
               --玩家当前金钱是否足够
               if caster:GetGold()>=total_cost then
                    

                pass = true
                end                   
            end

        end
    end
	


	if pass then
		local particle = ParticleManager:CreateParticle("particles/rebuild/items/ultimate_scepter/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,500))
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		DestroyParticleByDelay(particle,3)
		caster:AddNewModifier(caster, self, "modifier_item_random_skill_for_novice_active", {})
		caster:EmitSound("hud.equip.agh_scepter")
        --扣除玩家total_cost金钱
        caster:SpendGold(total_cost, DOTA_ModifyGold_AbilityCost )
		self:SpendCharge(0)
       
        --删除当前中阶技能并添加一级对应的高阶技能
        caster:RemoveAbility(name)
        local newAbility = caster:AddAbility(newAbilityName)
        newAbility:SetLevel(1)
        newAbility.classlevel = 3                   --设置为三阶   
        newAbility.advanced_level = 25          --设置初始的高阶等级
        newAbility.upgrade_cost = 0  --设置升级花费
        newAbility.totalcost = 0
        newAbility.CoreUnlock = true
        local NetTable_key = tostring(caster:GetPlayerID()).."_"..name
        CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =25 } )  --更新网表
	end


end

function item_random_skill_for_novice:GetCustomCastError()
    if IsClient() then
		return
	end
    if self.misstaketype == 1 then
        return "#Spells_CustomCastError_NOT_middle"
    elseif self.misstaketype == 2 then
        return "#Spells_CustomCastError_NOT_lvl3"
    elseif self.misstaketype == 3 then
        return "#Spells_CustomCastError_NOT_rich"
    elseif self.misstaketype == 0 then
        return "#Spells_CustomCastError_NOT_correct_spell"
    end
	
end
function item_random_skill_for_novice:CastFilterResult()
    if IsClient() then
		return
	end
        print("CastFilterResult")
    self.misstaketype =0
    local caster = self:GetCaster()
    
    if caster:HasModifier("modifier_item_random_skill_for_novice_active") then
		return UF_FAIL_CUSTOM
	end
	print("CastFilterResult")
   
    local Ability = self:GetParent():GetAbilityByIndex(1)
    local cost = Ability.upgrade_cost
    local total_cost = cost*28  +5000
		if Ability ~= nil then
           
			if Ability.classlevel ==2 then
				--获取技能的等级是否为3
                if Ability:GetLevel() == 3 then
                    --获取技能升级所需的金钱
                   
                    
                    --玩家当前金钱是否足够
                    if caster:GetGold()>=total_cost then
                        self.misstaketype =4


                     return   UF_SUCCESS
                    else
                        self.misstaketype = 3
                        --print("misstaketype = 3")
                        
                    end
                else
                    self.misstaketype = 2
                    --print("misstaketype = 2")   
                    
                end

			else 
                self.misstaketype = 1
                --print("misstaketype = 1")
                
            end
            
    end
    return UF_FAIL_CUSTOM
end



-- modifier_item_hd_aghanims_shard = class({})

-- function modifier_item_hd_aghanims_shard:IsDebuff() return false end
-- function modifier_item_hd_aghanims_shard:IsHidden() return true end
-- function modifier_item_hd_aghanims_shard:IsPurgable() return false end
-- function modifier_item_hd_aghanims_shard:IsPurgeException() return false end


modifier_item_random_skill_for_novice_active = class({})

function modifier_item_random_skill_for_novice_active:IsDebuff() return false end
function modifier_item_random_skill_for_novice_active:IsHidden() return false end
function modifier_item_random_skill_for_novice_active:IsPurgable() return false end
function modifier_item_random_skill_for_novice_active:IsPurgeException() return false end
function modifier_item_random_skill_for_novice_active:RemoveOnDeath() return false end
function modifier_item_random_skill_for_novice_active:GetTexture() return "marci_unleash_upgrade"  end