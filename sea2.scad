// use pots from 9g servo! 5025 pot


$fn = 36;

module part1()
{
    // inner circle
    difference()
    {
        union()
        {
            translate([0,0,0.5]) cylinder(d=20,h=2,center=true);
            cylinder(d=10,h=10);
        }
        translate([0,0,8]) cube([5.5,12,4.1],center=true);
        translate([0,0,8]) cylinder(d=7,h=4.1,center=true);
        cylinder(d=8,h=8,center=true);
        
    }
    
    // mount points
    n = 10;
    for( i=[1:n] )
        rotate([0,0,360/n*i])
        {
//            translate([37/2,0,0])
//                cylinder(d1=2, d2=3, h=5); // outer
            translate([17/2,0,0])
                cylinder(d1=2,d2=3,h=5); // inner
        }
}

module part2()
{
    // outer circle
    difference()
    {
    cylinder(d=40,h=3,center=true);
    cylinder(d=35,h=5,center=true);
    }

    // mount points for elastic spring (loop)
    n = 10;
    for( i=[1:n] )
        rotate([0,0,360/n*i])
        {
            translate([37/2,0,0])
                cylinder(d1=2, d2=3, h=5); // outer
//            translate([17/2,0,0])
//                cylinder(d1=2,d2=3,h=5); // inner
        }
    

    // inner cross with low circle below inner circle
    translate([0,0,-1])
        cube([50,5,1],center=true);
    translate([0,0,-1])
        cube([5,50,1],center=true);
    translate([0,0,-1]) cylinder(d=20,h=1,center=true);
    // now for the bearing:
    translate([0,0,-5]) cylinder(d=7.7,h=5,center=true); // into the bearing 8mm inner
    translate([0,0,-1.5]) cylinder(d=10,h=2,center=true); // support for the bearing
    // mount for the potentiometer:
    translate([0,0,-5-6]) cube([1,2,7],center=true);
        
    // and for the upper circle:
    cylinder(d=6,h=6,center=true); // support for the bearing
}

module part3()
{
    // place for a bearing
    difference()
    {
        union()
        {
            translate([0,0,-10])
                cylinder(d=20,h=5);
            translate([0,-10,-10])
                cube([30,20,5]);
        }
        translate([0,0,-8])
            cylinder(d=18,h=5); // bearing - 16 by 5 - +1.0 loose on each end, otherwise cracks when inserting bearing
        translate([0,0,-12])
            cylinder(d=14,h=6);
    }
    
    // pot
    //translate([0,0,-13])
    //    cube([10,11,4],center=true);
    
    
    difference()
    {
        translate([0,0,-13])
            cube([18,18,7],center=true);

        translate([0,0,-11])
            cube([13,19,3.1],center=true);
    
        // pot - but loooooonger and higher
        translate([0,0,-13])
            cube([10,24,10],center=true);
    
    }
    
    
    translate([30,-10,-10])
        cube([5,20,20]);

    difference()
    {
        translate([-10,-10,10])
            cube([45,20,20]);
        translate([0,0,25])
            cube([23+40,12,32],center=true);
    }

}

part3();
part2();
part1();

