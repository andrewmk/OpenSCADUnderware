/*Created by BlackjackDuck (Andy) and Hands on Katie. Original model from Hands on Katie (https://handsonkatie.com/)
This code and all non-Gridfinity parts derived from it are Licensed Creative Commons 4.0 Attribution Non-Commercial Share-Alike (CC-BY-NC-SA)
Gridfinity components are licensed under the MIT License.


Documentation available at https://handsonkatie.com/

Change Log:
- 

Credit to 
    First and foremost - Katie and her community at Hands on Katie on Youtube, Patreon, and Discord
    Zack Freedman for his work on the original Gridfinity
*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*[Part Selection)]*/
Select_Part = "Straight"; //[Drawer Wall Mounts, Straight, Straight End, X Intersection, T Intersection, L Intersection, Vertical Trim]
Top_or_Bottom = "Both"; //[Top, Bottom, Both]

/*[Base Options]*/
//Not yet implemented
Selected_Base = "Gridfinity"; //[Gridfinity, Flat, None]
//Thickness of the flat baseplate (by mm)
Flat_Base_Thickness = 1.4; //0.1

/*[Material Size]*/
//Material Thickness (by mm)
Material_Thickness = 3.5; //.01
//Depth of the channel for the material to sit in.
Channel_Depth = 20; 

/*[Channel Customizations]*/
//Thickness of the walls of the channel (by mm)
Wall_Thickness = 4;

/*[Material Holding Options]*/
//Print a retention spike inside the channels to firmly hold softer material like MDF.
Retention_Spike = false;
//Adjust the size of the spike. Spike auto-calculates to 1/3 the thickness of the material.
Spike_Scale = 1;

/*[Straight Channel]*/
//Length of the channel (by mm)
Channel_Length = 42; 

/*[Vertical Trim Channel]*/
Show_Vertical_Trim = false;
//Length of the channel (by mm)
Total_Trim_Width = 42; 
Middle_Seam_Width = 5;
Total_Trim_Height = 20;

/*[Screw Mounting]*/
//Wood screw diameter (in mm)
Wood_Screw_Thread_Diameter = 3.5;
//Wood Screw Head Diameter (in mm)
Wood_Screw_Head_Diameter = 7;
//Wood Screw Head Height (in mm)
Wood_Screw_Head_Height = 1.75;

/*[Advanced]*/
//Size of the grid (by mm). 42mm by default for gridfinity. Other sized not tested. 
grid_size = 42;

//Additional channel length beyond center for partial channels. This allows slop in cutting dividers. 
Partial_Channel_Buffer = 3;
Part_Separation = 5;
Enable_Fillets = true;

/*[Hidden]*/
outside_radius = 7.5; //radius of the outside corner of the baseplate
inside_radius = 0.8; //radius of the inside corner of the baseplate
grid_x = 1;
grid_y = 1;
retention_spike_size = 0.8;
part_placement = grid_size/2+Part_Separation;
grid_clearance = Selected_Base == "Gridfinity" ? 0.5 : 1; //adjusted grid size for spacing between grids

calculated_base_height = Selected_Base == "Gridfinity" ? 4.75+0.6 : //0.6 is the additional height for the gridfinity baseplate by default. Update this if parameterized. 
    Selected_Base == "Flat" ? Flat_Base_Thickness:
    0;

text_depth = 1;
text_size = 7;
font = "Monsterrat:style=Bold";
specs_text = str("th", Material_Thickness);
    
/*

BEGIN DISPLAYS

*/

Shelf_Wall_Thickness = 17;
Shelf_Wall_Clearance = 2;
Shelf_Bracket_Thickness = 2;
Shelf_Exterior_Drop = 10;

Adhesive_Backer_Thickness = 2;
Adhesive_Backer_Width = 20;



