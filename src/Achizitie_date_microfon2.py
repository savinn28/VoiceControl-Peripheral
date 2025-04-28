import machine
import utime

adc = machine.ADC(26)

# Collect ADC values
a = []
lim=0
utime.sleep_us(50000)
print("done0")
while lim<22*2727:
    # Read ADC value
    adc_value = adc.read_u16()
    x = adc_value
    a.append(x)
    lim=lim+22
    utime.sleep_us(22)


print("done1")

# Save vector values to a file
with open("values_u.txt", "w") as file:
    for value in a:
        file.write(str(value) + "\n")
print("done2")

