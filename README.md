# Supermicro_ATX_Power_Supply_Adapter
Mount a redundant Supermicro power supply in your Fractal Define S2 chassis

Pictures, parts list, build instructions, and installation instructions are found on [Hackaday.io](https://hackaday.io/project/177892-supermicro-to-atx-power-supply-adapter).

This model is rendered as one big unit in OpenSCAD.  However, this model is simply too big to be printed on a Prusa MK3s printer.  The solution was to break it up into thirds.  To generate an STL file for each third of the model, follow these instructions:

1. Open the file 'Supermicro_ATX_PSU_Adapter_v3.scad' in OpenSCAD
2. Scroll all the way down to the bottom and look for lines like this:
   - // Star (*) to Keep "PDB Third" in Render
   - // Star (*) to Keep "Middle Third" in Render
   - // Star (*) to Keep "AC Cable Third" in Render
3. Add a star (*) to two of the three "translate" statements
4. Hit F6 in OpenSCAD to render the model
5. After the render, export the render to an STL file
6. Rise and repeat steps 3-5 for the other two "thirds"
7. At this point, you should have three STL files for all three thirds of the model

NOTE:  If you are not making changes to the "AC Cable Third", then use the file 'Supermicro_ATX_PSU_Adapter_v1_AC_Cable_Third.stl'.  This v1 revision doesn't have some extra tabs that exist in the v3 revision.  


## Quick Preview
This is a closeup of the finished product, installed in a [Fractal Define S2 case](https://www.fractal-design.com/products/cases/define/define-s2-tempered-glass/blackout/).

![alt](https://cdn.hackaday.io/images/1121301614209501376.JPG)
