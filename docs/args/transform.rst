:orphan:

angle
  default: ``0``

  Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky.

crop_x
  default: ``0``

  Crop the loaded image at this x coordinate. Supports :doc:`/units`.

crop_y
  default: ``0``

  Crop the loaded image at this y coordinate. Supports :doc:`/units`.

crop_corner_radius
  default: ``0``

  Radius for rounded corners, both x and y. When set, overrides crop_corner_x_radius and crop_corner_y_radius. Supports :doc:`/units`.

crop_corner_x_radius
  default: ``0``

  x radius for rounded corners of cropped image. Supports :doc:`/units`.

crop_corner_y_radius
  default: ``0``

  y radius for rounded corners of cropped image. Supports :doc:`/units`.

crop_width
  default: ``:native``

  Width of the cropped image. Supports :doc:`/units`.

crop_height
  default: ``:native``

  Height of the cropped image. Supports :doc:`/units`.

flip_horiztonal
  default: ``false``

  Flip this image about its center horizontally (i.e. left becomes right and vice versa).

flip_vertical
  default: ``false``

  Flip this image about its center verticall (i.e. top becomes bottom and vice versa).
