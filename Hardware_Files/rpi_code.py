import time
import RPi.GPIO as GPIO
from smbus2 import SMBus
from Adafruit_ADS1x15 import ADS1115
from RPLCD.i2c import CharLCD


#----Setup----#
# GPIO 
GPIO.setmode(GPIO.BCM)
motor = 18
place_holder = 17

GPIO.setup(motor, GPIO.OUT)
GPIO.setup(place_holder, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

# LCD 
lcd = CharLCD('PCF8574', 0x27)  

# ADC setup (e.g., ADS1115)
adc = ADS1115()
GAIN = 1  

#water level 
water_low = 100  #adjust as needed for amount of ml notification

def dispensing_insulin(time):
    #dispenses the pump for a period of time.
    GPIO.output(motor, GPIO.HIGH)
    time.sleep(time)
    GPIO.output(motor, GPIO.LOW)

def water_level():
    #returns true when the water is too low
    val = adc.read_adc(0, gain=GAIN)
    return val < water_low

def display_on_lcd(message):
    #displays message on LCD 
    lcd.clear()
    lcd.write_string(message)

# Main loop (runs forever)
while True:
    if GPIO.input(place_holder) == GPIO.HIGH:
        #ideally we wait for a signal from app 
        if water_level():
            display_on_lcd("Water too low!")
            #send signal to app
        else:
            display_on_lcd("Water level OK")
            #send signal to app
        if (True):#will get a signal from app
            dispensing_insulin(10)
