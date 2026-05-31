# 3D Models

A repository for parametric 3D models designed for 3D printing.

## Models Included

### 1. Parametric Desk Schoolbag Hook (`desk_hook/`)

An E-shape clamp hook designed to be clipped onto the edge of a desk to hang schoolbags, backpacks, or headphones.

*   **Fully Parametric**: You can open `desk_hook.scad` in OpenSCAD and use the **Customizer** panel to change the desk thickness, clamp depth, material thickness, hook radius, etc.
*   **Rounded Edges & Fillets**: Features smooth outer corners and structural reinforcement fillets at inner corners to prevent snapping under heavy loads.
*   **Optimized for 3D Printing**: Designed to be printed flat on its side for maximum tensile strength.

#### Files
*   `desk_hook/desk_hook.scad` - The parametric OpenSCAD source file.
*   `desk_hook/desk_hook.stl` - The exported 3D mesh ready for slicing and printing.

#### 3D Printing Advice
> [!IMPORTANT]
> **Print this model lying flat on its side (on the flat X-Y plane of the extrusion).**
> Printing it sideways ensures that the continuous printed plastic paths run the full length of the "E" shape and hook, providing maximum load capacity. Printing it upright will make it highly susceptible to snapping along layer lines under a heavy bag's weight.