if(Select_Part == "Drawer Wall Mounts"){
    //drawer wall hook
    diff(){
        //Channel Walls
        cuboid([Wall_Thickness*2+Material_Thickness, Channel_Length, Channel_Depth+Wall_Thickness], anchor=FRONT+BOT, orient=FRONT){ //Gridfinity Base
            //Removal tool for channel
            attach(TOP, BOT, inside=true, shiftout=0.01)
                channelDeleteTool([Material_Thickness, Channel_Length+0.02, Channel_Depth+0.02]);
            //top of shelf bracket
            attach(BOT, FRONT, overlap=0.01, align=BACK)
                cuboid([Wall_Thickness*2+Material_Thickness, Shelf_Wall_Thickness, Shelf_Bracket_Thickness])
                    attach(BACK, FRONT, overlap=0.01, align=TOP)
                        cuboid([Wall_Thickness*2+Material_Thickness, Shelf_Bracket_Thickness, Shelf_Exterior_Drop+Shelf_Bracket_Thickness]);
        }
    }

    //drawer wall adhesive
    back(grid_size+Part_Separation)
    diff(){
        //Channel Walls
        cuboid([Wall_Thickness*2+Material_Thickness, Channel_Length, Channel_Depth+Wall_Thickness-Adhesive_Backer_Thickness], anchor=FRONT+BOT, orient=FRONT){ //Gridfinity Base
            //Removal tool for channel
            attach(TOP, BOT, inside=true, shiftout=0.01)
                channelDeleteTool([Material_Thickness, Channel_Length+0.02, Channel_Depth+0.02]);
            //back bracket
            attach(BOT, TOP, align=BACK)
                cuboid([max(Wall_Thickness*2+Material_Thickness, Adhesive_Backer_Width), Channel_Length, Adhesive_Backer_Thickness]);
        }
    }

    Screw_Backer_Thickness = 2;
    Screw_Backer_Buffer_Width = 4;
    //drawer wall screw
    back(grid_size*2+Part_Separation)
    diff(){
        //Channel Walls
        cuboid([Wall_Thickness*2+Material_Thickness, Channel_Length, Channel_Depth+Wall_Thickness-Adhesive_Backer_Thickness], anchor=FRONT+BOT, orient=FRONT){ //Gridfinity Base
            //Removal tool for channel
            attach(TOP, BOT, inside=true, shiftout=0.01)
                channelDeleteTool([Material_Thickness, Channel_Length+0.02, Channel_Depth+0.02]);
            //back bracket
            attach(BOT, TOP, align=BACK)
                cuboid([max(Wall_Thickness*2+Material_Thickness, Wall_Thickness*2+Material_Thickness+Wood_Screw_Head_Diameter*2+Screw_Backer_Buffer_Width*2), Channel_Length, Adhesive_Backer_Thickness])
                    //wood screw head
                    attach(TOP, TOP, inside=true, shiftout=0.01)
                    xcopies(n=2, spacing = Wall_Thickness*2+Material_Thickness+Wood_Screw_Head_Diameter+4) 
                        cyl(h=Wood_Screw_Head_Height+0.05, d1=Wood_Screw_Thread_Diameter, d2=Wood_Screw_Head_Diameter, $fn=25)
                            attach(BOT, TOP, overlap=0.01) cyl(h=3.5 - Wood_Screw_Head_Height+0.05, d=Wood_Screw_Thread_Diameter, $fn=25, anchor=TOP);
        }
    }
}

if(Select_Part == "Straight"){
    if(Top_or_Bottom != "Top") 
    fwd(quantup(Channel_Length, grid_size)/2+Part_Separation) 
        NeoGrid_Straight_Thru_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size, Channel_Length = Channel_Length);
    if(Top_or_Bottom != "Bottom") 
    back(Channel_Length/2+Part_Separation)
        NeoGrid_Straight_Thru_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size, Channel_Length = Channel_Length);
}
if(Select_Part == "X Intersection"){
    if(Top_or_Bottom != "Top") 
    left(part_placement)
        NeoGrid_X_Intersection_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    if(Top_or_Bottom != "Bottom") 
    right(part_placement)
        NeoGrid_X_Intersection_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
}

