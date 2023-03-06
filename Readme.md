## Intro

How do I use this?

I still need to make a package, so for now, you need to download the files in this repo,
extract them somewhere on your computer, and then use sftp to copy them onto your AP in their respective folders.

Reload your webUI, and you should have "Slow LED Control" in your system dropdown.

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
to /etc/slowled.target, then call /etc/init.d/slowled restart_service to restart the service with the new config.

I'm sure my OCD self will add more stuff to this as it strikes me, but for now, this feels
like a pretty good starting point.

