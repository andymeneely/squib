Specifying Colors & Gradients
=============================

Colors can be specified in a wide variety of ways, mostly in a hex-string. Take a look at the examples from `samples/colors.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/colors.rb}

Under the hood, Squib uses the `rcairo` [color parser](https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb) to accept a variety of color specifications, along with over [300 pre-defined constants](https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb). The above sample will generate a table of such constants.

Additionally, in most places where colors are allowed, you may also supply a string that defines a gradient. Squib supports two flavors of gradients: linear and radial. Gradients are specified by supplying some xy coordinates, which are relative to the card (not the command). Each stop must be between 0.0 and 1.0, and you can supply as many as you like. Colors can be specified as above (in any of the hex notations or built-in constant). If you add two (or more) colors at the same stop, then the gradient keeps the colors in the in order specified and treats it like sharp transition.

The format for gradient strings look like this:

Linear:
```
(x1,y1)(x2,y2) color1@stop1 color2@stop2
```
The xy coordinates define the angle of the gradient.

Radial:
```
(x1,y1,radius1)(x2,y2,radius2) color1@stop1 color2@stop2
```
The coordinates specify an inner circle first, then an outer circle.

Check out the following sample from `samples/gradients.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/gradients.rb}
