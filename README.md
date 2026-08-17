
- use @export_flags_2d_navigation to set tile_mask
- keep assets near to node
- use exclusive fullscreen

- @export var before _ready()

- no grid map

- Negative X scales in 2D are not decomposable from the transformation matrix. Due to the way scale is represented with transformation matrices in Godot, negative scales on the X axis will be changed to negative scales on the Y axis and a rotation of 180 degrees when decomposed.

####  Subview
- size_override * scale = size, in other word, size_override = origin_size
