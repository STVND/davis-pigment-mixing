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
If you would like to define more colors you can create a new color struct by defining something like this:

```
const pigment WHITE = pigment(
    float[](
        1.06,0.9,0.39,0.13,0.05,0.01,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01
    ),
    float[](
        0.2,0.22,0.24,0.26,0.29,0.31,0.33,0.35,0.37,0.39,0.42,0.44,0.46,0.48,
        0.5,0.52,0.55,0.57,0.59,0.61,0.63,0.65,0.68,0.7,0.72,0.74,0.76,0.78,
        0.81,0.83,0.85,0.87,0.89,0.91,0.94,0.96,0.98,1.0
    )
);
```

You would just need to replace the float values for K and S within the struct to get a new color.

Instead of making it incredibly tedious to ensure you have the correct number of entries in your array and making you do all the math by hand - I've included an excel sheet with formulas attached to give you the K arrays.

Just edit the reflectance value for each wave length and you should be fine. If your pigment is coming in a little dark you can increase the S values for each band - typically both of these values are able to be found online but if you need help I would generally look up something like "Blue reflectance curve" into Google and use a site like [Syntax of Color]("https://www.syntaxofcolor.com/s-projects-basic") to review color curves.

I didn't use any of these color curves specifically and looked at a few research papers and websites to get a better idea of how to better shape them but generally speaking you can click on the color curves of a color group and get a good idea of how to build it.

Additionally, if you don't like the color you've gotten I would take a screenshot and put it into photoshop, affinity, gimp, w/e and sample the color and start playing with rgb sliders until you get a color that you like and start adjusting your curves to better match what you did.

For example, my red was coming in a little orange so I needed to drop my green wavelengths' reflectance and increase my blue wavelengths'. Then when I noticed it was a bit dim I increased the S value of my reds so that it was brighter.