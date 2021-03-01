$fn=60;
module triangle(height=5, width=5, center=false, topFactor=0.5, wedgeWidth) {
	triangles=[[0,1,4],[5,4,1],		// top
					[1,2,5],[2,3,4],		// sides
					[3,0,4], [4,5,2],	//back
           	[2,1,0], [2,0,3]]; // base
	halfWidth=width/2;
	halfWWidth=wedgeWidth/2;
	topWidth=wedgeWidth*topFactor;
	halfTopWidth=topWidth/2;
	topHalfDiff=(wedgeWidth-topWidth)/2;
	halfHeight=height/2;
	if (center) {
		polyhedron(
  			points=[/*0*/[halfWidth,halfWWidth,-halfHeight],/*1*/[halfWidth,-halfWWidth,-halfHeight],				//front point
					  /*2*/[-halfWidth,-halfWWidth,-halfHeight],       /*3*/[-halfWidth,halfWWidth,-halfHeight], //rear point
           	  /*4*/[-halfWidth,halfTopWidth,height-halfHeight], /*5*/[-halfWidth,-halfTopWidth,height-halfHeight] ], //front/rear top 
  			triangles=triangles
		);
	}
	else {
		polyhedron(
  			points=[/*0*/[width,wedgeWidth,0],         			 /*1*/[width,0,0],				    ////front point
					  /*2*/[0,0,0],       					  			 /*3*/[0,wedgeWidth,0], 		    //rear point
           	  /*4*/[0,wedgeWidth-topHalfDiff,height],/*5*/[0,topHalfDiff,height] ],//front/back top 
  			triangles=triangles
		);
	}
};
module PsuFatEnd() {
    color("gray")
        render(convexity = 2)
        
        difference(){
            cube([69,76,41],center=true);
            
            translate([33.25,0,-19.75])
            rotate([0,270,0])
            triangle(height=2.5, width=2.5, center=true, topFactor=1, wedgeWidth=76);
        }
        
        *color("white")
        translate([-337/2+11+10/2,-76/2-1,-16.5])
        cube([10,3,10],center=true);
        
        color("white")
        translate([-18.5,-39.25,-15.5])
        rotate([90,0,0])
        triangle(height=2.5, width=10, center=true, topFactor=1, wedgeWidth=10);
};
module PSU() {
    render(convexity = 2)
    {
        color("blue")
        render(convexity = 2)
        difference(){
            cube([337,76,39],center=true);
            
            translate([-134,0,-1])
            PsuFatEnd();
        };
        
        translate([-134,0,-1])
        PsuFatEnd();
    };
};
module PDB() {
    //render(convexity = 2)
    difference() {
        union() {
            color("gray")
            cube([72,76,83],center=true);
        };
        
        translate([30,-40,-28.7])
        PdbMountingHoles();
    };
};
module PdbMountingHole() {
    translate([0,5,0])
    rotate([90,0,0])
    cylinder(d=3.2,h=10);
};
module PdbMountingHoles() {
    BottomLeftMoutingHole  = [9.2,-5,4];
    BottomRightMoutingHole = BottomLeftMoutingHole + [61.6,0,0 ];
    TopLeftMoutingHole     = BottomLeftMoutingHole + [0   ,0,51];
    TopRightMoutingHole    = BottomLeftMoutingHole + [61.6,0,51];
    rotate([0,0,90])
    union() {
        translate(TopLeftMoutingHole)    PdbMountingHole();       translate(TopRightMoutingHole)    PdbMountingHole();
        translate(BottomLeftMoutingHole) PdbMountingHole();       translate(BottomRightMoutingHole) PdbMountingHole();
    };
};
module WholePSU() {
    //render(convexity = 2)
    union() {
        translate([197.5,0,20])
        color("lightgray")
        PDB();
        
        color("gray")
        PSU();
        
