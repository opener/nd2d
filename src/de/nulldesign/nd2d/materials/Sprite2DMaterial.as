/*
 *
 *  ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 *  Author: Lars Gerckens
 *  Copyright (c) nulldesign 2011
 *  Repository URL: http://github.com/nulldesign/nd2d
 *
 *
 *  Licence Agreement
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 * /
 */

package de.nulldesign.nd2d.materials {
    import de.nulldesign.nd2d.utils.TextureHelper;

    import flash.display.BitmapData;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.textures.Texture;
    import flash.geom.Point;
    import flash.geom.Vector3D;

    public class Sprite2DMaterial extends AMaterial {

        [Embed (source="../shader/Sprite2DMaterialVertexShader.pbasm", mimeType="application/octet-stream")]
        private static const MaterialVertexProgramClass:Class;

        [Embed (source="../shader/Sprite2DMaterialFragmentShader.pbasm", mimeType="application/octet-stream")]
        private static const MaterialFragmentProgramClass:Class;

        [Embed (source="../shader/Sprite2DVertexShader.pbasm", mimeType="application/octet-stream")]
        private static const VertexProgramClass:Class;

        public var texture:Texture;
        public var bitmapData:BitmapData;
        //protected var blurTexture:Texture;
        //protected var textureDimensions:Point;

        public var color:Vector3D = new Vector3D(1.0, 1.0, 1.0, 1.0);

        protected var spriteSheet:SpriteSheet;

        public function Sprite2DMaterial(bitmapData:BitmapData, spriteSheet:SpriteSheet = null) {
            this.bitmapData = bitmapData;
            this.spriteSheet = spriteSheet;
            this.drawCalls = 1;
        }


        override public function handleDeviceLoss():void {
            super.handleDeviceLoss();
            texture = null;
        }

        override protected function prepareForRender(context:Context3D):Boolean {

            super.prepareForRender(context);

            if(!texture && bitmapData) {
                texture = TextureHelper.generateTextureFromBitmap(context, bitmapData, true);
            }

            if(!texture) {
                return false;
            }

            // TODO SET TEXTURE BY NAME!!!
            context.setTextureAt(0, texture);

            parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "color",
                                                           Vector.<Number>([ color.x, color.y, color.z, color.w ]));

            var offset:Point = new Point();

            if(spriteSheet) {
                offset = spriteSheet.getOffsetForFrame();
            }

            parameterBufferHelper.setMatrixParameterByName(Context3DProgramType.VERTEX, "objectToClipSpaceTransform",
                                                           clipSpaceMatrix, true);

            parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "uvOffset",
                                                           Vector.<Number>([ offset.x, offset.y ]));

            parameterBufferHelper.update();

            vertexBufferHelper.setVertexBuffers();

            return true;
        }

        /*
         override public function render(context:Context3D, faceList:Vector.<Face>, numTris:uint):void {
         if(true) {
         super.render(context, faceList, numTris);
         } else {
         renderBlur(context, faceList, numTris);
         }
         }

         protected function renderBlur(context:Context3D, faceList:Vector.<Face>, numTris:uint):void {

         generateBufferData(context, faceList);
         prepareForRender(context);

         if(!blurTexture) {
         textureDimensions = TextureHelper.getTextureDimensionsFromBitmap(bitmapData);
         blurTexture = context.createTexture(textureDimensions.x, textureDimensions.y,
         Context3DTextureFormat.BGRA, true);
         }

         // first pass
         context.setRenderToTexture(blurTexture, false, 2, 0);
         context.clear(0.3, 0.3, 0.3);

         var m:Matrix3D = new Matrix3D();
         m.appendScale(1 / textureDimensions.x * 2, -1 / textureDimensions.y * 2, 1.0);

         context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
         context.drawTriangles(indexBuffer, 0, numTris);

         // second pass
         context.setRenderToBackBuffer();
         context.setTextureAt(0, blurTexture);
         context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, clipSpaceMatrix, true);
         context.drawTriangles(indexBuffer, 0, numTris);

         clearAfterRender(context);
         }
         */
        override protected function clearAfterRender(context:Context3D):void {
            super.clearAfterRender(context);
            context.setTextureAt(0, null);
        }

        override protected function initProgram(context:Context3D):void {
            if(!vertexProgram) {
                vertexProgram = readFile(VertexProgramClass);
                materialVertexProgram = readFile(MaterialVertexProgramClass);
                materialFragmentProgram = readFile(MaterialFragmentProgramClass);
            }

            super.initProgram(context);
        }
    }
}
