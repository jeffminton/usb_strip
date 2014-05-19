
$fn = 60;

usb_length = 13.42;
usb_half = usb_length / 2;
usb_width = 6.36;
usb_half_width = usb_width / 2;
usb_to_hole_dist = 6.45;
hole_diameter = 3.27;
hole_radius = hole_diameter / 2;
hole_to_hole = usb_length + ( usb_to_hole_dist * 2 );
led_hole_diameter = 3;
led_hole_radius = led_hole_diameter / 2;
top_width = 1.5;
width = top_width * 2;
tab_width = 3;
post_hole_radius = 2;

module usb_slot() {
    minkowski() {
        cube( [usb_length - .5, usb_width - .5, width - 1], center = true );
        cylinder( r = .5, h = 1, center = true );
    }
}

module screw_hole() {
    cylinder( h = width, r = hole_radius, center = true );
}

module led_hole() {
    cylinder( h = width, r = led_hole_radius, center = true );
}

module led_set() {
    led_row_dist = 1.9;
    led_col_dist = 1.6;
    for( i = [0:1] ) {
        for( j = [0:1] ) {
            translate( [i * (1.6 + led_hole_diameter), j * (1.9 + led_hole_diameter), 0] ) led_hole();
        }
    }
}

//shapes for a single USB end
module single_usb() {
    width = width + 1;
    screw_hole();
    translate( [ hole_radius + usb_half + usb_to_hole_dist, 0, 0] ) usb_slot( width );
    translate( [ hole_diameter + hole_to_hole, 0, 0] ) screw_hole( width );
}

module dual_usb_w_led() {

    screw_hole();
    translate( [60.69 + hole_diameter, 0, 0 ] ) screw_hole();
    //18.7
    translate( [hole_radius + 10.68, -2.45, 0 ] ) led_set();
    translate( [hole_radius + 18.67 + usb_half, 1.25, 0] ) usb_slot();
    translate( [hole_radius + 18.67 + 5.43 + usb_length + usb_half, 1.25, 0] ) usb_slot();
}

module screw_tab_hole () {
    rotate( a = 90, v = [0, 0, 1] )
    rotate( a = 180, v = [1, 0, 0] ) 
    rotate( a = 270, v = [0, 1, 0] )
    translate( [hole_radius * 4, 0, 0] ) cylinder( h = tab_width + 15, r = hole_radius, center = true );
}


module screw_tab() {
    difference() {
        union() {
            rotate( a = 90, v = [0, 0, 1] )
            rotate( a = 180, v = [1, 0, 0] ) 
            rotate( a = 270, v = [0, 1, 0] ) {
                cube( [(hole_radius * 2) * 4, (hole_radius * 2) * 4, tab_width], center = true );
                translate( [hole_radius * 4, 0, 0] ) cylinder( h = tab_width, r = hole_radius * 4, center = true );
            }
        }
        screw_tab_hole();
        //translate( [hole_radius * 4, 0, 0] ) cylinder( h = tab_width + 2, r = hole_radius, center = true );
    }
}

plate_size = 110;
plate_edges = plate_size / 2;
tab_offset = ( plate_size / 2 ) - 2;

module banana_posts() {
    post_space = plate_size / 5;
    post_offset = tab_offset - 15;
    echo( "post offset: ", post_offset );
    for( i = [0:3] ) {
        translate( [-post_offset, -plate_edges + ( ( i + 1 ) * post_space ), 0] ) {
            cylinder( h = width, r = post_hole_radius, center = true );
        }
    }
}


module top() {
    difference () {
        cube( [plate_size, plate_size, top_width], center = true );

        translate( [-25, 28.5, 0] ) dual_usb_w_led();

        translate( [0, -( ( hole_to_hole / 2 ) + hole_radius ), 0] ) {
            for( i = [0:3] ) {
                translate( [(12 * i), 0, 0] ) {
                    rotate( a = 90, v = [0, 0, 1] ) {
                        single_usb( 2, (12 * i ), 0, 90 );
                    }
                }
            }
        }

        banana_posts();

        translate( [-25, -28.5, 0] ) dual_usb_w_led();
    }

