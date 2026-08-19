
- use @export_flags_2d_navigation to set tile_mask
- use exclusive fullscreen other than fullscreen

- @export var before _ready()

#### Design
- no grid map

#### Organize
- one node, one responsibility
- keep assets near to node
#### Transform2D
- Negative X scales in 2D are not decomposable from the transformation matrix. Due to the way scale is represented with transformation matrices in Godot, negative scales on the X axis will be changed to negative scales on the Y axis and a rotation of 180 degrees when decomposed.

####  Subview
- size_override * scale = size, in other word, size_override = origin_size