if(Select_Part == "T Intersection"){
    if(Top_or_Bottom != "Top") 
    left(part_placement)
        NeoGrid_T_Intersection_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    if(Top_or_Bottom != "Bottom") 
    right(part_placement)
        NeoGrid_T_Intersection_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);

}

if(Select_Part == "Straight End"){
    if(Top_or_Bottom != "Top") 
    left(part_placement)
        NeoGrid_Straight_End_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    if(Top_or_Bottom != "Bottom") 
    right(part_placement)
        NeoGrid_Straight_End_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);

}

if(Select_Part == "L Intersection"){
    if(Top_or_Bottom != "Top") 
    left(part_placement) 
        NeoGrid_L_Intersection_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    if(Top_or_Bottom != "Bottom") 
    right(part_placement)
        NeoGrid_L_Intersection_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);

}

if(Select_Part == "Vertical Trim"){
    NeoGrid_Vertical_Trim(Material_Thickness, Wall_Thickness = Wall_Thickness, Total_Trim_Width = Total_Trim_Width, Middle_Seam_Width = Middle_Seam_Width, Total_Trim_Height = Total_Trim_Height);
}

/* Display all
//Straight
left(part_placement*3){
    fwd(quantup(Channel_Length, grid_size)/2+Part_Separation) 
        NeoGrid_Straight_Thru_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size, Channel_Length = Channel_Length);
    back(Channel_Length/2+Part_Separation)
        NeoGrid_Straight_Thru_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size, Channel_Length = Channel_Length);
}

//X Intersection
fwd(part_placement){
    left(part_placement)
        NeoGrid_X_Intersection_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    right(part_placement)
        NeoGrid_X_Intersection_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
}

//T Intersection
back(part_placement){
    left(part_placement)
        NeoGrid_T_Intersection_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    right(part_placement)
        NeoGrid_T_Intersection_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
}

//Straight End
back(part_placement*3){
    left(part_placement)
        NeoGrid_Straight_End_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    right(part_placement)
        NeoGrid_Straight_End_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
}

//L Intersection
fwd(part_placement*3){
    left(part_placement) 
        NeoGrid_L_Intersection_Base(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
    right(part_placement)
        NeoGrid_L_Intersection_Top(Material_Thickness, Channel_Depth = Channel_Depth, Wall_Thickness = Wall_Thickness, grid_size = grid_size);
}

//Vertical Trim
if(Show_Vertical_Trim ) 
    right(100)
    NeoGrid_Vertical_Trim(Material_Thickness, Wall_Thickness = Wall_Thickness, Total_Trim_Width = Total_Trim_Width, Middle_Seam_Width = Middle_Seam_Width, Total_Trim_Height = Total_Trim_Height);

//debugging delete tool
//channelDeleteTool([Material_Thickness, grid_size+0.02, Channel_Depth-Wall_Thickness+0.02]);
*/

/*
    
END DISPLAYS
    
*/

/*

BEGIN NEOGRID MODULES

*/




module channelDeleteTool(size, chamfer_edges = [BOT], spike_count = 1, anchor = CENTER, spin = 0, orient = UP){
    tag_scope()
    diff("spike"){
        cuboid(size, anchor=anchor, spin=spin, orient=orient){ //passthru attachables
                //material insertion chamfer 
                if(Enable_Fillets) edge_profile_asym(chamfer_edges, corner_type="chamfer")
                    xflip() mask2d_chamfer(Wall_Thickness/3);
        if(Retention_Spike)
            //Retention Spike
            tag("spike") ycopies(n=spike_count, spacing=size[1]/2)attach([LEFT,RIGHT], BOT, inside=true, overlap=0.01, $fn=30)
                cyl(h=retention_spike_size*Spike_Scale,d2=0, d1=retention_spike_size*Spike_Scale*2);
        children();
        }
    }
}

//STRAIGHT CHANNELS

