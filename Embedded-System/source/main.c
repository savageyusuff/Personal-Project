/*****************************************************************************
 *  EE2024 Assignment 2 AY16/17 Semester 2
 *	Student: Mulliana Yusuff
 *			 Ng Kai Wen, Steven
 *
 *   Copyright(C) 2011, EE2024
 *   All rights reserved.
 *
 ******************************************************************************/
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <stdlib.h>

//---LPC178 header file declaration
#include "LPC17xx.h" //CMSIS header required to use systick
#include "lpc17xx_pinsel.h"
#include "lpc17xx_gpio.h"
#include "lpc17xx_i2c.h"
#include "lpc17xx_ssp.h"
#include "lpc17xx_uart.h"
#include "lpc17xx_nvic.h"

//----Baseboard Level of header file
//--Only RGB header file not used because of the clash with OLED file
#include "acc.h"
#include "oled.h"
#include "led7seg.h"
#include "light.h"
#include "temp.h"
#include "joystick.h"

//---Definitions
#define RGB_RED   0x01
#define RGB_BLUE  0x02
#define RGB_OFF   0x00

typedef enum {
	MODE_STABLE, MODE_MONITOR, MODE_SETTING
} system_mode_t;

volatile system_mode_t mode;
volatile uint32_t msTicks; // counter for 1ms SysTicks

//-----GLOBAL DECLARTION OF FLAGS
volatile bool light_interupt = FALSE;
bool update = FALSE;//this flag is to update the initial acceleration when the board fist goes into monitor mode
bool orientation = FALSE;
bool compare = FALSE;
bool transmission = FALSE;
bool display = FALSE;
bool BLINK_RED = FALSE;
bool BLINK_BLUE = FALSE;
bool mode_RGB = FALSE;// TRUE for RED, FALSE for BLUE

//-----Temperature Setting
volatile uint32_t temperature_setting = 450;
volatile uint32_t light_setting = 50;

void pinsel_uart3(void) {
	PINSEL_CFG_Type PinCfg;
	PinCfg.Funcnum = 2;
	PinCfg.Pinnum = 0;
	PinCfg.Portnum = 0;
	PINSEL_ConfigPin(&PinCfg);
	PinCfg.Pinnum = 1;
	PINSEL_ConfigPin(&PinCfg);
}

void init_uart(void) {
	UART_CFG_Type uartCfg;
	uartCfg.Baud_rate = 115200;
	uartCfg.Databits = UART_DATABIT_8;
	uartCfg.Parity = UART_PARITY_NONE;
	uartCfg.Stopbits = UART_STOPBIT_1;
	//pin select for uart3
	pinsel_uart3();
	//supply power and setup working parts for uart3
	UART_Init(LPC_UART3, &uartCfg);
	//enable transmit for uart3
	UART_TxCmd(LPC_UART3, ENABLE);
}

static void init_ssp(void)
{
	SSP_CFG_Type SSP_ConfigStruct;
	PINSEL_CFG_Type PinCfg;

	/*
	 * Initialize SPI pin connect
	 * P0.7 - SCK;
	 * P0.8 - MISO
	 * P0.9 - MOSI
	 * P2.2 - SSEL - used as GPIO
	 */
	PinCfg.Funcnum = 2;
	PinCfg.OpenDrain = 0;
	PinCfg.Pinmode = 0;
	PinCfg.Portnum = 0;
	PinCfg.Pinnum = 7;
	PINSEL_ConfigPin(&PinCfg);
	PinCfg.Pinnum = 8;
	PINSEL_ConfigPin(&PinCfg);
	PinCfg.Pinnum = 9;
	PINSEL_ConfigPin(&PinCfg);
	PinCfg.Funcnum = 0;
	PinCfg.Portnum = 2;
	PinCfg.Pinnum = 2;
	PINSEL_ConfigPin(&PinCfg);

	SSP_ConfigStructInit(&SSP_ConfigStruct);

	// Initialize SSP peripheral with parameter given in structure above
	SSP_Init(LPC_SSP1, &SSP_ConfigStruct);

	// Enable SSP peripheral
	SSP_Cmd(LPC_SSP1, ENABLE);

}

static void init_i2c(void)
{
	PINSEL_CFG_Type PinCfg;

	/* Initialize I2C2 pin connect */
	PinCfg.Funcnum = 2;
	PinCfg.Pinnum = 10;
	PinCfg.Portnum = 0;
	PINSEL_ConfigPin(&PinCfg);
	PinCfg.Pinnum = 11;
	PINSEL_ConfigPin(&PinCfg);

	// Initialize I2C peripheral
	I2C_Init(LPC_I2C2, 100000);

	/* Enable I2C1 operation */
	I2C_Cmd(LPC_I2C2, ENABLE);
}

