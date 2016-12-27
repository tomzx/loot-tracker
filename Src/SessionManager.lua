SessionManager = {}
SessionManager.Sessions = {}

function SessionManager:Initialize()

end

function SessionManager:AddSession(session)
	table.insert(self.Sessions, session)
	debug("Session added!")
end

function SessionManager:Start(session)
	debug("Session started!")
	session.State = Session.States.Running
end

function SessionManager:Pause(session)
	debug("Session paused!")
	session.State = Session.States.Paused
end

function SessionManager:Stop(session)
	debug("Session stopped!")
	session.State = Session.States.Stopped
end

function SessionManager:AddSeen(lootSlotInfo)
	debug("[SessionManager] Seen " .. lootSlotInfo[2])
	for index, session in pairs(self.Sessions) do
		if session.State == Session.States.Running then
			session:AddSeen(lootSlotInfo)
		end
	end
end

function SessionManager:AddLooted(lootSlotInfo)
	for index, session in self.Sessions do
		if session.State == Session.States.Running then
			session:AddLooted(lootSlotInfo)
		end
	end
end