module NeoGrid_Straight_Thru_Top(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42, Channel_Length = 42){
    diff(){
        //Channel Walls
        cuboid([Wall_Thickness*2+Material_Thickness, Channel_Length, Channel_Depth], anchor=BOT){ //Gridfinity Base
            //top chamfer
                edge_profile([BOT+LEFT, BOT+RIGHT])
                    mask2d_chamfer(Wall_Thickness/3);
        //Removal tool for channel
        attach(TOP, BOT, inside=true, shiftout=0.01)
            channelDeleteTool([Material_Thickness, Channel_Length+0.02, Channel_Depth-Wall_Thickness+0.02]);
        }
    }
}

module NeoGrid_Straight_Thru_Base(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, Channel_Length = 42, grid_size = 42){
    //Straight Channel
    diff(){
        //Gridfinity Base
        if(Selected_Base == "Gridfinity")
            gridfinity_bin_bottom_grid( x = 1, y = quantup(Channel_Length, grid_size)/grid_size, anchor=BOT);
        //Flat Base
        if(Selected_Base == "Flat")
            cuboid( [grid_size, Channel_Length, Flat_Base_Thickness], chamfer=0.5, except=BOT, anchor=BOT);
        //Channel Walls
        up(calculated_base_height-0.01)
            cuboid([ Wall_Thickness*2+Material_Thickness, Channel_Length-grid_clearance,  Channel_Depth], anchor=BOT){ //Gridfinity Base
                //bottom chamfer

                tag("keep") //must label keep due to chamfering out an addition and not a diff. 
                    edge_profile([BOT+LEFT, BOT+RIGHT])
                        xflip()mask2d_chamfer(5);
                //top chamfer
                    if(Enable_Fillets)
                    edge_profile([TOP+LEFT, TOP+RIGHT])
                        mask2d_chamfer(Wall_Thickness/3);
            //Removal tool for channel
            attach(TOP, BOT, inside=true, shiftout=0.01)
                channelDeleteTool([Material_Thickness, Channel_Length+0.02,Channel_Depth+0.02]);
            }
        tag("remove")mirror([1,0,0])text3d(specs_text, size=text_size, font=font, h=1, anchor=CENTER, atype="ycenter");
    }
}

//X INTERSECTIONS

module NeoGrid_X_Intersection_Top(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    diff(){
        //Channel Walls
        zrot_copies([0,90]) 
            cuboid([Wall_Thickness*2+Material_Thickness, grid_size, Channel_Depth], anchor=BOT){ //Gridfinity Base
                //top chamfer
                    if(Enable_Fillets) edge_profile([BOT+LEFT, BOT+RIGHT])
                        mask2d_chamfer(Wall_Thickness/3);
            //Removal tool for channel
            zrot_copies([0,90]) 
                attach(TOP, BOT, inside=true, shiftout=0.01)
                    channelDeleteTool([Material_Thickness, grid_size+0.02, Channel_Depth-Wall_Thickness+0.02], spike_count=2);
        }
    }
}

module NeoGrid_X_Intersection_Base(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    //X Intersection Base
    diff("channel chamf"){ //small trick here. External chamfers auto-apply the "remove" tag. This is a workaround to keep the chamfers on the channel walls by renaming the remove tag.
        //Gridfinity Base 1x1 for all intersections.
        if(Selected_Base == "Gridfinity")
            gridfinity_bin_bottom_grid(x=1,y=1, anchor=BOT);
        //Flat Base
        if(Selected_Base == "Flat")
            cuboid( [grid_size, grid_size, Flat_Base_Thickness], chamfer=0.5, except=BOT, anchor=BOT);
        //Channel Wall Y
        up(calculated_base_height-0.01)
            cuboid([Wall_Thickness*2+Material_Thickness, grid_size-grid_clearance, Channel_Depth], anchor=BOT){
                //bottom outward chamfer
                    edge_profile([BOT+LEFT, BOT+RIGHT])
                        xflip() //xflip to put the chamfer out rather than in
                            mask2d_chamfer(5); 
                //top inward chamfer
                    if(Enable_Fillets) tag("chamf") edge_profile([TOP+LEFT, TOP+RIGHT])
                        mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
            }
        //Channel Wall X
        up(calculated_base_height-0.01)
            zrot(90) down(0.01)
            cuboid([Wall_Thickness*2+Material_Thickness, grid_size-grid_clearance, Channel_Depth], anchor=BOT){
            //bottom chamfer
                edge_profile_asym([BOT+LEFT, BOT+RIGHT])
                    xflip() //xflip to put the chamfer out rather than in
                        mask2d_chamfer(5); 
            //top chamfer
                if(Enable_Fillets) tag("chamf") edge_profile_asym([TOP+LEFT, TOP+RIGHT])
                    mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
        }
        //clear the channels in both directions
        tag("channel")up(calculated_base_height-0.02)
            channelDeleteTool([Material_Thickness, grid_size+0.01, Channel_Depth+0.04], spike_count=2, chamfer_edges=[TOP], anchor=BOT);
        tag("channel")zrot(90) up(calculated_base_height-0.02)
            channelDeleteTool([Material_Thickness, grid_size+0.01, Channel_Depth+0.04], spike_count=2, chamfer_edges=[TOP], anchor=BOT);
        }//end gridfinity base
}

