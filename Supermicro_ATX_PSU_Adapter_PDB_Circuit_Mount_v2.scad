$fn=60;

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

module MountingPlateHole(){
    translate([0,5,0])
    rotate([90,0,0])
    cylinder(d=3.4,h=10);
};

module PdbPcb() {cube([80,10,59]);};

BottomLeftMoutingHole  = [(80-61.6)/2,-5,4];
BottomRightMoutingHole = BottomLeftMoutingHole + [+61.6,00,0];
TopLeftMoutingHole     = BottomLeftMoutingHole + [+00.0,00,51];
TopRightMoutingHole    = BottomLeftMoutingHole + [+61.6,00,51];
MiddleLeftMoutingHole  = BottomLeftMoutingHole + [-05.0,17,51/2];
MiddleRightMoutingHole = BottomLeftMoutingHole + [+66.6,17,51/2];
difference(){
    color("blue")
    PdbPcb();

    translate(TopLeftMoutingHole)    MountingSlot();       translate(TopRightMoutingHole)    MountingSlot();
    translate(BottomLeftMoutingHole) MountingSlot();       translate(BottomRightMoutingHole) MountingSlot();

    translate(MiddleLeftMoutingHole)  rotate([180,90,0]) MountingSlot();
    translate(MiddleRightMoutingHole) rotate([180,90,0]) MountingSlot();

    translate([40,11,30]) rotate([90,0,0]) cylinder(d=55,h=20);
};