static void init_GPIO(void)
{
	//Initialize button SW3 (not really necessary since default configuration)
	PINSEL_CFG_Type PinCfg;
	PinCfg.Funcnum = 0;
	PinCfg.OpenDrain = 0;
	PinCfg.Pinmode = 0;
	PinCfg.Portnum = 0;
	PinCfg.Pinnum = 4;
	PINSEL_ConfigPin(&PinCfg);
	GPIO_SetDir(0, 1<<4, 0);	// GPIO_SetDir( port no.,bit value, direction)

	// Initialize button SW4----P1.31 on LPC178
	//---(not really necessary since default configuration)
	PinCfg.Funcnum = 0;
	PinCfg.OpenDrain = 0;	// usually 0
	PinCfg.Pinmode = 0;		// usually 0
	PinCfg.Portnum = 1;
	PinCfg.Pinnum = 31;
	PINSEL_ConfigPin(&PinCfg);
	GPIO_SetDir(1, 1<<31, 0);  // GPIO_SetDir(port no.,bit value, direction)

	// Initialize Temperature port as input---P0.2 on LPC178
	//---(not really necessary since default configuration)
	PinCfg.Funcnum = 0;
	PinCfg.OpenDrain = 0;  // usually 0
	PinCfg.Pinmode = 0;    // usually 0
	PinCfg.Portnum = 0;
	PinCfg.Pinnum = 2;
	PINSEL_ConfigPin(&PinCfg);
	//---Set Direction done in temp_int()

	//Initialize the RGB ports (red-P2.0 ; blue-P0.26)
	PinCfg.Funcnum = 0;
	PinCfg.OpenDrain = 0;  // usually 0
	PinCfg.Pinmode = 0;    // usually 0
	PinCfg.Portnum = 2;
	PinCfg.Pinnum = 0;
	PINSEL_ConfigPin(&PinCfg);
	GPIO_SetDir( 2, (1<<0), 1 );// GPIO_SetDir(port no.,bit value, direction)
	PinCfg.Funcnum = 0;
	PinCfg.OpenDrain = 0;  // usually 0
	PinCfg.Pinmode = 0;    // usually 0
	PinCfg.Portnum = 0;
	PinCfg.Pinnum = 26;
	PINSEL_ConfigPin(&PinCfg);
	GPIO_SetDir( 0, (1<<26), 1 );

}

void SysTick_Handler(void){

	msTicks++;
}

uint32_t getTicks() {

	return msTicks;
}

void rgb_setLeds (uint8_t ledMask){

	if ((ledMask & RGB_RED) != 0){
	        GPIO_SetValue( 2, (1<<0) );
	}
	else{
		GPIO_ClearValue( 2, (1<<0) );
	}
    if ((ledMask & RGB_BLUE) != 0) {
        GPIO_SetValue( 0, (1<<26) );
    } else {
        GPIO_ClearValue( 0, (1<<26) );
    }

}

void EINT3_IRQHandler(void) {

	if((LPC_GPIOINT->IO2IntStatF>>3)&0x01){
			if(mode==MODE_SETTING){
				temperature_setting = temperature_setting + 10;
			}
			LPC_GPIOINT->IO2IntClr = 1<<3;
	}

	if((LPC_GPIOINT->IO0IntStatF>>15)&0x01){
		if(mode==MODE_SETTING){
			temperature_setting = temperature_setting - 10;
		}
			LPC_GPIOINT->IO0IntClr = 1<<15;
	}

	if((LPC_GPIOINT->IO0IntStatF>>16)&0x01){
		if(mode==MODE_SETTING){
			light_setting = light_setting + 10;
		}
			LPC_GPIOINT->IO0IntClr = 1<<16;
	}

	if((LPC_GPIOINT->IO2IntStatF>>4)&0x01){
		if(mode==MODE_SETTING){
			light_setting = light_setting - 10;
		}
			LPC_GPIOINT->IO2IntClr = 1<<4;
	}

}