//T INTERSECTIONS
module NeoGrid_T_Intersection_Top(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    diff(){
        //Full Width Channel
        cuboid([Wall_Thickness*2+Material_Thickness, grid_size, Channel_Depth], anchor=BOT){
            //top chamfer
            if(Enable_Fillets) edge_profile([BOT+LEFT, BOT+RIGHT])
                mask2d_chamfer(Wall_Thickness/3);
            //Removal tool - Full Width
            attach(TOP, BOT, inside=true, shiftout=0.01)
                channelDeleteTool([Material_Thickness, grid_size+0.02, Channel_Depth-Wall_Thickness+0.02], spike_count=2);
        }
        //Partial Width Channel
        zrot(90)
        fwd(Material_Thickness/2+Wall_Thickness-0.01)
        cuboid([Wall_Thickness*2+Material_Thickness, grid_size/2+Material_Thickness/2+Wall_Thickness, Channel_Depth], anchor=BOT+FRONT){ //Gridfinity Base
            //top chamfer
            if(Enable_Fillets) edge_profile([BOT+LEFT, BOT+RIGHT])
                mask2d_chamfer(Wall_Thickness/3);
            //Removal tool - Partial
            attach(TOP, BOT, shiftout=0.01, inside=true, align=BACK)
                channelDeleteTool([Material_Thickness, grid_size/2++Material_Thickness/2+0.02, Channel_Depth-Wall_Thickness+0.02]);
        }
    }
}

module NeoGrid_T_Intersection_Base(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    //X Intersection Base
    diff("channel chamf"){ //small trick here. External chamfers auto-apply the "remove" tag. This is a workaround to keep the chamfers on the channel walls by renaming the remove tag.
        //Gridfinity Base 1x1 for all intersections.
        if(Selected_Base == "Gridfinity")
            gridfinity_bin_bottom_grid(x=1,y=1, anchor=BOT);
        //Flat Base
        if(Selected_Base == "Flat")
            cuboid( [grid_size, grid_size, Flat_Base_Thickness], chamfer=0.5, except=BOT, anchor=BOT);
        //Channel Wall partial 
        up(calculated_base_height-0.01)//attach to the top of the gridfinity base
            fwd(grid_size/4-grid_clearance/2)
            cuboid([Wall_Thickness*2+Material_Thickness, grid_size/2, Channel_Depth], anchor=BOT){
                //bottom outward chamfer
                    edge_profile([BOT+LEFT, BOT+RIGHT])
                        xflip() //xflip to put the chamfer out rather than in
                            mask2d_chamfer(5); 
                //top inward chamfer
                    if(Enable_Fillets) tag("chamf")edge_profile([TOP+LEFT, TOP+RIGHT])
                        mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
            }
        //Channel Wall full width
        up(calculated_base_height-0.01)
            zrot(90)
            cuboid([Wall_Thickness*2+Material_Thickness, grid_size-grid_clearance, Channel_Depth], anchor=BOT){
            //bottom chamfer
                edge_profile([BOT+LEFT, BOT+RIGHT])
                    xflip() //xflip to put the chamfer out rather than in
                        mask2d_chamfer(5); 
            //top chamfer
                if(Enable_Fillets) tag("chamf")edge_profile([TOP+LEFT, TOP+RIGHT])
                    mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
        }
        //clear the channels in both directions
        //channel clear partial
        tag("channel")up(calculated_base_height-0.02) fwd(grid_size/4-grid_clearance/2)
            channelDeleteTool([Material_Thickness, grid_size/2+0.02, Channel_Depth+0.02], chamfer_edges=[TOP], anchor=BOT);
        //channel clear full length
        tag("channel")zrot(90)up(calculated_base_height-0.02)
            channelDeleteTool([Material_Thickness, grid_size+0.02, Channel_Depth+0.02], spike_count=2, chamfer_edges=[TOP], anchor=BOT);
        }//end gridfinity base
}