        color("white")
        translate([0,0,42])
        PSU();
    };
};
module Backplate() {
    difference() {
        // Plate
        color("black")
        cube([4,170,91]);
        
        // Hole
        color("red")
        translate([0,4,91/2])
        rotate([0,90,0])
        cylinder(h=10,d=4,center=true);
        
        // Hole
        color("green")
        translate([0,170-4,91/2])
        rotate([0,90,0])
        cylinder(h=10,d=4,center=true);
    };
};
module BlockArrow() {
    hull() {
        color("red")  translate([0,0,0])   rotate([0,45,0]) rotate([90,0,0]) cylinder(d=12.25,h=100,$fn=4);  
        color("blue") translate([6.9,0,0]) rotate([90,0,0])                  cylinder(d=10.00,h=100,$fn=3);
    };
}
module PsuHousing() {
    //render(convexity = 20)
    union() {
        difference(){
            union() {
                color("brown")
                translate([0,31,(91-86)/2])
                cube([417,84,86]);
                
                translate([0,-10,0])
                Backplate();
            };
            
            color("red")
            translate([396.8,75.5,67])
            cube([80,80,100],center=true);
            
            render(convexity=20)
            translate([337/2,74,26])
            minkowski() {
                WholePSU();
                cube([1,1,.01],center=true);
            };

            translate([413,34,17.3])
            rotate([0,0,90])
            PdbMountNegativeSpace();

            // Small Ventalation Holes
            translate([343,120,0])
            union() {
                translate([0,0,78]) BlockArrow();
                translate([0,0,65]) BlockArrow();
                translate([0,0,52]) BlockArrow();
                translate([0,0,39]) BlockArrow();
                translate([0,0,26]) BlockArrow();
                translate([0,0,13]) BlockArrow();
            };

            // Big Ventalation Holes
            translate([230,120,67]) scale([6,1,3]) BlockArrow();
            translate([230,120,24]) scale([6,1,3]) BlockArrow();

            // 40mm PCB Ventelation Fan
            translate([360,33,46])
            rotate([90,45,0])
            40mmFanAndBoltHoles();
        };

        // 45* plate to add sloping angle to underhang
        // Removes need for additional 3D printing supports
        translate([399,32.65,78.5]) rotate([45,0,0]) cube([13,4,2]);

        // PDB PCB Mounting Plate
        translate([412,31,37]) //color("gray")  
        difference () {
            translate([0,0,-28.5]) cube([05,84,80]);
            
            // Screw Holes
            color("red")  translate([0,7.2,10]) rotate([0,90,0]) cylinder(d=3.4,h=20,center=true);
            color("blue") translate([0,78.8,10]) rotate([0,90,0]) cylinder(d=3.4,h=20,center=true);

            // Screw Access Holes
            color("green")  translate([0,74,+35]) rotate([0,90,0]) cylinder(d=16,h=20,center=true,$fn=4);
            color("white")  translate([0,12,+35]) rotate([0,90,0]) cylinder(d=16,h=20,center=true,$fn=4);
            color("silver") translate([0,74,-15]) rotate([0,90,0]) cylinder(d=16,h=20,center=true,$fn=4);
            color("aqua")   translate([0,12,-15]) rotate([0,90,0]) cylinder(d=16,h=20,center=true,$fn=4);

        };
        
    };
};
module FanPlate140() {
    difference() {
        cube([140,140,2]);
        
        translate([7.75,7.75,0])
        union() {
            translate([000.0,000.0,0]) cylinder(d=4,h=10,center=true);
            translate([000.0,124.5,0]) cylinder(d=4,h=10,center=true);
            translate([124.5,000.0,0]) cylinder(d=4,h=10,center=true);
            translate([124.5,124.5,0]) cylinder(d=4,h=10,center=true);
        };
    };
};
module FanPlate120() {
    difference() {
        union() {
            *cube([120,120,1.4]);
            
            translate([-26,0,0]) cube([146,120,1.4]);
            
            translate([7.75,7.75,3.8])
            union() {
                *color("red")   translate([-000.75,000,0]) cube([14,13,5],center=true);
                *color("blue")  translate([-000.75,105,0]) cube([14,13,5],center=true);

                color("red")   translate([-000.75,000.75,0]) hull(){cube([14.5,17,5],center=true); translate([-20,0,-2.45]) cube([1,13,0.1],center=true);};
                color("blue")  translate([-000.75,103.75,0]) hull(){cube([14.5,17,5],center=true); translate([-20,0,-2.45]) cube([1,13,0.1],center=true);};
                color("green") translate([+105.00,000.75,0]) hull(){cube([14.5,17,5],center=true); translate([-20,0,-2.45]) cube([1,13,0.1],center=true);};
                color("gray")  translate([+105.00,103.75,0]) hull(){cube([14.5,17,5],center=true); translate([-20,0,-2.45]) cube([1,13,0.1],center=true);};
            };
        };
        ;
        
        translate([7.75,7.75,0])
        union() {
            // Bolt Holes
            translate([000,000,0]) cylinder(d=5,h=10,center=true);
            translate([000,105,0]) cylinder(d=5,h=10,center=true);
            translate([105,000,0]) cylinder(d=5,h=10,center=true);
            translate([105,105,0]) cylinder(d=5,h=10,center=true);
        };
        translate([7.75,7.75,6])
        union() {
            // Hole for M2.5 Nut
            translate([000,000,0]) cylinder(d=12, h=7, center=true, $fn=4);
            translate([000,105,0]) cylinder(d=12, h=7, center=true, $fn=4);
            translate([105,000,0]) cylinder(d=12, h=7, center=true, $fn=4);
            translate([105,105,0]) cylinder(d=12, h=7, center=true, $fn=4);
            
        };
        
        // Side Cutouts
        *translate([60,-40,-5]) cylinder(d=120,h=20);
        *translate([60,160,-5]) cylinder(d=120,h=20);
    };
};
module Joint() {
    difference() {
        
        scale([0.6,1,1])
        union() {
            translate([0,0,17.6]) 
            cylinder(h=5 ,r=10        ,center=true);
            
            translate([0,0,10]) 
            cylinder(h=10 ,r=10        ,center=true);
            
            cylinder(h=10,r1=0.1,r2=10,center=true);
        }
        
        // Slice in half
        translate([-15,0,-10])
        cube(size=100,center=false);
        
        // Hole for brass threaded insert
        translate([0,-5,10.01])
        cylinder(h=10,d=3,center=true);
        
        // Hole for M2.5 bolt
        translate([0,-5,20])
        cylinder(h=10,d=2.7,center=true);
        
        // Hole for M2.5 Nut
        bolt_head_diameter=4.7;
        bolt_head_thickness=2.5;
        translate([0,-5,19])
        cylinder(d=bolt_head_diameter, h=bolt_head_thickness, center=true);

    };
};
module 40mmFanAndBoltHoles() {
    union() {
        color("black") translate([16,16,0]) cylinder(d=39,h=10,center=true);
        // Bolt Holes
        color("red")   translate([00,00,0]) cylinder(d=3.5,h=10,center=true);
        color("green") translate([00,32,0]) cylinder(d=3.5,h=10,center=true);
        color("blue")  translate([32,00,0]) cylinder(d=3.5,h=10,center=true);
        color("black") translate([32,32,0]) cylinder(d=3.5,h=10,center=true);
    };
};
module SacrificialNut() {
    difference() {
        rotate([0,0,90])
        cylinder(d=9.5, h=7, center=true, $fn=6);
        cylinder(d=3.9,h=10,center=true);
        
        translate([0,4.5,0])
        cylinder(d=1.5,  h=10,center=true);
    };
    ;
};
module PdbMountingArmHorizontal() {
    SlotWidth=72;
    MountWidth=SlotWidth + 15;

