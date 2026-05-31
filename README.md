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

### 2. Parametric 3D Image Relief & Badge Generator (`image_relief/`)

A highly versatile generator that converts any black & white or grayscale PNG image into a 3D printable relief, badge, or coin.

*   **Customizable Backing Shapes**: Supports rectangular (`rectangle`), rounded-rectangle (`round_rect`), and circular (`circle`) bases.
*   **Automatic Scaling**: Simply input the image dimensions in pixels and the target physical size in mm, and the model handles all proportional scaling.
*   **Aesthetic & Rendering Optimizations**: Employs structural `intersection()` clipping to eliminate square image corners on circular badges, and a micro Z-sink offset to completely resolve Z-fighting in OpenSCAD previews, delivering a clean dual-color render.

#### Files
*   `image_relief/image_relief.scad` - The parametric image relief generator source.
*   `image_relief/logo.png` - The optimized 8-bit grayscale, 256x256 "No Phone" icon ready for rendering.
*   `image_relief/image_relief.3mf` - The exported 3D model of the "No Phone" badge, ready for slicing.

#### 3D Printing Advice
*   **Multi-Color Slicing**: Slices the model so that the backing plate prints in one color (e.g. White or Red) and the protruding relief prints in a contrasting color (e.g. Black). Add a `Color Change` (M600 command) in your slicer at the exact layer where the relief starts to protrude (e.g. 2.0mm height).
