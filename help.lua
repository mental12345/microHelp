local micro = import("micro")
local config = import("micro/config")
local filepath = import("path/filepath")
local buffer = import("micro/buffer")
local osmicro = import("os")

function init()
	config.MakeCommand("docs", docs, config.NoComplete)
	config.MakeCommand("man", man, config.NoComplete)

end

function createDir(bp)
    local home = osmicro.Getenv("HOME")
    local docpath = filepath.Join(home, "docs")
    if not osmicro.Stat(docpath) then
        osmicro.Mkdir(docpath)
    end
end


function docs(bp, args)
    if #args < 1 then
        micro.InfoBar():Error("Usage: docs [-e] <topic>")
        return
    end
    local home = osmicro.Getenv("HOME")
    -- check for -e flag
    local editable = false
    local topic_args = {}
    for i = 1, #args do
        local v = args[i]
        if v == "-e" then
            editable = true
    -- check for list flag
        elseif v == "-list" then
            local docroot = filepath.Join(home, "microDocs")
            local handle = io.popen("find " .. docroot .. " -type f -name '*.txt' 2>/dev/null | sort")
            if handle == nil then
                micro.InfoBar():Error("Could not list docs in: " .. docroot)
                return
            end
            local lines = {}
            lines[#lines + 1] = "Installed docs in " .. docroot .. ":"
            lines[#lines + 1] = ""
            for line in handle:lines() do
                lines[#lines + 1] = line:gsub("^" .. docroot .. "/?" , "")
            end
            handle:close()
            if #lines == 2 then
                lines[#lines + 1] = "(no .txt files found)"
            end
            local content = table.concat(lines, "\n")
            micro.CurPane():VSplitIndex(buffer.NewBuffer(content, "docs list"), true)
            local list_view = micro.CurPane()
            list_view:ResizePane(30)
            list_view.Buf.Type.Scratch = true
            list_view.Buf.Type.Readonly = true
            list_view.Buf:SetOptionNative("softwrap", true)
            list_view.Buf:SetOptionNative("ruler", false)
            list_view.Buf:SetOptionNative("autosave", false)
            list_view.Buf:SetOptionNative("scrollbar", true)
            list_view.Buf:SetOptionNative("statusformatl", "docs list")
            list_view.Buf:SetOptionNative("statusformatr", "readonly")
            return
        else
            topic_args[#topic_args + 1] = v
        end
    end

    if #topic_args < 1 then
        micro.InfoBar():Error("Usage: docs [-e] <topic>")
        return
    end

    local topic = table.concat(topic_args, " ")
    if not topic:match("%.txt$") then
        topic = topic .. ".txt"
    end

    
    local docpath = filepath.Join(home, "microDocs", topic)

    local file = io.open(docpath, "r")
    if file == nil then
        micro.InfoBar():Error("Doc not found: " .. docpath)
        return
    end
    file:close()

    micro.CurPane():VSplitIndex(buffer.NewBufferFromFile(docpath), true)
    help_view = micro.CurPane()
    help_view:ResizePane(40)
    help_view.Buf:SetOptionNative("softwrap", true)
    help_view.Buf:SetOptionNative("ruler", false)
    help_view.Buf:SetOptionNative("scrollbar", true)

    if not editable then
        help_view.Buf.Type.Scratch = true
        help_view.Buf.Type.Readonly = true
        help_view.Buf:SetOptionNative("autosave", false)
        help_view.Buf:SetOptionNative("statusformatr", "readonly")
        help_view.Buf:SetOptionNative("statusformatl", topic)
    else
        help_view.Buf:SetOptionNative("statusformatr", "editable")
        help_view.Buf:SetOptionNative("statusformatl", topic)
    end

    
end


function man(bp, args)
    if #args < 1 then 
        micro.InfoBar():Error("Usage: man <command>")
        return
    end

    local parts = {}
    for i = 1, #args do
        parts[#parts + 1] = args[i]
    end

    local cmd = table.concat(parts, " ")
    local handle = io.popen("man " .. cmd .. " 2>&1")
    if handle == nil then
        micro.InfoBar():Error("Could not execute man for: " .. cmd)
        return
    end

    local output = handle:read("*a")
    handle:close()

    if output == nil or output == "" then
        micro.InfoBar():Error("No man output for: " .. cmd)
        return
    end

    micro.CurPane():VSplitIndex(buffer.NewBuffer(output, "man " .. cmd), true)
    local man_view = micro.CurPane()
    man_view:ResizePane(40)
    man_view.Buf.Type.Scratch = true
    man_view.Buf.Type.Readonly = true
    man_view.Buf:SetOptionNative("softwrap", true)
    man_view.Buf:SetOptionNative("ruler", false)
    man_view.Buf:SetOptionNative("autosave", false)
    man_view.Buf:SetOptionNative("scrollbar", true)
    man_view.Buf:SetOptionNative("statusformatr", "readonly")
    man_view.Buf:SetOptionNative("statusformatl", "man " .. cmd)
end