//End Channels
module NeoGrid_Straight_End_Top(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    diff(){
        //Channel Walls
            cuboid([ grid_size, Wall_Thickness*2+Material_Thickness, Channel_Depth], anchor=BOT){
            //top chamfer
                if(Enable_Fillets) edge_profile([BOT+FRONT, BOT+BACK, BOT+RIGHT])
                    mask2d_chamfer(Wall_Thickness/3);
        //Removal tool for channel
        attach(TOP, BOT, inside=true, shiftout=0.01, align=LEFT, spin=90)
                channelDeleteTool([Material_Thickness, grid_size-Partial_Channel_Buffer+0.02, Channel_Depth-Wall_Thickness+0.02]);
        }
    }
}

module NeoGrid_Straight_End_Base(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    //Straight Channel
    diff(){
        //Gridfinity Base
        if(Selected_Base == "Gridfinity")
            gridfinity_bin_bottom_grid( x = 1, y = quantup(Channel_Length, grid_size)/grid_size, anchor=BOT);
        //Flat Base
        if(Selected_Base == "Flat")
            cuboid( [grid_size, grid_size, Flat_Base_Thickness], chamfer=0.5, except=BOT, anchor=BOT);
        //Channel Walls
        up(calculated_base_height-0.01)
            cuboid([grid_size - grid_clearance, Wall_Thickness*2+Material_Thickness, Channel_Depth], anchor=BOT){
                //bottom chamfer
                tag("keep") //must label keep due to chamfering out an addition and not a diff. 
                    edge_profile_asym([BOT+FRONT, BOT+BACK])
                        xflip()mask2d_chamfer(5);
                //top chamfer
                    if(Enable_Fillets) edge_profile([TOP+FRONT, TOP+BACK])
                        mask2d_chamfer(Wall_Thickness/3);
                //Removal tool for channel
                attach(TOP, BOT, inside=true, shiftout=0.01, spin=90, align=LEFT)
                    channelDeleteTool([ Material_Thickness, grid_size-Partial_Channel_Buffer+0.02, Channel_Depth+0.02]);
            }
    }
}



module NeoGrid_L_Intersection_Top(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    //X Intersection Base
    diff(){ //small trick here. External chamfers auto-apply the "remove" tag. This is a workaround to keep the chamfers on the channel walls by renaming the remove tag.
        //Channel Wall X axis
        back(Material_Thickness/2+Wall_Thickness)
        cuboid([Wall_Thickness*2+Material_Thickness, grid_size/2+Wall_Thickness+Material_Thickness/2-grid_clearance/2, Channel_Depth], anchor=BOT+BACK){
            //inward chamfer
                edge_profile([BOT+LEFT, BOT+RIGHT])
                    mask2d_chamfer(Wall_Thickness/3); //chamfer half the wall thickness
        }
        //Channel Wall Y axis
        right(Material_Thickness/2+Wall_Thickness)
        cuboid([grid_size/2+Wall_Thickness+Material_Thickness/2-grid_clearance/2, Wall_Thickness*2+Material_Thickness, Channel_Depth], anchor=BOT+RIGHT){
        //inward chamfer
            edge_profile([BOT+FRONT, BOT+BACK])
                mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
            tag("remove")
                attach(TOP, TOP, inside=true, shiftout=0.01, align=LEFT, spin=90)
                channelDeleteTool([ Material_Thickness, grid_size/2+Material_Thickness/2-grid_clearance/2+0.02, Channel_Depth-Wall_Thickness+0.02], chamfer_edges=TOP, anchor=BOT+RIGHT);
        }
        //clear the channels in both directions
        //channel clear partial
        tag("remove")
            up(Wall_Thickness) back(Material_Thickness/2)
            channelDeleteTool([Material_Thickness, grid_size/2+Material_Thickness/2-grid_clearance/2+0.02, Channel_Depth-Wall_Thickness+0.02], chamfer_edges=TOP, anchor=BOT+BACK);
    }
}


