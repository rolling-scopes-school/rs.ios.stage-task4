# Fill With Color

An image is represented by an `m x n` integer grid image where `image[i][j]` represents the pixel value of the image. 

In turn, three integers are given (`row, column, newColor`). It is necessary to fill the image with color starting from the pixel image - `image[row][column]`.

To perform a color fill, consider the starting pixel, plus any pixels connected 4-directionally to the starting pixel of the same color as the starting pixel, plus any pixels connected 4-directionally to those pixels (also with the same color), and so on. Replace the color of all of the aforementioned pixels with newColor.

Return the modified image after performing the color fill.

## Example 1

![alt text](https://i.ibb.co/vYS16VP/example.png)

**Input: image = [[1, 1, 1], [1, 1, 0], [1, 0, 1]], row = 1, column = 1, newColor = 2**

**Output: [[2, 2, 2], [2, 2, 0], [2, 0, 1]]**

**Explanation:** From the center of the image with position (row, column) = (1, 1) (i.e., the red pixel), all pixels connected by a path of the same color as the starting pixel (i.e., the blue pixels) are colored with the new color.
Note the bottom corner is not colored 2, because it is not 4-directionally connected to the starting pixel.

## Example 2

**Input: image = [[0, 0, 0], [0, 0, 0]], row = 0, column = 0, newColor = 10**

**Output: [[10, 10, 10], [10, 10, 10]]**

## Example 3

**Input: image = [[1, 1, 1], [0, 1, 0], [1, 1, 1]], row = 5, column = 5, newColor = 10**

**Output: [[1, 1, 1], [0, 1, 0], [1, 1, 1]]**

**Explanation:** Return input image, because row > m or column > n.

## Constraints

**`m == image.length`**  
**`n == image[i].length`**  
**`1 <= m, n <= 50`**  
**`0 <= image[i][j], newColor < 65536`**  
**`0 <= row <= m`**  
**`0 <= column <= n`**  
