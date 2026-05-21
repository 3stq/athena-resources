do
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
    repeat task.wait() until game:IsLoaded();
    repeat task.wait() until game.Players
        and game.Players.LocalPlayer
        and game.Players.LocalPlayer.Character
        and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    local http_service = cloneref(game:GetService("HttpService"));
    local players_service = cloneref(game:GetService("Players"));
    local core_gui = cloneref(game:GetService("CoreGui"));
    local local_player = players_service.LocalPlayer;

    getgenv().kick = function(msg, title)
        local_player:Kick();
        task.wait(0.75);
        core_gui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = msg or "join the discord";
        core_gui.RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle.Text = "[athena] " .. (title or "Rejoin");
        return;
    end;

    getgenv().debug_mode = true

    if not (game.ReplicatedStorage:FindFirstChild("Modules") and game.ReplicatedStorage.Modules:FindFirstChild("AssetContainer")) then
        return getgenv().kick("[athena]", "Error");
    end;

    if not getgenv().bypass_loaded then
        getgenv().real_print = clonefunction(print);
        getgenv().real_warn = clonefunction(warn);

        local function noop() end;
        local debug_print = getgenv().debug_mode and getgenv().print or noop;
        local debug_warn = getgenv().debug_mode and getgenv().warn or noop;

        local apply_asset_container_hook = LPH_JIT_MAX(function()
            for _, obj in getgc(false) do
                if typeof(obj) == "function" and not isexecutorclosure(obj) then
                    local info = getinfo(obj);
                    if info.short_src:find("AssetContainer") then
                        if info.numparams == 1 then
                            local protos = getprotos(obj);
                            if #protos == 0 then continue end;
                            local proto = getproto(obj, 1, true);
                            if #proto == 0 then continue end;

                            for _, proto_func in proto do
                                local constants = getconstants(proto_func);
                                local upvalues = getupvalues(proto_func);

                                if #constants == 23 then
                                    local original;
                                    original = hookfunction(proto_func, LPH_NO_UPVALUES(function(...)
                                        local args = { ... };
                                        local a1;
                                        if #args == 1 then
                                            a1 = args[1];
                                            if typeof(a1) == "table" then
                                                debug_print("Before Cleaning ->", http_service:JSONEncode(a1));
                                                for ind, val in a1 do
                                                    if typeof(val) == "table" then
                                                        for jew = #args[1], ind, -1 do
                                                            args[1][jew] = nil;
                                                        end;
                                                        break;
                                                    end;
                                                end;
                                                debug_print("After Cleaning ->", http_service:JSONEncode(a1));
                                            else
                                                debug_print("Args 1 ->", a1);
                                            end;
                                        else
                                            debug_print("Args Count ->", #args);
                                            debug_print("Args ->", http_service:JSONEncode(args));
                                        end;
                                        return original(...);
                                    end));
                                elseif #constants == 9 and #upvalues == 3 then
                                    hookfunction(proto_func, LPH_NO_UPVALUES(function(...)
                                        return;
                                    end));
                                else
                                    local original;
                                    original = hookfunction(proto_func, LPH_NO_UPVALUES(function(...)
                                        local args = { ... };
                                        local a1 = args[1];
                                        if typeof(a1) ~= "Instance" then
                                            if a1 == "" then
                                                debug_warn("Blocked empty string");
                                                return;
                                            end;
                                            if typeof(a1) ~= "table" then
                                                if #args == 0 then
                                                    debug_warn("Blocked zero arg call");
                                                    return;
                                                else
                                                    for _, arg in args do
                                                        if typeof(arg) == "function" then
                                                            debug_warn("Blocked detection ->", ...);
                                                            return;
                                                        end;
                                                    end;
                                                    debug_print("Other (1) ->", ...);
                                                    debug_print("Other (1) Args Count ->", #args);
                                                end;
                                            end;
                                        end;
                                        return original(...);
                                    end));
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end);
        apply_asset_container_hook();

        getgenv().bypass_loaded = true;
    end;
end;
