module("luci.controller.slow", package.seeall)

function index()
    entry({"admin", "system", "slowled"}, template("slowled/slow"), "Slow LED Control", 10)
    entry({"admin", "system", "slowled", "activate"}, call("activate_profile"), nil)
    entry({"admin", "system", "slowled", "profile"}, call("get_profile"), nil)
    entry({"admin", "system", "slowled", "update1"}, call("update_settings", 1), nil)
    entry({"admin", "system", "slowled", "config1"}, call("get_config", 1), nil)
    entry({"admin", "system", "slowled", "update2"}, call("update_settings", 2), nil)
    entry({"admin", "system", "slowled", "config2"}, call("get_config", 2), nil)
    entry({"admin", "system", "slowled", "update3"}, call("update_settings", 3), nil)
    entry({"admin", "system", "slowled", "config3"}, call("get_config", 3), nil)
end

function activate_profile()
    local fs = require("nixio.fs")
    local profile_to_select = tonumber(luci.http.formvalue("active_profile"))
    local file_path = "/etc/slowled.target"
    local success, err = fs.writefile(file_path, profile_to_select)
    if not success then
        luci.http.status(500, "Failed to write file: " .. err)
        return
    else
        os.execute("/etc/init.d/slowled restart")
    end
end

function get_profile()
    local fs = require("nixio.fs")
    local content = fs.readfile("/etc/slowled.target")
    local profile = 1
    if content then
        profile = tonumber(content)
    end
    -- Return the settings as a JSON object
    luci.http.prepare_content('application/json')
    luci.http.write_json({ profile = profile })
end

function update_settings(file)
    local fs = require("nixio.fs")
    local os = require("os")

    -- Get the values from the form
    local red_fade_in_delay = tonumber(luci.http.formvalue("redFadeInDelay"))
    local red_fade_in_time = tonumber(luci.http.formvalue("redFadeInTime"))
    local red_fade_hold_time = tonumber(luci.http.formvalue("redFadeHoldTime"))
    local red_fade_out_time = tonumber(luci.http.formvalue("redFadeOutTime"))
    local red_max_brightness = tonumber(luci.http.formvalue("redMaxBrightness"))

    local blue_fade_in_delay = tonumber(luci.http.formvalue("blueFadeInDelay"))
    local blue_fade_in_time = tonumber(luci.http.formvalue("blueFadeInTime"))
    local blue_fade_hold_time = tonumber(luci.http.formvalue("blueFadeHoldTime"))
    local blue_fade_out_time = tonumber(luci.http.formvalue("blueFadeOutTime"))
    local blue_max_brightness = tonumber(luci.http.formvalue("blueMaxBrightness"))

    local green_fade_in_delay = tonumber(luci.http.formvalue("greenFadeInDelay"))
    local green_fade_in_time = tonumber(luci.http.formvalue("greenFadeInTime"))
    local green_fade_hold_time = tonumber(luci.http.formvalue("greenFadeHoldTime"))
    local green_fade_out_time = tonumber(luci.http.formvalue("greenFadeOutTime"))
    local green_max_brightness = tonumber(luci.http.formvalue("greenMaxBrightness"))

    -- Construct the contents of the file
    local contents = string.format("red_fade_in_delay=%d\nred_fade_in_time=%d\nred_fade_hold_time=%d\nred_fade_out_time=%d\nred_max_brightness=%d\n", red_fade_in_delay, red_fade_in_time, red_fade_hold_time, red_fade_out_time, red_max_brightness)
    contents = contents .. string.format("green_fade_in_delay=%d\ngreen_fade_in_time=%d\ngreen_fade_hold_time=%d\ngreen_fade_out_time=%d\ngreen_max_brightness=%d\n", green_fade_in_delay, green_fade_in_time, green_fade_hold_time, green_fade_out_time, green_max_brightness)
    contents = contents .. string.format("blue_fade_in_delay=%d\nblue_fade_in_time=%d\nblue_fade_hold_time=%d\nblue_fade_out_time=%d\nblue_max_brightness=%d\n", blue_fade_in_delay, blue_fade_in_time, blue_fade_hold_time, blue_fade_out_time, blue_max_brightness)

    -- Write the contents to the file
    local file_path = "/etc/slowled".. file ..".conf"
    local success, err = fs.writefile(file_path, contents)
    if not success then
        luci.http.status(500, "Failed to write file: " .. err)
        return
    end

    -- Restart the LED daemon
    os.execute("/etc/init.d/slowled restart")

    -- Redirect back to the main page
    luci.http.redirect(luci.dispatcher.build_url("admin", "system", "slowled"))
end

function get_config(file)
    local fs = require("nixio.fs")

    
    -- Define the default settings table
    local settings = {
        red_fade_in_delay = 1000,
        red_fade_in_time = 5000,
        red_hold_time = 0,
        red_fade_out_time = 5000,
        red_max_brightness = 0,
        green_fade_in_delay = 1000,
        green_fade_in_time = 5000,
        green_hold_time = 0,
        green_fade_out_time = 5000,
        green_max_brightness = 0,
        blue_fade_in_delay = 1000,
        blue_fade_in_time = 5000,
        blue_hold_time = 0,
        blue_fade_out_time = 5000,
        blue_max_brightness = 128
    }

    -- Read the contents of the file
    local content = fs.readfile("/etc/slowled" .. file .. ".conf")
    if content then
        -- Parse the contents of the file
        for line in content:gmatch("[^\r\n]+") do
            local key, value = line:match("([^=]+)=(.+)")
            if key and value then
                settings[key] = tonumber(value) or value
            end
        end
    end

    -- Return the settings as a JSON object
    luci.http.header('Content-Type', 'application/json')
    luci.http.write_json(settings)
end

