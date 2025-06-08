# davis-pigment-mixing
Implementation of kubelka-munk mixing for GLSL

## What is it?
It's a lot of math that means we can blend colors together in a way that mimics pigments and paints instead of mixing colors like they're light.

## What does that mean?
Basically every computer program that mixes colors together does it in a way that is based on how light is mixed.
    i.e. If you have a yellow light and a blue light, you'll get a grayish color that isn't very nice to look at

Forever ago(1931), Kubelka and Munk proposed that we could do a lot of math to mix colors together so that when we try and mix blue and yellow we get green.

A few other people came along to take into account things like thickness and opaqueness of the layers of pigments and a lot of people have made very narrow implementations, that are very good, but not very extensible.

Considering the far reach of GLSL - I'm hoping that this is extensible.

## List of data types that you'll use
```
pigment {
    k = float[],
    s = float[]
}
```
## List of functions that you'll use
```
mix_pigments(pigment, pigment, mix_value)
    returns pigment

pigment_to_srgb(pigment)
    returns vec3/color
```
## How does it work?
This project contains the GLSL file that contains all the math and a pigment data type that you can use to blend all of the colors together.

Currently White, Black, Red, Yellow, and Blue are included which should unlock every pigment you can imagine(but I am planning on adding more in the future).

Attached are a couple projects that you can use to see how to use the functions and pigments to blend together.

**visualize.frag** is a blend of the colors in a fairly pleasing way

**compare-blue-yellow.frag** compares how most programs mix blue and yellow compared to what I've got here

It's mostly straightforward and you can use something like [glslViewer](https://github.com/patriciogonzalezvivo/glslViewer.git) to preview what's going on.

Just remember to use

```
#include "davis-km.glsl"
```

when creating your own shaders.

## Creating more pigments
I've added an 'extra-colors.glsl' file that acts as a nice library of new colors. 
    
Just define a new pigment and use the colors available.

The primary colors created were made to be saturated and around a 50 HSL value but I still wanted them to be a little more pleasing to look at then the raw color. This can technically limit the amount of colors you can make so I'm adding the Excel file I used to create the colors. Just adjust the reflectance and you should be fine to add add the k-values and s-values to your new pigment definition.

Understand that calculating new S and K values can be pretty time intensive at first and it's recommended to use the availbale functions unless you really need to.

If you are insistent on making new base colors - make sure to take a screenshot of your new color if it still needs adjustments and then drop it into photoshop or something similar, then sample it and make adjustments in RGB and HSL values. Changes to RGB values should inform you on how to change the reflectance in the Excel workbook and the HSL changes should inform you about changes to the S values but that has a very neglible effect since your K is derived from reflectance + S and should only really make a difference due to rounding errors.

### License Things

MIT License

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


(It's also not necessary but if this helped you in your project I'd like to hear about it)
