$fn = 50;

use <mcad/involute_gears.scad>                    


module Planetary(   OD = 40,                //Outer diameter (motor width)
                    ScrewDistance = 31,     //Distance between screws in x or y axis (assume sqare arrangement)
                    ScrewDia = 3,           //Dimater of screwholes
                    ID = 35,                //Annulus pitch-diameter
                    Na = 42,                //Number of teeth on Annulus
                    Height = 3,            //Height of geared section
                    BL = 0.4,               //Gear backlash (I find 0.2 works well on my printer)
                    TargetRatio = 4.5,      //Intended reduction ratio
                    InnerBore = 5.4,          //Bore of motor shaft
                    IBoreClearence = 1,     //Clearence around motor shaft for planet carrier
                    PlanetBore = 3.5,       //Bore of holes in planet carrier for shafts
                    PBoreClearance = 0.5,   //Clearence added for planet gears        
                    NumPlanets = 3,         //number of planets in gearbox
                    LwrCarrierThk = 3,      //Thickness of lower carrier
                    UprCarrierThk = 3,      //Thickness of upper carrier
                    CarrierClearanceB = 0.5,//Clearence between lower carrier and planet gears
                    CarrierClearanceT = 0.5,//Clearence between upper carrier and planet gears
                    OutputBore = 6.3+0.4,       //Output shaft diameter    
                    OutputShaftLen = 5,     //Length of output shaft
                    MotorShaftLen = 24,     //Length of motor shaft
                    PressureAngle = 28,     //Gear pressure angle (in case it's useful to change it)
                    TopPlateH = 1.5,        //Height of top cover plate
                    BottomPlateH = 1.8,     //Height of bottom plate (butts against motor)
                    BottomPlateHole = 23,   //Diameter of hole in bottom plate (to accomodate motor shoulder)
                    PlateClearence = 0.5,   //Clearence between plates and planet carrier
                    Annulus = true,         //Enable Annulus rendering
                    Planets = true,         //Enable Planet gears rendering
                    Sun = true,             //Enable Sun gear rendering
                    CarrierT = true,        //Enable top carrier rendering
                    CarrierB = true,        //Enable bottom carrier rendering    
                    TopPlate = true,        //Enable top plate rendering    
                    BottomPlate = true,      //Enable bottom plate rendering
                    Planet = false // just one, centered planet
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
        cylinder( d=40,h=Height );
        
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
    }
        
    if(Planet)
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
    
}


// each planet
translate([13,0,0])
for( mir=[0,1] )
    mirror([0,0,mir])
        linear_extrude( height=3, center=false, twist=20, slices=10)
            projection()
                Planetary(Planet=true,
                          Planets = false,
                          Sun=false,
                          Annulus=false);

//translate([22,0,3])
for( mir=[0,1] )
    mirror([0,0,mir])
        linear_extrude( height=3, center=false, twist=21, slices=10)
            projection()
                Planetary(Planet=false,
                          Planets = false,
                          Sun=true,
                          Annulus=false);


// annulus cut in half

//for( mir=[0,1] )
//            mirror([mir,0,0])
//            mirror([0,mir,0])
translate([3,0,0])
intersection() {
    union() {
        for( mir=[0,1] )
            mirror([0,0,mir])
                linear_extrude( height=3, center=false, twist=7, slices=10)
                    projection()
                        Planetary(Planet=false,
                                  Planets = false,
                                  Sun=false,
                                  Annulus=true);
        for( mir=[0,1] )
            mirror([0,mir,0])
                translate([0,24,0])
                    difference() {
                        cube([4,10,6],center=true);
                        rotate([0,90,0])
                            cylinder(d=3.4,h=10,center=true);
                    }
        difference() {
            cylinder(d=41,h=6,center=true,$fn=8*36);
            cylinder(d=38,h=7,center=true,$fn=8*36);
        }
    }
    
    translate([0,-30,-5])
        cube([30,60,10]);
}








//Planetary(Planet=false,
//          Planets = true,
//          Sun=true,
//          Annulus=true);