    color("red")
    difference() {
        // Outer Wall
        hull(){
            translate([0,MountWidth,0])
            cylinder(d=10,h=10);
            cylinder(d=10,h=10);
        };

        // Inner Slot
        translate([0,(MountWidth-SlotWidth)/2,0])
        hull(){
            translate([0,SlotWidth,-5])
            cylinder(d=3.2,h=20);
            cylinder(d=3.2,h=20);
        };

        // Inner Ledge
        translate([0,(MountWidth-SlotWidth)/2,6])
        hull(){
            translate([0,SlotWidth,0])
            cylinder(d=5.7,h=4.1);
            cylinder(d=5.7,h=4.1);
        };

        // Mounting Points
        translate([0,0,-5])cylinder(d=3.2,h=20);  translate([0,0,6]) cylinder(d=5.7,h=4.1);

        translate([0,MountWidth,-5])cylinder(d=3.2,h=20);  translate([0,MountWidth,6]) cylinder(d=5.7,h=4.1);
    };
};
;module PdbMountingArmVertical() {
    SlotWidth=75.5;

    color("red")
    rotate([90,0,-90])
    difference() {
        // Outer Wall
        translate([0,-5,0])
        hull(){
            translate([-5,SlotWidth,0]) cube(10);
            translate([-5,0,0]) cube(10);
        };

        // Mounting Points
        hull() { translate([0,0,-5]) cylinder(d=3.2,h=20);   translate([0,SlotWidth,-5])cylinder(d=3.2,h=20); };
        hull() { translate([0,0,6])  cylinder(d=5.7,h=4.1);  translate([0,SlotWidth,6]) cylinder(d=5.7,h=4.1);};

        
    };
};
module MountingSlot() {
    SlotWidth=10;
    translate([-5,0,0])
    rotate([0,-90,-90])
    union() {
        // Inner Slot
        hull(){
            translate([0,SlotWidth,0])
            cylinder(d=3.2,h=20);
            cylinder(d=3.2,h=20);
        };

