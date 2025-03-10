from machine import ADC
import time

mic = ADC(26)  

while True:
    suma = 0
    num_samples = 100  
      
    for _ in range(num_samples):
        suma += mic.read_u16()  
        time.sleep_us(100)  
    
    nivel_audio = suma // num_samples  
    print(f"Nivel audio: {nivel_audio}")
    time.sleep(0.1)  