module NeoGrid_L_Intersection_Base(Material_Thickness, Channel_Depth = 20, Wall_Thickness = 4, grid_size = 42){
    //X Intersection Base
    diff("channel"){ //small trick here. External chamfers auto-apply the "remove" tag. This is a workaround to keep the chamfers on the channel walls by renaming the remove tag.
        //Gridfinity Base 1x1 for all intersections.
        if(Selected_Base == "Gridfinity")
            gridfinity_bin_bottom_grid(x=1,y=1, anchor=BOT);
        //Flat Base
        if(Selected_Base == "Flat")
            cuboid( [grid_size, grid_size, Flat_Base_Thickness], chamfer=0.5, except=BOT, anchor=BOT);
        //Channel Wall X axis
        up(calculated_base_height-0.01) //attach to the top of the gridfinity base
            fwd(grid_size/4-grid_clearance/4-Material_Thickness/4-Wall_Thickness/2)
            cuboid([Wall_Thickness*2+Material_Thickness, grid_size/2+Wall_Thickness+Material_Thickness/2-grid_clearance/2, Channel_Depth], anchor=BOT){
                //bottom outward chamfer
                    edge_profile([BOT+LEFT, BOT+RIGHT])
                        xflip() //xflip to put the chamfer out rather than in
                            mask2d_chamfer(5); 
                //top inward chamfer
                    edge_profile([TOP+LEFT, TOP+RIGHT])
                        mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
            }
        //Channel Wall Y axis
        up(calculated_base_height-0.01)
            left(grid_size/4-grid_clearance/4-Material_Thickness/4-Wall_Thickness/2)
            cuboid([grid_size/2+Wall_Thickness+Material_Thickness/2-grid_clearance/2, Wall_Thickness*2+Material_Thickness, Channel_Depth], anchor=BOT){
            //bottom chamfer
                edge_profile_asym([BOT+FRONT, BOT+BACK, BOT+RIGHT], corner_type="sharp")
                    xflip() //xflip to put the chamfer out rather than in
                        mask2d_chamfer(5); 
            //top chamfer
                edge_profile([TOP+LEFT, TOP+RIGHT])
                    mask2d_chamfer(Wall_Thickness/3); //chamfer portion of the wall thickness
        }
        //clear the channels in both directions
        tag("channel")up(calculated_base_height-0.02) fwd(grid_size/4-grid_clearance/4-Material_Thickness/4)
            channelDeleteTool([Material_Thickness, grid_size/2+Material_Thickness/2-grid_clearance/2+0.03, Channel_Depth+0.04], chamfer_edges=TOP, anchor=BOT);
        tag("channel")up(calculated_base_height-0.02) zrot(90) back(grid_size/4-grid_clearance/4-Material_Thickness/4)
            channelDeleteTool([Material_Thickness, grid_size/2+Material_Thickness/2-grid_clearance/2+0.03, Channel_Depth+0.04], chamfer_edges=TOP, anchor=BOT);
        }//end gridfinity base
}