        // Inner Ledge
        hull(){
            translate([0,SlotWidth,0])
            cylinder(d=5.7,h=10);
            cylinder(d=5.7,h=10);
        };
    };
};
module PdbPcb() {
    cube([80,10,59]);
};
module PdbMount() {
    BottomLeftMoutingHole  = [(80-61.6)/2,-5,4];
    BottomRightMoutingHole = BottomLeftMoutingHole + [61.6,0,0];
    TopLeftMoutingHole     = BottomLeftMoutingHole + [0,0,51];
    TopRightMoutingHole    = BottomLeftMoutingHole + [61.6,0,51];
    MiddleLeftMoutingHole  = BottomLeftMoutingHole + [-05.0,20,51/2];
    MiddleRightMoutingHole = BottomLeftMoutingHole + [66.6,20,51/2];
    difference(){
        color("blue")
        PdbPcb();

        translate(TopLeftMoutingHole)    MountingSlot();       translate(TopRightMoutingHole)    MountingSlot();
        translate(BottomLeftMoutingHole) MountingSlot();       translate(BottomRightMoutingHole) MountingSlot();

        translate(MiddleLeftMoutingHole)  rotate([180,90,0]) MountingSlot();
        translate(MiddleRightMoutingHole) rotate([180,90,0]) MountingSlot();

        translate([40,11,30]) rotate([90,0,0]) cylinder(d=55,h=20);
    };
};
module PdbMountNegativeSpace() {
    minkowski() {
        PdbPcb();

        cube([0.5,8,10],center=true);
    };
};

*translate([168.5,-76,26])
*WholePSU();

*translate([0,-150,0]) {
    union() {
        translate([412,34,17.3])
        rotate([0,0,90])
        PdbMount();

        difference() {
            PsuHousing();

            //*translate([412,34,17.3])
            //rotate([0,0,90])
            //PdbMountNegativeSpace();
        };
    };
};




xShift = 381.8;
translate([0,10,0])
difference() { 
    //render()
    union() {
        color("gray")
        render(convexity=20)PsuHousing();
    
        // Fan Plates
        translate([197,-9,2.5])
        union(){
            translate([000,23.75,0]) color("blue")      FanPlate120();
            translate([146,23.75,0]) color("lightblue") FanPlate120();
        };
        ;
        
        // Join Pieces Together
        // "AC Cable Third" to "Middle Third" Joints
        translate([181.7,115,20]) rotate([180,-90,0]) Joint();
        translate([181.7,115,82.5]) rotate([180,-90,0]) Joint();
        translate([181.7,31,82.5]) rotate([0,90,0]) Joint();
        translate([181.7,31,20]) rotate([0,90,0]) Joint();
        
        // "Middle Third" to "PDB Third" Joints
        *translate([xShift,115,82.5]) rotate([180,-90,0]) Joint();
        color("red")   translate([xShift,115,10.0]) rotate([180,-90,0]) Joint(); translate([xShift+15.1,115,03.0])                   cube([5,9,4.6],center=false);
        color("blue")  translate([xShift,031,10.0]) rotate([000,+90,0]) Joint(); translate([xShift+15.1,022,03.0])                   cube([5,9,4.6],center=false);
        color("green") translate([xShift,031,82.5]) rotate([000,+90,0]) Joint(); hull() {
                                                                                    translate([xShift+15.1,023,79.0]) rotate([-45,0,0]) cube([5,13,0.1],center=false);
                                                                                    translate([xShift+15.1,32,79.0]) rotate([0,90,0]) cylinder(d=0.1,h=5);
                                                                                };
    };
    ;
    
    // "209.75" is as far out as the printer can reach.
    // NOTE:  182mm from this point along positive-X axis
    //   is where the first 140mm fan mount hole exists in the chassis
    
    // Star (*) to Keep "PDB Third" in Render
    translate([396.9,-50,-50])
    cube([200,400,400]);
    
    // Star (*) to Keep "Middle Third" in Render
    translate([196.8,-50,-50])
    cube([200.1,400,400]);
    
    // Star (*) to Keep "AC Cable Third" in Render
    *translate([-1,-50,-50])
    cube([197.8,400,400]);
};
;









