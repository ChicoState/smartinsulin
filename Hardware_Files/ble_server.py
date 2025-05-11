import asyncio
import os
from dbus_next import BusType, Variant, PropertyAccess
from dbus_next.aio import MessageBus
from dbus_next.service import ServiceInterface, method, dbus_property

#os.system('python3 ble_advertise.py')

# Define UUIDs
SERVICE_UUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9e'
WRITE_CHAR_UUID = '6e400002-b5a3-f393-e0a9-e50e24dcca9e'
NOTIFY_CHAR_UUID = '6e400003-b5a3-f393-e0a9-e50e24dcca9e'

# Write Characteristic
class WriteCharacteristic(ServiceInterface):
    def __init__(self, path):
        super().__init__('org.bluez.GattCharacteristic1')
        self.path = path

    @dbus_property(access=PropertyAccess.READ)
    def UUID(self) -> 's':
        return WRITE_CHAR_UUID

    @dbus_property(access=PropertyAccess.READ)
    def Service(self) -> 'o':
        return '/service0'

    @dbus_property(access=PropertyAccess.READ)
    def Flags(self) -> 'as':
        return ['write']

    @method()
    def WriteValue(self, value: 'ay', options: 'a{sv}'):
        message = bytes(value).decode('utf-8')
        print(f"Received from Flutter: {message}")

# Notify Characteristic
class NotifyCharacteristic(ServiceInterface):
    def __init__(self, path):
        super().__init__('org.bluez.GattCharacteristic1')
        self.path = path
        self.notifying = False

    @dbus_property(access=PropertyAccess.READ)
    def UUID(self) -> 's':
        return NOTIFY_CHAR_UUID

    @dbus_property(access=PropertyAccess.READ)
    def Service(self) -> 'o':
        return '/service0'

    @dbus_property(access=PropertyAccess.READ)
    def Flags(self) -> 'as':
        return ['notify']

    @method()
    def StartNotify(self):
        print("Flutter app subscribed for notifications!")
        self.notifying = True

    @method()
    def StopNotify(self):
        print("Flutter app unsubscribed from notifications.")
        self.notifying = False

# Service
class MyService(ServiceInterface):
    def __init__(self):
        super().__init__('org.bluez.GattService1')

    @dbus_property(access=PropertyAccess.READ)
    def UUID(self) -> 's':
        return SERVICE_UUID

    @dbus_property(access=PropertyAccess.READ)
    def Primary(self) -> 'b':
        return True

# Main function
async def main():
    bus = await MessageBus(bus_type=BusType.SYSTEM).connect()

    service = MyService()
    write_char = WriteCharacteristic('/service0/char0')
    notify_char = NotifyCharacteristic('/service0/char1')

    bus.export('/service0', service)
    bus.export('/service0/char0', write_char)
    bus.export('/service0/char1', notify_char)

    print("? GATT server running. Waiting for Flutter app to connect...")

    while True:
        if notify_char.notifying:
            await bus.emit_properties_changed(
                '/service0/char1',
                {'Value': Variant('ay', list(b'Hello from Pi!'))}
            )
            await asyncio.sleep(5)
        else:
            await asyncio.sleep(1)

if __name__ == '__main__':
    asyncio.run(main())
