## Intro

### Installation

1. Download this repository as a zip, extract somewhere on your HDD.
2. Install luci-compat (If you are using a webui)

`opkg update && opkg install luci-compat`

3. Use SCP to copy the /etc and /usr dirs to the root of your OpenWRT device's filesystem. If not using luci, it's not necessary to copy the user/lib directory.
4. Set permissions on /etc/init.d/slowled:

`chmod 755 /etc/init.d/slowled`

4. Restart the httpd service:

`/etc/init.d/uhttpd restart`

5. Open the WebUI, and navigate to the configurator from the System dropdown.


### Usage
From the main page, you can configure three separate profiles for your LEDs.

Each LED has the same settings:

Fade In Delay - How long to wait before starting fade-in.
Fade In Time - How long to fade up to the max brightness.
Hold Time - How long should the light remain at max brightness.
Fade Out Time - How long to fade the light down to 0 brightness. 
Max Brightness - The Maximum Brightness for the LED.

By adjusting the above settings for each LED, you can create a pretty wide array of effects.

Assigning the various profiles to actions is not presently implemented, but by using the hotplug.rc directory, 
all one needs to do is assign a script to whatever state change is desired, and then echo the desired profile number 
to /etc/slowled.target, then call /etc/init.d/slowled restart to restart the service with the new config.

I'm sure my OCD self will add more stuff to this as it strikes me, but for now, this feels
like a pretty good starting point.

