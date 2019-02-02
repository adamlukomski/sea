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
                    Planet = false, // just one, centered planet
                    Planet1 = false,
                    Planet2 = false
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
                linear_extrude( height=3, center=false, twist=20, slices=10)
                projection()
                rotate((i*(360/NumPlanets))*(Na*Na/Np), [0, 0, 1])
                
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
//                cylinder(d=1,h=10);
            }
        }
    }
        
    if(Planet)
    {
        i=0;
            rotate(i*(360/NumPlanets), [0, 0, 1])
            translate([(SD+PD)/2, 0, 0])
            {
                
                for( mir=[0,1] )
                mirror([0,0,mir])
                linear_extrude( height=3, center=false, twist=20, slices=10)
                projection()
                rotate((i*(360/NumPlanets))*(Na*Na/Np), [0, 0, 1])
                
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
            }
        
    }
    
    if(Planet1)
    {
        i=1;
            rotate(i*(360/NumPlanets), [0, 0, 1])
            {
                
                rotate((i*(360/NumPlanets))*(Na*Na/Np), [0, 0, 1])
                
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
            }
        
    }

    if(Planet2)
    {
        i=0;
            rotate(i*(360/NumPlanets), [0, 0, 1])
            {
                
                rotate((i*(360/NumPlanets))*(Na*Na/Np), [0, 0, 1])
                
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
            }
        
    }    
        
        EOP = 1-Np%2;     //Even/odd teeth on planet
    
    if(Sun)
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



module upper(Annulus, Planets, Sun, Planet)
{
Planetary(   ID = 36.7,                //Annulus pitch-diameter
                    Na = 44,                //Number of teeth on Annulus
                    Height = 3,            //Height of geared section
                    BL = 0.3,               //Gear backlash (I find 0.2 works well on my printer)
                    TargetRatio = 5.4,      //Intended reduction ratio
                    InnerBore = 0,          //Bore of motor shaft
                    NumPlanets = 3,         //number of planets in gearbox
                    PressureAngle = 28,     //Gear pressure angle (in case it's useful to change it)
                    Annulus = Annulus,         //Enable Annulus rendering
                    Planets = Planets,         //Enable Planet gears rendering
                    Sun = Sun,             //Enable Sun gear rendering
                    Planet = Planet // just one, centered planet
                );
}


difference() {
    union() {
        Planetary( Planets = true,
                   Sun=false,
                   Annulus=false);
        translate([0,0,6])
            upper( Planets = true,
                   Sun=false,
                   Annulus=false);
    }
    hull()
    for( angle=[0,120,240] )
        rotate(angle,[0,0,1])
            translate([12,0,-3.01])
                cylinder(d=2,h=0.3);
}
// each planet
//translate([23,0,3])
//for( mir=[0,1] )
//    mirror([0,0,mir])
//        linear_extrude( height=3, center=false, twist=20, slices=10)
//            projection()
//                Planetary(Planet=true,
//                          Planets = false,
//                          Sun=false,
//                          Annulus=false);
//translate([0,0,6])
//for( mir=[0,1] )
//    mirror([0,0,mir])
//        linear_extrude( height=3, center=false, twist=20, slices=10)
//            projection()
//                upper(Planet=true,
//                          Planets = false,
//                          Sun=false,
//                          Annulus=false);

 
//translate([0,0,0])
//for( mir=[0,1] )
//    mirror([0,0,mir])
//        linear_extrude( height=3, center=false, twist=-21, slices=10) // Planetary - twist 21, upper - 30
//            projection()
//                Planetary(Planet=false,
//                          Planets = false,
//                          Sun=true,
//                          Annulus=false );
//
//
//translate([0,0,6])
//for( mir=[0,1] )
//    mirror([0,0,mir])
//        linear_extrude( height=3, center=false, twist=-30, slices=10) // Planetary - twist 21, upper - 30
//            projection()
//                upper(Planet=false,
//                          Planets = false,
//                          Sun=true,
//                          Annulus=false);

////
////// annulus cut in half
////
//////for( mir=[0,1] )
//////            mirror([mir,0,0])
//////            mirror([0,mir,0])
////translate([3,0,0])
//intersection() {
//    union() {
//        for( mir=[0,1] )
//            mirror([0,0,mir])
//                linear_extrude( height=3, center=false, twist=7.8, slices=10) // Planetary - twist 7, upper - 7.8
//                    projection()
//                        upper(Planet=false,
//                                  Planets = false,
//                                  Sun=false,
//                                  Annulus=true);
//        for( mir=[0,1] )
//            mirror([0,mir,0])
//                translate([0,24,0])
//                    difference() {
//                        cube([4,10,6],center=true);
//                        rotate([0,90,0])
//                            cylinder(d=3.4,h=10,center=true);
//                    }
//        difference() {
//            cylinder(d=41,h=6,center=true,$fn=8*36);
//            cylinder(d=38,h=7,center=true,$fn=8*36);
//        }
//    }
//    
//    translate([0,-30,-5])
//        cube([30,60,10]);
//}

