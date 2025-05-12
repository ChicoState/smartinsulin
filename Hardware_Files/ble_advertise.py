import subprocess
import time

# Your 128-bit service UUID in standard format
uuid = '6e400001b5a3f393e0a9e50e24dcca9e'

# Convert to little-endian byte array for HCI
def uuid_to_little_endian_bytes(uuid_str):
    b = bytearray.fromhex(uuid_str)
    b.reverse()
    return b

uuid_bytes = uuid_to_little_endian_bytes(uuid)

# Build advertising payload
adv_data = bytearray()
adv_data += bytes([0x02, 0x01, 0x06])  # Flags: LE General Discoverable Mode
adv_data += bytes([17, 0x07])          # Length, Type: Complete List of 128-bit Service UUIDs
adv_data += uuid_bytes

# Pad to 31 bytes (BLE advertising packet max length)
while len(adv_data) < 31:
    adv_data += bytes([0x00])

# Convert to hex format for hcitool
hex_adv = ' '.join(f"{b:02x}" for b in adv_data)

# Stop advertising first
subprocess.run("sudo hciconfig hci0 noleadv", shell=True)
time.sleep(0.5)

# Set advertising data
subprocess.run(f"sudo hcitool -i hci0 cmd 0x08 0x0008 {len(adv_data):02x} {hex_adv}", shell=True)

# Enable advertising
subprocess.run("sudo hciconfig hci0 leadv 0", shell=True)

print("? BLE advertising with custom UUID started.")
