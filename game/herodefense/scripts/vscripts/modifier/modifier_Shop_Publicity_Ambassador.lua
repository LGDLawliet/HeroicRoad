
--------------------------------------------------------------------------------
modifier_Shop_Publicity_Ambassador = advanced_modifier({})

function modifier_Shop_Publicity_Ambassador:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_Publicity_Ambassador:IsDebuff()return false end
function modifier_Shop_Publicity_Ambassador:IsStunDebuff()return false end
function modifier_Shop_Publicity_Ambassador:IsPurgable()return false end
function modifier_Shop_Publicity_Ambassador:GetTexture() return "meepo_divided_we_stand" end
function modifier_Shop_Publicity_Ambassador:IsPurgeException() 	return false end
function modifier_Shop_Publicity_Ambassador:RemoveOnDeath() return false end
function modifier_Shop_Publicity_Ambassador:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end



function modifier_Shop_Publicity_Ambassador:AdvancedGetModifierConstantHealthRegen()   return 4 end

function modifier_Shop_Publicity_Ambassador:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_Publicity_Ambassador:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

