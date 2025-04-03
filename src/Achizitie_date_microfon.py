from machine import ADC
import time

mic = ADC(26)  

def colecteaza_date(durata_sec, nume_fisier="date_audio2.txt"):
    num_samples_per_sec = 10000  # Numărul de eșantioane pe secundă
    total_samples = durata_sec * num_samples_per_sec
    interval = 1.0 / num_samples_per_sec  # Timp între eșantioane

    with open(nume_fisier, "w") as f:
        for _ in range(total_samples):
            nivel_audio = mic.read_u16()
            f.write(f"{nivel_audio}\n")
            time.sleep(interval)  

    print(f"Date salvate în {nume_fisier}")

colecteaza_date(2)
