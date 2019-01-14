// use pots from 9g servo! 5025 pot


$fn = 36;

module part1()
{
    // inner circle
    difference()
    {
        translate([0,0,0.5]) cylinder(d=20,h=2,center=true);
        cylinder(d=10,h=5,center=true);
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
    // inner cross with low circle below inner circle
    difference()
    {
        union()
        {
            translate([0,0,-1])
                cube([50,5,1],center=true);
            translate([0,0,-1])
                cube([5,50,1],center=true);
            color([1,0,0])
        cylinder(d=9,h=4,center=true);
//            difference()
//            {
                translate([0,0,-1]) cylinder(d=20,h=1,center=true);
//                cylinder(d=10,h=5,center=true);
//            }
        }
//        cylinder(d=10,h=5,center=true);
          cylinder(d=6.1,h=5,center=true);
    }

    // mount points
    n = 10;
    for( i=[1:n] )
        rotate([0,0,360/n*i])
        {
            translate([37/2,0,0])
                cylinder(d1=2, d2=3, h=5); // outer
//            translate([17/2,0,0])
//                cylinder(d1=2,d2=3,h=5); // inner
        }
    }

//part3();
part2();
part1();