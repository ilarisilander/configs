local micro = import("micro")
local config = import("micro/config")


function init()
        config.MakeCommand("grow", paneGrow, config.NoComplete)
        config.MakeCommand("shrink", paneShrink, config.NoComplete)

        config.TryBindKey("Alt--", "command:shrink", false)
        config.TryBindKey("Alt-+", "command:grow", false)
end

function resize(bp, n)
        local tab = bp:Tab()
        if #tab.Panes < 2 then
                return
        end
        local id = tab.Panes[2]:ID()
        local node = tab:GetNode(id)
        tab.Panes[2]:ResizePane(node.X + n)
end

function paneGrow(bp)
        resize(bp, 3)
end

function paneShrink(bp)
        resize(bp, -3)
end
