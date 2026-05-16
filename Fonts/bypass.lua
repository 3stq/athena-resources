repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.HumanoidRootPart

if (not LPH_OBFUSCATED) then
	LPH_ENCNUM = function(toEncrypt, ...)
		assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
		return toEncrypt
	end
	LPH_NUMENC = LPH_ENCNUM

	LPH_ENCSTR = function(toEncrypt, ...)
		assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
		return toEncrypt
	end
	LPH_STRENC = LPH_ENCSTR

	LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
		assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
		return toEncrypt
	end
	LPH_FUNCENC = LPH_ENCFUNC

	LPH_JIT = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
		return f
	end
	LPH_JIT_MAX = LPH_JIT

	LPH_NO_VIRTUALIZE = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
		return f
	end

	LPH_NO_UPVALUES = function(f, ...)
		assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
		assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
		return f
	end

	LPH_CRASH = function(...)
		assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
	end

	if (not LRM_LinkedDiscordID) then LRM_LinkedDiscordID = "1123144940071952394" end;
	if (not LRM_TotalExecutions) then LRM_TotalExecutions = "unknown" end;
	if (not LRM_SecondsLeft) then LRM_SecondsLeft = "9999999" end;
end

local HttpService   = cloneref(game:GetService("HttpService"))
local Players       = cloneref(game:GetService("Players"))
local CoreGui       = cloneref(game:GetService("CoreGui"))
local LocalPlayer   = Players.LocalPlayer

getgenv().DebugMode = true

getgenv().Kick = function(Msg, Title)
    LocalPlayer:Kick()
    task.wait(.75)
    CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = Msg or "Create a ticket"
    CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle.Text = "Athena | " .. (Title or "Rejoin")
    return
end

if not (game.ReplicatedStorage:FindFirstChild("Modules") and game.ReplicatedStorage.Modules:FindFirstChild("AssetContainer")) then getgenv().Kick("Execute In Fallen", "Error") end

if getgenv().BypassLoaded then
    return getgenv().Kick("Script Already Loaded", "Rejoin")
end

task.spawn(LPH_NO_VIRTUALIZE(function()  
    local startTime = os.time()
    while task.wait(1) do
        local elapsed = os.time() - startTime

        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60

        local timeStr = string.format("%02d:%02d:%02d", hours, minutes, seconds)

        if getgenv().DebugMode then
            rconsolesettitle(" Client Bypass | " .. timeStr)
        end
    end
end))

if getgenv().DebugMode then
    rconsoleclear(); task.wait(3); rconsoleprint("\n"); rconsoleprint('@@WHITE@@')
end

getgenv().real_print = clonefunction(print)
getgenv().real_warn = clonefunction(warn)

if getgenv().DebugMode then
    getgenv().print = LPH_JIT_MAX(function(...)
        local args = table.pack(...)
        local out = ""

        for i = 1, args.n do
            out = out .. tostring(args[i])

            if i < args.n then
                out = out .. "\t"
            end
        end

        local timeStr = os.date("%H:%M:%S")

        task.spawn(function() 
            rconsoleprint('@@WHITE@@'); rconsoleprint("        [" .. timeStr .. "] " .. out .. "\n")
        end)
    end)

    getgenv().warn = LPH_JIT_MAX(function(...)
        local args = table.pack(...)
        local out = ""

        for i = 1, args.n do
            out = out .. tostring(args[i])

            if i < args.n then
                out = out .. "\t"
            end
        end

        local timeStr = os.date("%H:%M:%S")
        
        task.spawn(function()
            rconsolewarn("        [" .. timeStr .. "] " .. out .. "\n")
        end)
    end)
end

local DebugPrint = LPH_JIT_MAX(function(...)
    if not getgenv().DebugMode then return end
    
    return getgenv().print(...)
end)

local DebugWarn = LPH_JIT_MAX(function(...)
    if not getgenv().DebugMode then return end

    return getgenv().warn(...)
end)

local AAA = LPH_JIT_MAX(function()
    for _, Obj in getgc(false) do
        if typeof(Obj) == "function" 
        and not isexecutorclosure(Obj) then
            local Info = getinfo(Obj)

            if Info.short_src:find("AssetContainer") then
                if Info.numparams == 1 then
                    local Protos = getprotos(Obj)

                    if #Protos == 0 then continue end
                    local Proto = getproto(Obj, 1, true)
                    if #Proto == 0 then continue end

                    --warn(Proto)
                    for _, ProtoFunc in Proto do
                        local Constants = getconstants(ProtoFunc)
                        local Upvalues = getupvalues(ProtoFunc)

                        if #Constants == 23 then
                            local Old; Old = hookfunction(ProtoFunc, LPH_NO_UPVALUES(function(...) 
                                local Args = {...}
                                local A1

                                local CurrentFov = workspace.CurrentCamera.FieldOfView

                                if #Args == 1 then
                                    A1 = Args[1]

                                    if typeof(A1) == "table" then
                                        DebugPrint("Before Cleaning ->", HttpService:JSONEncode(A1))

                                        for Ind, Val in A1 do
                                            if typeof(Val) == "table" then
                                                for Jew = #Args[1], Ind, -1 do
                                                    Args[1][Jew] = nil
                                                end

                                                break
                                            end
                                        end

                                        DebugPrint("After Cleaning ->", HttpService:JSONEncode(A1))
                                    else
                                        DebugPrint("Args 1 ->", A1)
                                    end
                                else
                                    DebugPrint("Args Count ->", #Args)
                                    DebugPrint("Args ->", HttpService:JSONEncode(Args))
                                end

                                return Old(...)
                            end))
                        elseif #Constants == 9 and #Upvalues == 3 then
                            hookfunction(ProtoFunc, LPH_NO_UPVALUES(function(...) 
                                --DebugWarn("Blocked attribute detection ->", ...)
                                return 
                            end))
                        else
                            local One; One = hookfunction(ProtoFunc, LPH_NO_UPVALUES(function(...) 
                                local Args = {...}
                                local A1 = Args[1]

                                if typeof(A1) ~= "Instance" then
                                    if A1 == "" then
                                        DebugWarn("Blocked empty string")
                                        return
                                    end

                                    if typeof(A1) == "table" then
                                        local Decoded = HttpService:JSONEncode(A1)

                                        if not tostring(Decoded):find("{") 
                                        and not tostring(Decoded):find("-") 
                                        and #A1 ~= 2 then
                                            --DebugPrint("Decoded (1) ->", Decoded)
                                        end
                                    else
                                        if #Args == 0 then
                                            DebugWarn("Blocked zero arg call")
                                            return
                                        else
                                            for _, Arg in Args do
                                                if typeof(Arg) == "function" then
                                                    DebugWarn("Blocked detection ->", ...)
                                                    return
                                                end
                                            end

                                            DebugPrint("Other (1) ->", ...)
                                            DebugPrint("Other (1) Args Count ->", #Args)
                                        end
                                    end
                                end

                                return One(...)
                            end))
                        end
                    end
                end
            end
        end
    end
end)
AAA()

getgenv().BypassLoaded = true
DebugPrint("Bypass Loaded (V2) \n")
wait(3)