int main (void) {

uint32_t light_oled[40] ={};
uint32_t temp_oled[40] ={};
uint32_t acc_oled[40] ={};

uint32_t light;
int32_t temp_value;
int8_t x,y,z;
int8_t init_x,init_y,init_z;
int movement = 0;
int counter7Seg = 0;
int previous_counter7Seg = -1;
uint32_t startTicks;
uint32_t reactionTime;
uint32_t rgbTicks;
int time=0;

uint32_t state = 0;//Use for counting the number of transmission
uint32_t SW4_button_previous;
uint32_t SW4_button_current;
uint32_t SW3_button_previous;
uint32_t SW3_button_current;
uint8_t chars[16] = {0x24,0x7D,0xE0,0x70,0x39,0x32,0x22,0x7C,0x20,0x38,0x28,0x20,0xA6,0x24,0xA2,0xAA};

unsigned char transmission_array[100] = "";
unsigned char fire_array[100] = "Fire was Detected\r\n";
unsigned char movement_array[100] = "Movement was Detected\r\n";
unsigned char monitor_array[100] = "Entering MONITOR Mode\r\n";


mode = MODE_STABLE;
//---PINSEL declarations
init_i2c();
init_ssp();
init_GPIO();//includes SW4,temp and rgb

//---UART DECLARATION
init_uart();

//---Library Enable function
acc_init();
light_enable();
temp_init(&getTicks);
oled_init();
led7seg_init();
joystick_init();

SysTick_Config(SystemCoreClock/1000);

//----Setting the priority EINT_3
NVIC_SetPriorityGrouping(5);
//sequence => PG=5, PP=0b11, SP=0b000;
// ans = 24 = 0x18
NVIC_SetPriority(EINT3_IRQn,NVIC_EncodePriority(5,0b11,0b000));
// Priority in the IPR for InterruptID 21 is set to 0xC0 = 1100 0000
// NVIC_SetPriority() Shifts the second argument (0x18 in this case)
// left by (8-__NVIC_PRIO_BITS) before writing to IPR.
NVIC_ClearPendingIRQ(EINT3_IRQn);
NVIC_EnableIRQ(EINT3_IRQn);

//----Enable GPIO interrupt
LPC_GPIOINT -> IO2IntEnF |= 1<<3; //rotary UP P2.3
LPC_GPIOINT -> IO0IntEnF |= 1<<15; //rotary DOWN P0.15
LPC_GPIOINT -> IO0IntEnF |= 1<<16; //rotary LEFT P0.16
LPC_GPIOINT -> IO2IntEnF |= 1<<4; //rotary RIGHT P2.4


light_setRange(LIGHT_RANGE_4000);
oled_clearScreen(OLED_COLOR_BLACK);

reactionTime = msTicks;
startTicks = msTicks;
rgbTicks = msTicks;
SW4_button_previous = (GPIO_ReadValue(1)) >> 31;
SW3_button_previous = ((GPIO_ReadValue(0)) >> 4)&0x0001;

while(1){
	if((msTicks - reactionTime)>= 250){
		SW4_button_current = (GPIO_ReadValue(1)) >> 31;
		SW3_button_current = ((GPIO_ReadValue(0)) >> 4)&0x0001;

		if((SW4_button_previous == 1) && (SW4_button_current == 0)){
				if (mode == MODE_MONITOR){
					mode = MODE_STABLE;
					//---RESET ALL THE FLAGS
					BLINK_RED = FALSE;
					BLINK_BLUE = FALSE;
					bool update = FALSE;
					bool orientation = FALSE;
					bool compare = FALSE;
					bool transmission = FALSE;
					bool display = FALSE;
					time = 0;
				}
				else if (mode == MODE_STABLE){
					mode = MODE_MONITOR;
					counter7Seg = 0;
					startTicks = msTicks;
					update = TRUE;
					orientation = TRUE;
					UART_Send(LPC_UART3, (uint8_t *)monitor_array , strlen(monitor_array), BLOCKING);
				}
		}
		else if((SW3_button_previous == 1) && (SW3_button_current == 0)){
			if (mode == MODE_SETTING){
				mode = MODE_STABLE;
			}
			else if (mode == MODE_STABLE){
				mode = MODE_SETTING;

			}
		}
		SW4_button_previous = SW4_button_current;
		SW3_button_previous = SW3_button_current;
		reactionTime = msTicks;
	}

	if(((msTicks - startTicks)>= 1000) && (mode == MODE_MONITOR)) {
		time++;
		counter7Seg++; // increment counter7Seg by 1
			if(counter7Seg >=16){
				counter7Seg = 0;
			}
			if(((counter7Seg%5)==0)&&(counter7Seg != 0)){
				update = TRUE;
				display = TRUE;
				compare = TRUE;
			}
			if(counter7Seg == 15){
				transmission = TRUE;
			}
			startTicks = msTicks; // reset every 1 sec
	}

	if((msTicks-rgbTicks)>=330){
		mode_RGB = !mode_RGB;
		rgbTicks = msTicks;
	}

	if(mode == MODE_STABLE){
		oled_clearScreen(OLED_COLOR_BLACK);//OFF the OLED
		led7seg_setChar(0xFF,TRUE);// OFF the 7SEG
		rgb_setLeds(RGB_OFF); // OFF RGB

	}//---MODE_STABLE

	else if(mode == MODE_SETTING){
		//re-using temp_oled array

		sprintf(temp_oled,"Set Threshold");
		oled_putString(1,0,(uint8_t *) temp_oled, OLED_COLOR_WHITE,OLED_COLOR_BLACK);
		sprintf(temp_oled,"Light: %d lux",light_setting);
		oled_putString(1,16,(uint8_t *) temp_oled, OLED_COLOR_WHITE,OLED_COLOR_BLACK);
		sprintf(temp_oled,"Temp: %.1f C",temperature_setting/10.0);
		oled_putString(1,24,(uint8_t *) temp_oled, OLED_COLOR_WHITE,OLED_COLOR_BLACK);

	}

	else if(mode == MODE_MONITOR){
		//--reuse temp_oled array
		sprintf(temp_oled,"Monitor%7ds",time);
		oled_putString(0,8,(uint8_t *) temp_oled,OLED_COLOR_WHITE,OLED_COLOR_BLACK);

		if (counter7Seg != previous_counter7Seg){
			led7seg_setChar(chars[counter7Seg],TRUE);
			previous_counter7Seg = counter7Seg;
		}

		if(mode_RGB==TRUE){
			if(BLINK_RED == TRUE){
				rgb_setLeds(RGB_RED);
			}
			else{
				rgb_setLeds(RGB_OFF);
			}
		}
		else if(mode_RGB==FALSE){
			if(BLINK_BLUE == TRUE){
				rgb_setLeds(RGB_BLUE);
			}
			else{
				rgb_setLeds(RGB_OFF);
			}
		}

			if(update == TRUE){
				temp_value = temp_read();
				acc_read(&x,&y,&z);
				z = z - 64;
				light = light_read();
				update = FALSE;

				if(orientation == TRUE){
					init_x = x;
					init_y = y;
					init_z = z;
					orientation = FALSE;
				}

				if(compare == TRUE){
					movement= (abs(x-init_x)*abs(x-init_x)) + (abs(y-init_y)*abs(y-init_y)) + (abs(z-init_z)*abs(z-init_z));
					if((temp_value >= temperature_setting)&&(BLINK_RED == FALSE)){
						BLINK_RED = TRUE;
					}
					if(((light<light_setting)&&(movement>50))&&(BLINK_BLUE == FALSE)){
						BLINK_BLUE = TRUE;
					}
					compare = FALSE;
				}

				if(display == TRUE){
					sprintf(light_oled,"Light: %3u",light);
					oled_putString(0, 16, (uint8_t *) light_oled,OLED_COLOR_WHITE,OLED_COLOR_BLACK);
					sprintf(temp_oled,"Temp: %4.1f",(temp_value/10.0));
					oled_putString(0, 24, (uint8_t *) temp_oled,OLED_COLOR_WHITE,OLED_COLOR_BLACK);
					sprintf(acc_oled,"acc_x: %3d",x);
					oled_putString(0, 32, (uint8_t *) acc_oled,OLED_COLOR_WHITE,OLED_COLOR_BLACK);
					sprintf(acc_oled,"acc_y: %3d",y);
					oled_putString(0, 40, (uint8_t *) acc_oled,OLED_COLOR_WHITE,OLED_COLOR_BLACK);
					sprintf(acc_oled,"acc_z: %3d",z);
					oled_putString(0, 48, (uint8_t *) acc_oled,OLED_COLOR_WHITE,OLED_COLOR_BLACK);
					display = FALSE;
				}

				if (transmission == TRUE){
					if(BLINK_RED == TRUE){
						//printf("Fire was Detected\r\n");
						UART_Send(LPC_UART3, (uint8_t *)fire_array , strlen(fire_array), BLOCKING);
					}
					if(BLINK_BLUE == TRUE){
						//printf("Movement in darkness was Detected\r\n");
						UART_Send(LPC_UART3, (uint8_t *)movement_array , strlen(movement_array), BLOCKING);
					}

					sprintf(transmission_array,"%03u_-_T%4.1f_L%03u_AX%03d_AY%03d_AZ%03d\r\n",state,(temp_value/10.0),light,x,y,z);
					//printf("%s",transmission_array);
					UART_Send(LPC_UART3, (uint8_t *)transmission_array , strlen(transmission_array), BLOCKING);
					state++;
					transmission = FALSE;
				}
			  }//--Update


	}//---MODE_MONITOR
}// end while

return 0;
}// end main



void check_failed(uint8_t *file, uint32_t line)
{
	/* User can add his own implementation to report the file name and line number,
	 ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

	/* Infinite loop */
	while(1);
}
