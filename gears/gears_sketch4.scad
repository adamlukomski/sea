/*  Parametric planetary gearbox with double helical gears
 *  
 * 
 * 
 * 
 * 
 * based on Parametric Epicyclic Gearbox. Helical Support.
 * by PolyVinalDistillate Jul 2, 2017 
 *
 * Creative Commons - Attribution - Non-Commercial license. 
 *
 *
 * ratio taken from
 * 100:1 Compound Planetary Gear Reducer
 * by Gear_Down_For_What Aug 13, 2017 
 * https://www.thingiverse.com/thing:2477945
 * Creative Commons - Attribution license. 
 */

// 
// 
//
// 


$fn = 50;

use <mcad/involute_gears.scad>                    


module Planetary(   ID = 35,                //Annulus pitch-diameter
                    Na = 42,                //Number of teeth on Annulus
                    Height = 3,            //Height of geared section
                    BL = 0.4,               //Gear backlash (I find 0.2 works well on my printer)
                    TargetRatio = 4.5,      //Intended reduction ratio
                    InnerBore = 5.4,          //Bore of motor shaft
                    NumPlanets = 3,         //number of planets in gearbox
                    PressureAngle = 28,     //Gear pressure angle (in case it's useful to change it)
                    Annulus = true,         //Enable Annulus rendering
                    Planets = true,         //Enable Planet gears rendering
                    Sun = true,             //Enable Sun gear rendering
                    Vertical = false,        // vertical stick out of planets - for alignment
                    SunTwist = -20,
                    PlanetTwist = 20,
                    AnnulusTwist = 6.7
                )
{
    //Intended for annulus to be stationary.
    //Ratio is 1/(1+Na/Ns)
    //100 = 1+Na/Ns
    //100-1 = Na/Ns
    //Ns = Na/(100-1)
    ACP = (ID/Na)*180;
    Ns = ceil(Na/(TargetRatio-1));  //Number of teeth on Sun Gear
    SD = Ns*(ACP/180);              //Sun Diameter
    PD = (ID-SD)/2;                 //Planet Diameter
    Np = round(PD/(ACP/180));       //Number of teeth on Planet Gear
    
    POr = ACP/180 + PD/2;   //Planet outer rad
    SOr = ACP/180 + SD/2;   //Sun outer rad
    
//    PHeight = Height-((LwrCarrierThk+CarrierClearanceB)+(UprCarrierThk+CarrierClearanceT));
    PHeight = Height;

    // annulus:
    if( Annulus)
    for( mir=[0,1] )
    mirror([0,0,mir])
    linear_extrude( height=3, center=false, twist=AnnulusTwist, slices=10)
    projection()
    difference()
    {
        cylinder( d=ID+5,h=Height );
        
        translate([0,0,-0.1])
        gear(   number_of_teeth = Na, 
                circular_pitch = ACP, 
                gear_thickness = Height+2, 
                rim_thickness = Height+2, 
                hub_thickness = Height+2, 
                circles = 0, 
                bore_diameter = 0, 
                backlash = -BL,
                clearance = -0.2,
                pressure_angle = PressureAngle);
    }
    // planets
    if(Planets)
    {    
        for(i = [0:NumPlanets-1])
        {
            rotate(i*(360/NumPlanets), [0, 0, 1])
//            translate([(SD+PD)/2, 0, LwrCarrierThk+CarrierClearanceB])
            translate([(SD+PD)/2, 0, 0])
            {
                
                for( mir=[0,1] )
                mirror([0,0,mir])
                linear_extrude( height=3, center=false, twist=PlanetTwist, slices=10)
                projection()
                rotate((i*(360/NumPlanets))*(Na/Np), [0, 0, 1]) // it was Na*Na/Np - for odd planets, Na/Np - for even planets
                intersection()
                {
                    gear(   number_of_teeth = Np, 
                            circular_pitch = ACP, 
                            gear_thickness = PHeight, 
                            rim_thickness = PHeight, 
                            hub_thickness = PHeight, 
                            circles = 0, 
                            bore_diameter = 0, //PlanetBore+PBoreClearance, 
                            backlash = BL,
                            pressure_angle = PressureAngle);
                    translate([0, 0, -0.01])
                        cylinder(r = POr-BL, h = PHeight+0.02);
                }
                if( Vertical )
                    cylinder(d=1,h=10);
            }
        }
    }
  
        
        EOP = 1-Np%2;     //Even/odd teeth on planet
    
    if(Sun)
    for( mir=[0,1] )
    mirror([0,0,mir])
    linear_extrude( height=3, center=false, twist=SunTwist, slices=10)
    projection()
    {
        //render()
        color([1, 1, 0])
        rotate( (180/Ns)*EOP, [0, 0, 1])
        intersection()
        {
            gear(   number_of_teeth = Ns, 
                    circular_pitch = ACP, 
                    gear_thickness = Height, 
                    rim_thickness = Height, 
                    hub_thickness = Height, 
                    circles = 0, 
                    bore_diameter = InnerBore, 
                    backlash = BL,
                    pressure_angle = PressureAngle);
            translate([0, 0, -0.05])
                cylinder(r = SOr-BL, h = Height+0.1);
            
        }
    }    
     echo ("----------------------------------------------->  Target Ratio: ", TargetRatio, " Actual Ratio: ", 1+Na/Ns);
    echo ("----------------------------------------------->  Sun Teeth: ", Ns);
    echo ("----------------------------------------------->  Planet Teeth: ", Np);
    echo ("----------------------------------------------->  Annulus Teeth: ", Na);
    
}



