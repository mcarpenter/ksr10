# ksr10

https://github.com/mcarpenter/ksr10

This Ruby Gem provides a simple programming interface to the Velleman KSR10
robotic arm with USB control board. It's simple enough that it can be used from
the REPL. The `krs10` script uses `pry` so that you can just call the instance
methods from the prompt. See the examples below.

For product details see:

 * https://www.velleman.eu/products/view/?id=375310
 * https://www.velleman.eu/products/view/?id=436330


## Examples

### API

```ruby
require 'ksr10'

arm = Ksr10.new
arm.led(:on)
arm.elbow(:down, 500)
arm.gripper(:close, 1000)
arm.stop
```

### REPL

```ruby
$ ksr10
[1] pry(#<Ksr10>)> led(:on)
=> #<Ksr10:0x000055da9db684b0
 @device=#<LIBUSB::Device 3/2 1267:0001 ? ? ? (Vendor specific (00,00))>,
 @state=1,
 @usb=#<LIBUSB::Context:0x000055da9db68488 @ctx=#<FFI::Pointer address=0x000055da9da582d0>, @hotplug_callbacks={}, @on_pollfd_added=nil, @on_pollfd_removed=nil>>
[2] pry(#<Ksr10>)> shoulder(:up, 400)
=> #<Ksr10:0x000055da9db684b0
 @device=#<LIBUSB::Device 3/2 1267:0001 ? ? ? (Vendor specific (00,00))>,
 @state=1,
 @usb=#<LIBUSB::Context:0x000055da9db68488 @ctx=#<FFI::Pointer address=0x000055da9da582d0>, @hotplug_callbacks={}, @on_pollfd_added=nil, @on_pollfd_removed=nil>>
[3] pry(#<Ksr10>)>
```

## Install

```sh
sudo apt install libusb-1.0-0
sudo gem install ksr10
```

Add the following lines to `/etc/udev/rules.d/95-ksr10.rules` so that
unprivileged users can connect to the KSR10:

```
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1267", ATTR{idProduct}=="0000", MODE="0666"
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1267", ATTR{idProduct}=="0001", MODE="0666"
```

If you find that the action is reversed (eg "up" is actually "down") then you
can simply reverse the appropriate Dupont connector on the battery box to
change the polarity.


## Alternatives

 * https://github.com/lvajxi03/roboarm (Python)
 * https://github.com/TristanvanLeeuwen/KSR10 (Python)
 * https://github.com/paly2/ksr10-linux-driver (C++)
