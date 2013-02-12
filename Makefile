CFLAGS += -DSTM32F4 -Wall -Wextra -O0 -g -mthumb -mcpu=cortex-m4 -march=armv7 -mfloat-abi=hard
LDFLAGS += -mthumb -mcpu=cortex-m4 -march-armv7 -entry=_start -T stm32f4-discovery.ld

test.bin: test.elf
	arm-none-eabi-objcopy -Obinary test.elf test.bin

test.elf: test.o start.o
	arm-none-eabi-gcc -o test.elf test.o start.o $(LDFLAGS)

test.o: test.c
	arm-none-eabi-gcc $(CFLAGS) -o test.o -c test.c

start.o: start.S
	arm-none-eabi-gcc $(CFLAGS) -o start.o -c start.S

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.elf