module upper(Annulus, Planets, Sun, Planet, Vertical)
{
Planetary(   ID = 25.5,                //Annulus pitch-diameter
                    Na = 50,                //Number of teeth on Annulus
                    Height = 3,            //Height of geared section
                    BL = 0.3,               //Gear backlash (I find 0.2 works well on my printer)
                    TargetRatio = 3.8,      //Intended reduction ratio
                    InnerBore = 0,          //Bore of motor shaft
                    NumPlanets = 4,         //number of planets in gearbox
                    PressureAngle = 28,     //Gear pressure angle (in case it's useful to change it)
                    Annulus = Annulus,         //Enable Annulus rendering
                    Planets = Planets,         //Enable Planet gears rendering
                    Sun = Sun,             //Enable Sun gear rendering
                    Planet = Planet, // just one, centered planet
                    Vertical = Vertical,
                    SunTwist = -18,
                    PlanetTwist = 20,
                    AnnulusTwist = 6.5
                );
}

module lower(Annulus, Planets, Sun, Planet, Vertical)
{
Planetary(   ID = 26,                //Annulus pitch-diameter
                    Na = 30,                //Number of teeth on Annulus
                    Height = 3,            //Height of geared section
                    BL = 0.3,               //Gear backlash (I find 0.2 works well on my printer)
                    TargetRatio = 4,      //Intended reduction ratio
                    InnerBore = 0,          //Bore of motor shaft
                    NumPlanets = 4,         //number of planets in gearbox
                    PressureAngle = 28,     //Gear pressure angle (in case it's useful to change it)
                    Annulus = Annulus,         //Enable Annulus rendering
                    Planets = Planets,         //Enable Planet gears rendering
                    Sun = Sun,             //Enable Sun gear rendering
                    Planet = Planet, // just one, centered planet
                    Vertical = Vertical,
                    SunTwist = -20,
                    PlanetTwist = 20,
                    AnnulusTwist = 6.7
                );
}

intersection()
{
upper(Planet=false,
          Planets = true,
          Sun=true,
          Annulus=true,
            Vertical=true);
cube([60,60,$t*6],center=true);
}
    
    
lower(Planet=false,
          Planets = true,
          Sun=true,
          Annulus=true,
            Vertical=true);
















difference() {
    union() {
        lower( Planets = true,
                   Sun=false,
                   Annulus=false);
        translate([0,0,6])
            upper( Planets = true,
                   Sun=false,
                   Annulus=false);
    }
    hull()
    for( angle=[0,90,180,270] )
        rotate(angle,[0,0,1])
            translate([8,0,9-0.2])
                cylinder(d=2,h=0.3);
    translate([8,-2,9-0.2])
        cylinder(d=1,h=0.3);
    translate([2,-8,9-0.2])
        cylinder(d=1,h=0.3);

    translate([-2,-8,9-0.2])
        cylinder(d=1,h=0.3);
    translate([-1,-9,9-0.2])
        cylinder(d=1,h=0.3);
    translate([-8,-2,9-0.2])
        cylinder(d=1,h=0.3);
    translate([-9,-1,9-0.2])
        cylinder(d=1,h=0.3);
    

}


//
//mirror([0,1,0])
//lower(Planet=false,
//          Planets = false,
//          Sun=true,
//          Annulus=false );
//cylinder(d=6,h=15);
//
//upper(Planet=false,
//          Planets = false,
//          Sun=true,
//          Annulus=false );


//intersection() {
//    union() {
//                        upper(Planet=false,
//                                  Planets = false,
//                                  Sun=false,
//                                  Annulus=true);
//        for( mir=[0,1] )
//            mirror([0,mir,0])
//                translate([0,20,0]) // upper - 20
//                    difference() {
//                        cube([4,10,6],center=true);
//                        rotate([0,90,0])
//                            cylinder(d=3.4,h=10,center=true);
//                    }
//        difference() {
//            cylinder(d=32,h=6,center=true,$fn=8*36); // upper
//            cylinder(d=29,h=7,center=true,$fn=8*36); // upper
//        }
//    }
//    
//    translate([-30,-30,-5]) // -30,-30,-5 or 0,-30,-5
//        cube([30,60,10]);
//}

intersection() {
    union() {
                        lower(Planet=false,
                                  Planets = false,
                                  Sun=false,
                                  Annulus=true);
        for( mir=[0,1] )
            mirror([0,mir,0])
                translate([0,20,0]) // upper - 20
                    difference() {
                        cube([4,10,6],center=true);
                        rotate([0,90,0])
                            cylinder(d=3.4,h=10,center=true);
                    }
        difference() {
            cylinder(d=32,h=6,center=true,$fn=8*36); // upper
            cylinder(d=29,h=7,center=true,$fn=8*36); // upper
        }
    }
    
    translate([-30,-30,-5]) // -30,-30,-5 or 0,-30,-5
        cube([30,60,10]);
}




