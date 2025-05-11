import machine
import utime


adc = machine.ADC(26)
signal = []
sampling_frequency_hz = 45000           # frecventa de esantionare: 45 kHz
recording_duration_ms = 60              # durată totală: 60 ms 

# calculam nr total de esantioane
num_samples = int((recording_duration_ms / 1000) * sampling_frequency_hz)
# 60/1000 * 45000 = 0.06 *45000 = 2700
# calculam intervalul de esantionare in microsecunde
sampling_interval_us = int(1_000_000 / sampling_frequency_hz)
# 1m / 45000 = 22 microsec

utime.sleep_ms(500)                     # scurta pauza de calibrare
print("Achizitie începuta...")

for i in range(num_samples):
    value = adc.read_u16()
    signal.append(value)
    utime.sleep_us(sampling_interval_us)

print("Achizitie finalizata.")

with open("values_oo3.txt", "w") as file:
    for value in signal:
        file.write(str(value) + "\n")

print("Date salvate")
