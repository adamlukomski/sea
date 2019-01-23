use <gearModule.scad>

$fn = 36;
dia = 42;
ball_tol = 0.2;
ball = 4;
show_balls = false;


module track(quality=36,diameter=42)
{
    rotate_extrude($fn=quality)
        translate( [diameter/2,0,0] )
            circle(d=ball+ball_tol,$fn=quality);
}
//
//module track_up(airgap=0.6)
//{
//    difference()
//    {
//        translate([0,0,airgap/2])
//            cylinder( d=50, h=3-airgap/2 );
//        track();
//    }
//}
//
//module track_down(airgap=0.6)
//{
//    difference()
//    {
//        translate([0,0,-3])
//            cylinder( d=50, h=3-airgap/2 );
//        track();
//    }
//}
//
//// carve a hole in the bottom
//track_down();
//track_up();

module big_plate()
{
     // outer circle
    difference() {
        cylinder(d=40,h=4,center=true);
        cylinder(d=34,h=5,center=true);
    }
    // lower circle
    difference()
    {
        translate([0,0,-3.5]) cylinder(d=40,h=2+1,center=true);
        translate([0,0,-3+1]) track(quality=36,diameter=26); // +1 comes from cylinder dia - it's centered
    }
    
    if( show_balls ) {
        translate([26/2,0,-3+1])
            sphere(d=4);
    }
    
    // mount points
    n = 10;
    for( i=[1:n] )
        rotate([0,0,360/n*i])
        {
            translate([37/2,0,0.5])
            {
                cylinder(d1=2, d2=3, h=5); // outer
                cylinder(d1=3,d2=2,h=5); // inner
            }
//            translate([17/2,0,0])
//                cylinder(d1=2,d2=3,h=5); // inner
        }
}

module big_full()
{
    difference() {
        union() {
            cylinder( d=dia, h=3.5, center=true );
            translate([0,0,3.5/2+6])
            gear(toothNo=24, toothWidth=2,
                     toothHeight=3, thickness=6,
                     holeRadius=0,holeSides=4); // its by default UNDER the axis plane
            translate([0,0,12])
                big_plate();
        }
        
        track(quality=36,diameter=dia);
        cylinder( d=5, h=30, center=true ); // screw hole - TODO: d=5 ? just guessing the size of the screwhead
    }
    
    //// single ball
    if( show_balls ) {
        translate([dia/2,0,0])
            sphere(d=4);
    }
}

module small_plate()
{
    translate([0,0,12])
    {
        difference()
        {
            translate([0,0,0.5]) cylinder(d=32,h=2,center=true);
            translate([0,0,-3+1])
                track(quality=36,diameter=26);
        }
        // mount points
        n = 10;
        for( i=[1:n] )
            rotate([0,0,360/n*i])
            {
    //            translate([37/2,0,0])
    //                cylinder(d1=2, d2=3, h=5); // outer
                translate([17/2,0,0])
                {
                    cylinder(d1=2,d2=3,h=6); // inner
                    cylinder(d1=3.5,d2=2,h=5); // inner
                }
                
            }
    }
}

module outer_module()
{
    difference() {
        cylinder( d=dia+5, h=3.5, center=true );
        cylinder( d=dia, h=4.5, center=true );
        track(quality=36,diameter=dia);
    }
}


//small_plate();
big_full();
//outer_module();