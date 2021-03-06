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

package {
    import avmplus.getQualifiedClassName;

    import de.nulldesign.nd2d.display.Scene2D;
    import de.nulldesign.nd2d.display.World2D;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DRenderMode;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    import flash.text.TextField;

    import flash.text.TextFormat;

    import flash.ui.Keyboard;

    import tests.CameraTest;
    import tests.Font2DTest;
    import tests.Grid2DTest;
    import tests.MassiveSpriteCloudTest;
    import tests.MassiveSpritesTest;
    import tests.MaterialsTest;
    import tests.ParticleExplorer;
    import tests.ParticleSystemTest;
    import tests.SideScrollerTest;
    import tests.SpriteAnimTest;
    import tests.SpriteHierarchyTest;
    import tests.SpriteTest;
    import tests.StarFieldTest;
    import tests.TextureRendererTest;

    //[SWF(width="1000", height="550", frameRate="60", backgroundColor="#000000")]

    public class Main extends World2D {

        private var scenes:Vector.<Scene2D> = new Vector.<Scene2D>();
        private var activeSceneIdx:uint = 0;

        private var sceneText:TextField;

        public function Main() {

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            super(Context3DRenderMode.AUTO, 60, true);

            //statsVisible = false;

            scenes.push(new MassiveSpritesTest());
            scenes.push(new MassiveSpriteCloudTest());
            scenes.push(new SpriteHierarchyTest());
            scenes.push(new Font2DTest());
            scenes.push(new Grid2DTest());
            scenes.push(new SpriteTest());
            scenes.push(new SpriteAnimTest());
            scenes.push(new StarFieldTest());
            scenes.push(new ParticleSystemTest());
            scenes.push(new TextureRendererTest());
            scenes.push(new SideScrollerTest());
            //scenes.push(new MaterialsTest());
            scenes.push(new CameraTest());
            //scenes.push(new ParticleExplorer());

            var tf:TextFormat = new TextFormat("Arial", 11, 0xFFFFFF, true);

            sceneText = new TextField();
            sceneText.width = 300;
            sceneText.defaultTextFormat = tf;

            addChild(sceneText);

            stage.addEventListener(Event.RESIZE, stageResize);
            stageResize(null);

            activeSceneIdx = 10;
            nextBtnClick();

            stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
        }

        // simulate device loss
        private function keyUp(e:KeyboardEvent):void {
            if(e.keyCode == Keyboard.D) {
                context3D.dispose();
            } else if(e.keyCode == Keyboard.SPACE) {
                nextBtnClick();
            }
        }

        private function nextBtnClick():void {

            camera.reset();

            sceneText.text = getQualifiedClassName(scenes[activeSceneIdx]) + " // hit space for next test.";

            setActiveScene(scenes[activeSceneIdx++]);

            if(activeSceneIdx > scenes.length - 1) {
                activeSceneIdx = 0;
            }
        }

        private function stageResize(e:Event):void {
            sceneText.x = 5;
            sceneText.y = stage.stageHeight - 20;
        }
    }
}