    half_tab = ( (hole_radius * 2) * 4 ) / 2;
    translate( [-tab_offset + half_tab, -tab_offset + (tab_width / 2), -half_tab] ) screw_tab();
    translate( [-tab_offset + half_tab, tab_offset - (tab_width / 2), -half_tab] ) screw_tab();
    translate( [ tab_offset - half_tab, -tab_offset + (tab_width / 2), -half_tab] ) screw_tab();
    translate( [ tab_offset - half_tab, tab_offset - (tab_width / 2), -half_tab] ) screw_tab();
    translate( [-tab_offset + (tab_width / 2), 0, -half_tab] ) rotate( a = 90, v = [0, 0, 1] ) screw_tab();
    translate( [tab_offset - (tab_width / 2), 0, -half_tab] ) rotate( a = 90, v = [0, 0, 1] ) screw_tab();
    translate( [0, tab_offset - (tab_width / 2), -half_tab] ) screw_tab();
    translate( [0, -tab_offset + (tab_width / 2), -half_tab] ) screw_tab();

}

height = 75;
height_half = height / 2;

module bottom() {
    side_width = 1.8;
    top_width_half = top_width / 2;
    z_fall = height_half + top_width_half;
    plate_offset = plate_edges - (side_width / 2);
    half_tab = ( (hole_radius * 2) * 4 ) / 2;
    difference() {
        union() {
            translate( [0, -plate_offset, -z_fall] )
            cube( [plate_size, side_width, height], center = true );
            
            translate( [-plate_offset, 0, -z_fall] )
            rotate( a = 90, v = [0, 0, 1] )
            cube( [plate_size, side_width, height], center = true );
            
            translate( [plate_offset, 0, -z_fall] )
            rotate( a = 90, v = [0, 0, 1] )
            cube( [plate_size, side_width, height], center = true );
            
            translate( [0, plate_offset, -z_fall] )
            cube( [plate_size, side_width, height], center = true );
            
            translate( [0, 0, -height ] )
            cube( [plate_size, plate_size, top_width], center = true );

            translate( [-plate_offset + half_tab, -plate_offset - (half_tab / 2), -height + (top_width / 2)] ) 
            rotate( a = 270, v = [1, 0, 0] ) 
            screw_tab();
            
            translate( [-plate_offset + half_tab, plate_offset + (half_tab / 2), -height + (top_width / 2)] ) 
            rotate( a = 90, v = [1, 0, 0] )
            screw_tab();
            
            translate( [plate_offset - half_tab, -plate_offset - (half_tab / 2), -height + (top_width / 2)] ) 
            rotate( a = 270, v = [1, 0, 0] )
            screw_tab();

            translate( [plate_offset - half_tab, plate_offset + (half_tab / 2), -height + (top_width / 2)] ) 
            rotate( a = 90, v = [1, 0, 0] )
            screw_tab();

        }
        translate( [-tab_offset + half_tab, -tab_offset + (tab_width / 2), -half_tab] ) screw_tab_hole();
        translate( [-tab_offset + half_tab, tab_offset - (tab_width / 2), -half_tab] ) screw_tab_hole();
        translate( [ tab_offset - half_tab, -tab_offset + (tab_width / 2), -half_tab] ) screw_tab_hole();
        translate( [ tab_offset - half_tab, tab_offset - (tab_width / 2), -half_tab] ) screw_tab_hole();
        translate( [-tab_offset + (tab_width / 2), 0, -half_tab] ) rotate( a = 90, v = [0, 0, 1] ) screw_tab_hole();
        translate( [tab_offset - (tab_width / 2), 0, -half_tab] ) rotate( a = 90, v = [0, 0, 1] ) screw_tab_hole();
        translate( [0, tab_offset - (tab_width / 2), -half_tab] ) screw_tab_hole();
        translate( [0, -tab_offset + (tab_width / 2), -half_tab] ) screw_tab_hole();
        translate( [-plate_offset, 0, -height + 15] ) rotate( a = 270, v = [0, 1, 0] ) cylinder( r = 10, h = 20, center = true );
    }



}


//top();
bottom();
