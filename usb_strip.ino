
int led1 = 0, led2 = 1, led3 = 2, led4 = 3;


void cycle( int delay_time ) {
    
    for( ;; ) {
        digitalWrite( led1, HIGH );
        delay( delay_time );
        digitalWrite( led1, LOW );
        digitalWrite( led2, HIGH );
        delay( delay_time );
        digitalWrite( led2, LOW );
        digitalWrite( led3, HIGH );
        delay( delay_time );
        digitalWrite( led3, LOW );
        digitalWrite( led4, HIGH );
        delay( delay_time );
        digitalWrite( led4, LOW );
    }
}


void setup() {
    pinMode( led1, OUTPUT );
    pinMode( led2, OUTPUT );
    pinMode( led3, OUTPUT );
    pinMode( led4, OUTPUT );
}

void loop() {

    int delay_time = 50;

    cycle( delay_time );

}
