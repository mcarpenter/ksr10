
require 'libusb'

# An object representing a Velleman KSR10 USB robotic arm.
class Ksr10

  # Gem version.
  VERSION = '1.0.0'

  # USB product IDs of 0x0 and 0x1 have been seen in the wild so we look for
  # either and take the first found when initializing a Ksr10 object.
  PRODUCT_IDS = [0x0, 0x1]

  # USB vendor ID.
  VENDOR_ID = 0x1267

  # Exceptions that might be thrown by the Ksr10 constructor.
  class Error < StandardError

    class DeviceNotFound < Error
      MESSAGE = 'USB device not found'
    end # DeviceNotFound

    class PermissionDenied < Error
      MESSAGE = 'Permission denied to open interface to USB device'
    end # PermissionDenied

  end # Error

  def initialize
    @usb = LIBUSB::Context.new
    PRODUCT_IDS.each do |product_id|
      @device = @usb.devices(idVendor: VENDOR_ID, idProduct: product_id).first
      break if @device
    end
    raise Error::DeviceNotFound unless @device
    # Check we can access the device. Libusb requires that #open_interface take
    # a block, so we cannot keep and reuse the returned handle.
    begin
      @device.open_interface(0) { |_| }
    rescue LIBUSB::ERROR_ACCESS
      raise Error::PermissionDenied
    end
    stop # initializes @state
  end

  # Rotate the base.
  def base(left_right_stop, duration_ms=0)
    set_state(left_right_stop, duration_ms, {left: {on: 9, off: 8}, right: {on: 8, off: 9}})
  end

  # Action the shoulder motor.
  def shoulder(up_down_stop, duration_ms=0)
    set_state(up_down_stop, duration_ms, {up: {on: 22, off: 23}, down: {on: 23, off: 22}})
  end

  # Action the elbow motor.
  def elbow(up_down_stop, duration_ms=0)
    set_state(up_down_stop, duration_ms, {up: {on: 20, off: 21}, down: {on: 21, off: 20}})
  end

  # Action the wrist motor.
  def wrist(up_down_stop, duration_ms=0)
    set_state(up_down_stop, duration_ms, {up: {on: 18, off: 19}, down: {on: 19, off: 18}})
  end

  # Action the gripper.
  def gripper(open_close_stop, duration_ms=0)
    set_state(open_close_stop, duration_ms, {open: {on: 17, off: 16}, close: {on: 16, off: 17}})
  end

  # Turn on or off the LED.
  def led(on_off, duration_ms=0)
    set_state(on_off, duration_ms, {on: {on: 0}, off: {off: 0}})
  end

  # Stop all actions and turn off the LED.
  def stop(duration_ms=0)
    @state = 0
    write_state!(duration_ms)
    self
  end

  private

  # The Hash spec defines the bits to flip in the USB control write for each
  # permitted state. Bits are numbered from LSB and are 0-indexed.  Returns
  # "self" so that calls may be chained in the style of Fowler's "fluent
  # interface".
  def set_state(state, duration_ms, spec)
    if state == :stop
      spec.each do |_, bit_flips|
        @state &= ~(1<<bit_flips[:off]) if bit_flips.has_key?(:off)
      end
    else
      bit_flips = spec[state]
      raise ArgumentError, "Invalid argument #{state.inspect} for #{caller_locations[0].label}" unless bit_flips
      # Flip off bits first to avoid an invalid state "go up AND down
      # simultaneously".
      @state &= ~(1<<bit_flips[:off]) if bit_flips.has_key?(:off)
      @state |= 1<<bit_flips[:on] if bit_flips.has_key?(:on)
    end
    write_state!(duration_ms)
    # If we received a duration then flip off the bits we just flipped on.
    if !duration_ms.zero? && bit_flips && bit_flips.has_key?(:on)
      @state &= ~(1<<bit_flips[:on])
      write_state! # return immediately, no duration_ms
    end
    self
  end

  # Write the state stored in the instance variable to the device.
  def write_state!(duration_ms=0)
    data = [@state.to_s(16).rjust(6, '0')].pack('H*')
    @device.open_interface(0) do |handle|
      handle.control_transfer(bmRequestType: 0x40,
                              bRequest: 0x06,
                              wValue: 0x0100,
                              wIndex: 0x00,
                              dataOut: data)
    end
    sleep(duration_ms / 1000.0)
  end

end # Ksr10