module NeoGrid_Vertical_Trim(Material_Thickness, Wall_Thickness = 4, Total_Trim_Width = 42, Middle_Seam_Width = 4, Total_Trim_Height = 40){
    diff()
    cuboid([Total_Trim_Width, Wall_Thickness*2+Material_Thickness, Total_Trim_Height], anchor=BOT){
        //cutouts
        attach([LEFT, RIGHT], LEFT, inside=true, shiftout=0.01)
            cuboid([Total_Trim_Width/2-Middle_Seam_Width/2, Material_Thickness, Total_Trim_Height+0.02]);
        //chamfers
        edge_profile([BOT+FRONT, BOT+BACK, TOP+FRONT, TOP+BACK])
            mask2d_chamfer(Wall_Thickness/3);
    }
}

/*

END NEOGRID MODULES

*/

/*

BEGIN GRIDFINITY MODULES

*/

module gridfinity_bin_bottom_grid(x, y, additionalHeight = 0.6, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[42*x-0.5, 42*y-0.5, 4.75+additionalHeight]){
        down((4.75+additionalHeight)/2)
        union(){
            up(4.75+additionalHeight/2-0.01)
                minkowski(){
                    cuboid([42*x-.5-outside_radius,42*y-0.5-outside_radius, additionalHeight]);
                    cyl(h=0.01, d=outside_radius, $fn=50);
                }
            translate([42/2-42/2*x,42/2-42/2*y,0])
                for (i = [0:x-1]){
                    for (j = [0:y-1]){
                        translate([i*42, j*42, 0]){
                            gridfinity_bin_bottom(anchor=BOT);
                        }
                    }
                }
        }
    children();
    }
    
}

//Gridfinity bin bottom profile with inside radius added (for minkowski)
base_profile_adj = [
                    [0,0], //start at inner profile
                    [inside_radius,0], //start at inner profile
                    [0.8+inside_radius, 0.8], //up and out 0.8
                    [0.8+inside_radius, 0.8 + 1.8], //up 1.8
                    [0.8 + 2.15+inside_radius, 0.8 + 1.8 + 2.15], //up and out 2.15
                    [0, 0.8 + 1.8 + 2.15] //back to inside
                ]; //Gridfinity Bin Bottom Specs

module gridfinity_bin_bottom(additionalHeight = 0, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[41.5, 41.5, 4.75]){
                translate(v = [-(35.6-inside_radius*2)/2,-(35.6-inside_radius*2)/2,-4.75/2]) 
                    rotate(a = [0,0,0]) 
                        minkowski() {
                            rotate_extrude($fn=50) 
                                    polygon(points=base_profile_adj); //Gridfinity Bin Bottom Specs
                            cube(size = [35.6-inside_radius*2,35.6-inside_radius*2,0.01+additionalHeight]);
                        }
    children();
    }
}
module gridfinity_base() {
    difference() {
        cube(size = [42,42,4.65]);
        /*
        baseplate delete tool
        This is a delete tool which is the inverse profile of the baseplate intended for Difference.
        Using polygon, I sketched the profile of the base edge per gridfinity specs.
        I then realized I need rounded corners with 8mm outer diameter, so I increased the x axis enough to have a 4mm total outer length (radius).
        I rotate extrude to created the rounded corner 
        Finally, I used minkowski (thank you Katie from "Hands on Katie") using a cube that is 42mm minus the 8mm of the edges (equalling 34mm)
        I also added separate minkowski tools to extend the top and the bottom for proper deleting
        */
        union() {
            //primary profile
            translate(v = [4,38,5.65]) 
                rotate(a = [180,0,0]) 
                    minkowski() {
                        rotate_extrude($fn=50) 
                                polygon(points = [[0,0],[4,0],[3.3,0.7],[3.3,2.5],[1.15,4.65],[0,4.65]]);
                        cube(size = [34,34,1]);
                    }
            //bottom extension bottom tool
            translate(v = [4,4,-2]) 
                    minkowski() {
                        linear_extrude(height = 1) circle(r = 4-2.85, $fn=50);
                        cube(size = [34,34,6]);
            }
            //top extension
                translate(v = [4,4,5])
                    minkowski() {
                        linear_extrude(height = 1) circle(r = 4, $fn=50);
                        cube(size = [34,34,2]);
            }
        }
    }
}